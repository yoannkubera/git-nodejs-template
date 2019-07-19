<!-- DOCTOC INCLUDE -->
# Dependencies

> This file identifies the full list of dependencies of this project, and their
> version.

Note that the production related dependencies are automatically generated with
the pre commit scripts.

__Table of contents__
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Development-related](#development-related)
- [Production-related](#production-related)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Development-related

> Dependencies of the project when in the development mode, as well as the
> version that was used during development.
> It includes the tools used in git to maintain the project as well as the unix
> packages that had to be installed on an Ubuntu 18.04 LTS distribution.
>
> Versions of installed linux packages were obtained with `apt-cache policy PACKAGE`
> Versions of installed Atom packages were obtained with `apm ls|grep PACKAGE`

### General

> All purpose dependencies

* [atom](https://stedolan.github.io/jq/download/)
  (version `1.26.1-1~webupd8~0`)
  _A hackable text editor_

* [atom-ide-ui](https://atom.io/packages/atom-ide-ui)
  (version `0.13.0`)
  _A collection of Atom UIs to support language services (requirement for
  atom-typescript)_

* [atom-typescript](https://atom.io/packages/atom-typescript)
  (version `12.5.3`)
  _Typescript plugin of Atom_

* [gridsite-clients](http://manpages.ubuntu.com/manpages/bionic/man1/urlencode.1.html)
  (version `3.0.0~20180202git2fdbc6f-1build1`)
  _Debian package providing a features including a command line URL encoder (urlencode)_

* [jq](https://stedolan.github.io/jq/download/)
  (version `1.5+dfsg-2`)
  _Debian package providing a JSON command line parser_

### NodeJS

> NodeJS dependencies (installed with NPM)

<!-- Please keep the comment below to allow auto update -->
<!-- START dev-deps -->
 
* [doctoc](https://www.npmjs.com/package/doctoc) (version `^1.4.0`)
 
* [typescript](https://www.npmjs.com/package/typescript) (version `^3.5.3`)
 
<!-- END dev-deps -->
<!-- Please keep the comment above to allow auto update -->

And obviously all the dependencies in a production environment, described in the
next section.

## Production-related

> Dependencies of the production-ready version of the project.

### NodeJS

> NodeJS dependencies (installed with NPM)

<!-- Please keep the comment below to allow auto update -->
<!-- START prod-deps -->
 
The project has no such dependencies
 
<!-- END prod-deps -->
<!-- Please keep the comment above to allow auto update -->
