[&#x21A9; Back to the contribution guide](../../../CONTRIBUTING.md#maintainers-howtos)

# How to start a new feature?

> As a maintainer, what has to be done to go from the issue describing an expected
> feature (or a feature request) to its development?

Once maintainers decided to start the development of a new feature/a content
correction/a test/a documentation, various actions have to be done until reaching
a state where the development can actually be done:

<!-- DOCTOC INCLUDE --><a name='----'></a>
<!-- START doctoc -->
<!-- END doctoc -->

## Identification of proper descriptors

Maintainers have first to identify some information about the developped feature:

* Come up with a feature branch name for the developped feature.
  This name should always start with the `dev-` prefix.
  In this part of the documentation, this value will be written `FEATURE_BRANCH`;

* Come up with a short name for the feature. It has to be a short phrase.
  In this part of the documentation, this value will be written `FEATURE_NAME`;

* Come up with a markdown description of the feature and how it should be developped.

## Creation of the new feature branch

<div align="right">
  <b><a href="#----">↥ back to top</a></b>
</div>

The second step of the process requires the maintainer to create a new local branch
where the feature will be developped in the future. The starting point of the branch
will always be the current candidate version (branch `current-candidate`). This
is achieved by using the following commands from a terminal started in the root
directory of the project:

```bash
git checkout -b BRANCHNAME
```

## Initialization of the feature branch

<div align="right">
  <b><a href="#----">↥ back to top</a></b>
</div>

Once the branch exists, it has to be initialized by creating a file descriptor
of the feature, and then has to be sent to the remote repository.

For that purpose, a file `FEATURE.md` has to be added to the root of the project.
This file should use the following template:

<pre>
&lt;!-- branch: FEATURE_BRANCH --&gt;
&lt;!-- name: FEATURE_NAME --&gt;
# New feature

* __Feature developped in this branch:__ FEATURE_NAME
* __Corresponding issue(s) on github:__ ISSUES_LIST

## Short description

TODO_SHORT_DESC

## Instructions

TODO_INSTRUCTIONS
</pre>

In that template, the first two HTML comment are mandatory, since the maintenance
scripts of the project rely on them to publish the feature.
The text `ISSUES_LIST` has to be replaced by a commat separated list of the number
of each issue that resulted in the creation of this feature branch.
The text `TODO_SHORT_DESC` (_i.e._ the short description) has to be
replaced by a concise description of what the developped feature should be/should
do.
Finally, the text `TODO_INSTRUCTIONS` has to be replaced by a more practical
description, focusing on any information that can help developpers in
creating the feature (class names and organization, pseudo code, _etc._).

Once the file is created, the local changes in the branch have to be validated
with the git `add` command:

```bash
git add -A
```

Then, the branch has to be updated and pushed on the repository, using a provided
script.

__Important notes:__

* After the git `add` command, the `commit` __should NOT__ be called. This will
  be done automatically by the script;

* The script can fail if the `FEATURE.md` file was not properly created. In that
  case, the branch will stay local and won't be pushed on the remote repository.

The script is `bin/git/feature.start.bash`, and is called from a terminal
opened at the root of the project wit the command:

```bash
bash bin/git/feature.start.bash
```

## Update of the issue

<div align="right">
  <b><a href="#----">↥ back to top</a></b>
</div>

Then, the creation of the branch has to be reflected on the issue(s) that led to
the creation of this branch. For that purpose, the maintainer has first to identify
the first commit of the feature, by using the command:

```bash
git rev-parse --short FEATURE_BRANCH
```

This command will result with a text like `c4a69c0`. We will refer to that text
with `COMMIT_ID`.

The second step of the update of the issue consists in appending a new section to
the end of the issue body, using the following template:

<pre>
## Feature development

> Tells where the development of the resolution for the invalid content is done.
> This section has to be filled by a maintainer.

* __Feature name:__ FEATURE_NAME
* __Feature branch:__ FEATURE_BRANCH
* __Feature first commit:__ COMMIT_ID
</pre>

## Assignment of the developpers

<div align="right">
  <b><a href="#----">↥ back to top</a></b>
</div>

Eventually, the developpers should be informed that their request was granted,
and that they can start the development. This is done by the maintainer by
assigning the issue to them.
