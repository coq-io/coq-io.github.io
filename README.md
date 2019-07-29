# coq-io.github.io
Documentation of the [Coq.io](http://coq.io/) libraries.

To generate:
```
ruby make.rb
```
This will attempt to install the different versions of each library, if its documentation directory is missing. In particular, this may recompile Coq many times. A solution is to pin Coq to a specific version, and proceed several times with different Coq versions until all the documentation is generated.
