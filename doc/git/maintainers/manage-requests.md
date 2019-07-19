[&#x21A9; Back to the contribution guide](../../../CONTRIBUTING.md#maintainers-howtos)

# Manage new requests (features,fixes,bugs)?

> As a maintainer, what has to be done to go from the issue describing an expected
> feature, a feature request to its actual development?

Once someone (a planner or reporter) requests/plans the development of a new
feature, an inappropriate content fix, a bug fix or documentation/tests updates,
a corresponding issue will be added to the issue tracker, with one of the tags
`feature` (new feature request), `doc` (documentation related additions), `test`
(missing tests), `invalid` (invalid/inappropriate content fixing) or `bug` (bug
fix), together with a tag `request`.

From that point on, maintainers have to go through various steps to manage the
requests properly, and end up with either droping the request or validating it
and create the appropriate branches:

1. Request review
1. Review aftermath
  * Drop requests
  * Develop requests

## Managing requests

Maintainers have first to discuss the request and determine if the matter is appropriate
enough for the project:

* If the proposed feature is appropriate and necessary for the project, and should
  be developped;
* If the documentation related additions are worth the time, and should be inclued;
* If the proposed tests are appropriate, non-trivial and necessary, and should be
  developped and added to the project;
* If the invalid / inappropriate content requires a fix and is worth the effort;
* If the reported bug really exists and is a bug worth the correction.

Once the decision is made, the maintainer will remove the `request` tag of the
issue, and replace it with one of the following tags:

* `dropped` if the request is denied, or deemed as inappropriate or not useful.
  In addition, the issue has to be closed with a comment providing the reason for
  the discontinuation of the request;

* `confirmed` if the request is accepted, but its development is not yet planned.
  This label will be later be changed to `developping` once the development date
  will be set;

* `developping` if the request is accepted, and its development will immediately
  start. In such a case, a new branch dedicated to this development will be
  created, by following the either the [new bugfix instructions](start-new-bugfix.md)
  (if the issue reported a bug) or [new feature instructions](start-new-feature.md)
  (for any other issue).
  In addition, the content of the issue will be updated with information detailed
  in the instructions.
