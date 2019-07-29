require 'erb'
include ERB::Util

packages = [
  {name: "coq-io", namespace: "Io"},
  {name: "coq-io-system", namespace: "Io.System"},
  {name: "coq-io-list", namespace: "Io"},
  {name: "coq-io-exception", namespace: "Io"},
  {name: "coq-io-evaluate", namespace: "Io"},
]

for package in packages do
  name = package[:name]
  namespace = package[:namespace]
  versions = `opam show #{name} --field=all-versions`.split(' ').map{|version| version.strip}
  repository = `opam show #{name} --field=url.src:`.match(/coq-io\/([a-z\-]+)\//).captures[0]
  for version in versions do
    target_documentation_directory = "doc/#{repository}/#{version}"
    command = "test ! -d #{target_documentation_directory} && opam install #{name}.#{version} -y -j4 --keep-build-dir"
    puts command
    if system(command) then
      sources_directory = "#{`opam config var prefix`.strip}/.opam-switch/build/#{name}.#{version}"
      system("mkdir -p #{sources_directory}/html")
      if system("cd #{sources_directory}/src && coqdoc -R . #{namespace} -d ../html --toc --utf8 *.v") then
        system("mkdir -p #{target_documentation_directory}")
        system("cp #{sources_directory}/html/* #{target_documentation_directory}")
      end
    end
  end
end

File.open("doc/index.html", "w") do |f|
  f << ERB.new(File.read("doc/index.html.erb", encoding: "UTF-8")).result(binding)
end
