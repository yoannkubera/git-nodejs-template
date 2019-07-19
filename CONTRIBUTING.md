# Contributing

> Documentation related to the contribution to the project

<!-- DOCTOC INCLUDE --><a name='----'></a>__Table of contents__
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Unterstanding the project](#unterstanding-the-project)
  - [Git tags and version numbers](#git-tags-and-version-numbers)
  - [Git branches](#git-branches)
  - [Base files](#base-files)
    - [Package JSON](#package-json)
  - [Base directories](#base-directories)
  - [Automation of tasks](#automation-of-tasks)
- [Setup a development environment](#setup-a-development-environment)
  - [Installation](#installation)
  - [Further configuration](#further-configuration)
- [Taking part in the development](#taking-part-in-the-development)
  - [Developpers/coders](#developperscoders)
    - [How-tos](#how-tos)
    - [Developper commitments](#developper-commitments)
  - [Maintainers](#maintainers)
    - [How-tos](#how-tos-1)
  - [Planners / Reporters](#planners--reporters)
    - [How-tos](#how-tos-2)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Unterstanding the project

### Git tags and version numbers

The stable versions of the project are registered as tags, named after the rules
provided in [Semantic Versioning 2.0.0](https://semver.org/). Each tag is named
_"vMAJOR.MINOR.PATCH"_, where:

* __MAJOR__ is an integer incremented when you make incompatible API changes (in
  that case, _MINOR_ and _PATCH_ are reset to `0`);

* __MINOR__ is an integer incremented when you add functionality in a
  backwards-compatible manner (in that case _MAJOR_ remains the same and _PATCH_
  is reset to `0`);

* __PATCH__ is an integer incremented when you make backwards-compatible bug fixes
  (in that case _MAJOR_ and _MINOR_ remain the same).

The first tag to be released is always `v0.1.0` (_i.e._ version `0.1.0` of the
project).

### Git branches

<div align="right">
  <b><a href="#----">↥ back to top</a></b>
</div>

The project revolves around five types of git branches <sup>a</sup>, described toroughly in
the article [A successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/).

[![](./doc/img/CONTRIBUTING/git-branch-model.png)](./doc/img/CONTRIBUTING/git-branch-model.png)

In this project, the branches are:

* The `master` branch hosts the __Stable versions__ (_a.k.a._ releases / tags) of
  the software. Such versions are production ready and can be installed and
  used by end users;

* The `current-candidate` branch hosts the __Current release candidate__ of the
  software <sup>b</sup>.
  This version is not yet a stable version because of missing features;

* Branches starting with `dev-` (_e.g._ `dev-parallel-download`) host the development
  of a specific __Feature__ of the software.
  They are merged into the current release candidate once fully developed
  and tested.
  Such branches are short lived, and deleted once the development of the feature
  has finished;

* Branches starting with with `bug-` (_e.g._ `bug-dl-timeout`) host the development
  of the correction of critical bugs witnessed in stable versions <sup>c</sup>.
  Such branches are short lived, and deleted once the bugfix is released;

* Branches starting with `release-` (_e.g._ `release-v1.0.5`) are temporary and
  used to prepare the merge of a branch into another branch.
  They encompass situations like:

    * The publication of the _current release candidate_ as a new _stable version_;

    * The integration of a _feature_ into the _current release candidate_;

    * The integration of a _bugfix_ as a new _stable version_;

    * The integration of a _bugfix_ into the _current release candidate_.

__The instructions to use and maintain such a structure are detailed in the [branch
management guide](doc/git/branch-management.md).__ The guide includes the git
instructions to write, who should write them, and when they should be used.

__Notes:__

<sub>_a)_ This model assumes that no more than one major version is maintained at a
time.</sub>

<sub>_b)_ In the original article, the branch is called `develop`. The name
`current-candidate` is used instead since it depicts more accurately its role
(since feature and hotfix branches are also places where developments take
place).</sub>

<sub>_c)_ In the original article, these branches are called `hotfix` branches.

### Base files

<div align="right">
  <b><a href="#----">↥ back to top</a></b>
</div>

The project contains many files at its root that are used to keep metadata about
the project itself:

* `.gitattributes` is a git-specific file defining rules about the committing,
  diffing or merging (_e.g._ automatically resolve conflicts, how to handle
  carriage returns, _etc._);

* `.gitignore` is a git-specific file identifying the files that should be stored
  only locally (_e.g._ temporary files, user-specific files, _etc._);

* `LICENSE` is a plain text file containing the text of the license of the project;

* `package-lock.json` is a mandatory nodejs-specific file automatically generated
  when the software or its dependencies are installed;

* `package.json` is a nodejs-specific file providing various information about
  the project like its name, its description, its current version, its
  dependencies, their versions, how to distribute the software as a package, _etc._


Other files are used to reflect the current state of the project:

* `AUTHORS.md` is a markdown file listing the contributors of the project;

* `CHANGELOG.md` is a markdown file providing an history of the released versions
  of the project and their features;

* `FEATURE.md` is a markdown file describing the feature currently being developped
  in a feature branch;

* `NEW-FEATURES.md` is a markdown file describing the changes in the project since
  the last release.

Finally, the other files at the root of the project are documentation entrypoints:

* `CONTRIBUTING.md` is the entrypoint in the project for developpers;

* `DEPENDENCIES.md` provides a pretty representation of the dependencies of the
  project;

* `Readme.md` is the main entrypoint in the project for anyone.

#### Package JSON

The `package.json` file provides many data about the project. It is recommended
to keep it up-to-date, since it is the source of automatic update of many elements
of the project.

To ensure that this file can properly interact with the automation scripts of the
project, some restrictions are put on that file:

* A non-standard key `release_date` providing the release date of the current
  version of the project;

* The `license` should not use complex SPDX license expression syntax (_"AND"_,
  _"OR"_ or _"WITH"_ keywords). Idealy, they should use the [license keyword from
  the help of GitHub](https://help.github.com/en/articles/licensing-a-repository)
  rather than the [SPDX identifiers](https://spdx.org/licenses/).

### Base directories

<div align="right">
  <b><a href="#----">↥ back to top</a></b>
</div>

The project relies on the following main directories:

* `assets/` containing the assets of the software (fonts, skeletons);

* `bin/` containing helper scripts related to the development of the project (see
  the [branch management guide](doc/git/branch-management.md) for details);

* `core/` containing the source code of the core of the software;

* `doc/` containing the markdown documentation of the software;

* `scrapers/` containing the source code of the available scrapers for this
  software. Scrapers support the download of novel data from a specific source;

* `test/` containing the tests of the software.

In addition, the project relies on the automatically generated directories:

* `.git/` containing all git related data of the project (commit history, branches,
  _etc._);

* `.github/` containing all github related data of the project (_e.g._ issues templates);

* `node_modules/` containing all the locally installed nodejs packages.

### Automation of tasks

To make the development easier, some tasks are automated through scripts in the
`bin/` directory of the project:

* `doc.update.bash` updates the content of the Markdown documentation of the project
  with data that can be extracted from the `package.json` file: project current
  version, release date, description, author, maintainers, contributors, license,
  engine, os, dependencies, _etc._ It generates makdown text, badges, table of
  contents at various places of the documentation;

* `git.pre-commit.bash` runs various checks that have to be done before a commit,
  and fails with an error code if the project should not be committed in its
  current state. This script should be called automatically as a pre-commit hook
  of git.

## Setup a development environment

<div align="right">
  <b><a href="#----">↥ back to top</a></b>
</div>

This software:

* Relies on the [typescript](https://www.typescriptlang.org) superset of the
  javascript language;

* Was developped using the [Atom editor](https://atom.io/).

### Installation

<div align="right">
    <b><a href="#----">↥ back to top</a></b>
</div>

To install a development environment (on Ubuntu):

* Install the __Git__ content manager system;

  * Follow the installation instructions provided on the [Git SCM website](https://git-scm.com/);

  * Configure your user data by using the following terminal commands (where
    _NAME_ and _EMAIL_ should be replaced by actual values):

    ```bash
    git config --global user.name "NAME"
    git config --global user.mail "EMAIL"
    ```

* Install the __Atom__ editor;

  * Follow the installation instructions provided on the [atom website](https://atom.io);

  * Install the typescript parser with the following terminal commands:

    ```bash
    apm install atom-ide-ui
    apm install atom-typescript
    ```

* Install usefull development utilities used in the project, using the terminal
  commands:

  ```bash
  sudo apt-get install gridsite-clients jq
  ```

* Install __nodeJS__ and the __NPM__ package manager: follow the instructions provided on the  [node.js website](https://nodejs.org/);

* Clone the sources of the Browsvel project:

  ```bash
  git clone git@github.com:yoannkubera/browsvel.git
  ```

* Install the dependencies of this package, using the terminal command from the
  newly created _"browsvel/"_ directory:

  ```bash
  npm install
  ```

Then open the _Atom_ editor and use the _"File > Add Project Folder..."_
menu. Browse the file system and select the _"browsvel/"_ directory to open the
project in Atom.

### Further configuration

<div align="right">
    <b><a href="#----">↥ back to top</a></b>
</div>

#### Git

By default, git becomes a mess when remote changes have to be included after local
commits (especially before a `pull`). This behavior leads to ungraceful artificial
commits to catch up with the remote repository, having messages like:

> Merge branch 'NAMEofBRANCH' of URLofREPOSITORY into NAMEofBRANCH

The following git configuration command in a terminal can avoid such commits:

```bash
git config --gobal pull.rebase preserve
```

This option will, when pulling, replay all local commits starting from the most
recent remote commit. If there are no conflicts to solve, then no new commit
will be required before pushing.

## Taking part in the development

In the project, we distinguish various roles involved in the development:

* __Developpers/coders__ are people taking part in the development of the
  features and/or of the bug-fixes of the project;

* __Maintainers__ are people ensuring that the branches of the project are
  properly maintained and merged when necessary. They are responsible of the
  various releases as well as the creation/destruction of branches. Branch
  creation requests (for instance for new features) and branch merge (for
  instance when the development of a feature ended) of developpers have to go
  through them;

* __Planners/Reporters__ are people posting issues on the repository in order to
  either report problems/bugs or plan the development of new features.

### Developpers/coders

<a name="dev-howtos"></a>
#### How-tos

<div align="right">
  <b><a href="#----">↥ back to top</a></b>
</div>

* [Start a new feature?](doc/git/devs/feature-opening.md)

* [Take part in a feature in development?](doc/git/devs/feature-dev.md)

* [Publish a finished feature?](doc/git/devs/feature-release.md)

* [Take part in a bug fix?](doc/git/devs/bugfix-dev.md)

* [Publish a bug fix?](doc/git/devs/bugfix-release.md)

* [Write the documentation of the project?](doc/git/devs/doc-redaction.md)

#### Developper commitments

<div align="right">
  <b><a href="#----">↥ back to top</a></b>
</div>

In order to keep a clean and proper project, developpers participating in this
project implicitly agree to comply with the following rules:

1. Adding your name in the contributors list of the [AUTHORS.md](AUTHORS.md)
   file you shall;

1. Properly indenting your code you shall;

1. Extensively commenting your code in both the header and the body of
   the file/function/classes you shall;

1. Including the [licensing text](LICENSE) as a comment in the header of the
   source files you shall;

1. Mentioning the origin of the images in a local `sources.md` file you shall;

1. [Squashing your commits](doc/git/squash.md) before pushing you will;

1. Merging you won't, unless it is to update with remote changes within your
   branch;

### Maintainers

<a name="maintainers-howtos"></a>

#### How-tos

<div align="right">
  <b><a href="#----">↥ back to top</a></b>
</div>

* [Manage new requests (features,fixes,bugs)?](doc/git/maintainers/manage-requests.md)

* [Start a new feature?](doc/git/maintainers/start-new-feature.md)

* [Release a feature in the current candidate version?](doc/git/maintainers/release-feature.md)

* [Start a bugfix?](doc/git/maintainers/start-bugfix.md)

* [Release a bugfix?](doc/git/maintainers/release-bugfix.md)

* [Release a new version?](doc/git/maintainers/release-version.md)

### Planners / Reporters

<a name="reporters-howtos"></a>

#### How-tos

<div align="right">
  <b><a href="#----">↥ back to top</a></b>
</div>

* [Plan the development of a new feature](doc/git/reporters/plan-feature.md)

* [Request a new feature](doc/git/reporters/request-feature.md)

* [Request a correction](doc/git/reporters/request-fixture.md)

* [Report a bug](doc/git/reporters/report-bug.md)
