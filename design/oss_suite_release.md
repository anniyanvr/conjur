# Conjur OSS Suite Release

## Feature Overview
In this effort, we intend to build a formal release process for the _Conjur OSS Suite_,
which we define as the set of components including the Conjur server, deployment utilities,
command line interface (CLI), client libraries, and integrations with platforms and DevOps tools.

At current, we have no formal process for releasing the full suite of tools in
the Conjur OSS ecosystem so that:
- It is clear to end users which version of Conjur OSS they should use, and what
  integrations and tooling are compatible with that version.
- Key use cases that involve more than two components working together are automatically
  tested to ensure that the end-to-end experience in those use cases works as expected.
- Development can continue on the master branch of individual components while
  end users have a reliable way to pull "stable" releases for all components and
  avoid unexpectedly running "edge" releases .
- It is clear what features are officially released and which are still in progress -
  at current, there is no way to easily track unreleased features in our broad suite
  of tools and integrations, and formally creating a system for tracking unreleased
  features will help us to do a better job of comprehensively testing and releasing
  completed features.

In this effort, we will build a formal Conjur OSS Suite Release process to begin
addressing these concerns.

## Key Characteristics of Conjur OSS Suite Release
- All key components of the Conjur OSS Suite will be grouped into a single
  Conjur OSS Suite Release
- There is a special [release repository](https://github.com/cyberark/conjur-oss-suite-release)
  that is used to:
  - Pin the versions of the components included in the suite release
  - Automatically run test suite against versions pinned in the suite release daily
  - When the pinned component versions are changed and the suite version is
    incremented:
    - Automatically generate GitHub releases that include release notes with links
      to artifacts
    - Automatically generate a documentation-friendly release page that includes
      a table of contents, release notes for each component, and links to artifacts.
    - Automatically update our [homebrew](https://github.com/cyberark/homebrew-tools)
      and [helm charts](https://github.com/cyberark/helm-charts)
  - Document how end users should utilize the Conjur OSS Suite Release

In addition, as part of building this release, we'll also be creating:
- A [GitHub landing page](https://cyberark.github.io/conjur) that links to the
  repos included in the Conjur OSS Suite and describes what each one does.
- A template to be added to the READMEs of repos in the Conjur OSS Suite to clarify
  about the state of the code on master ("edge") and to encourage end users to
  visit the Conjur OSS Suite Release to determine which versions of each product
  to use.
- A tool for visualizing the unreleased changes in the components of the Conjur OSS
  Suite Release, to help us in understanding whether a new OSS Suite Release is
  needed

## Repositories Included in the Conjur OSS Suite Release
- Conjur OSS Core
  - [Conjur OSS](https://github.com/cyberark/conjur)
    - [Conjur OSS Helm Chart](https://github.com/cyberark/conjur-oss-helm-chart)
    - [Conjur OSS Cloudformation Templates](https://github.com/cyberark/conjur-aws)
  - [Conjur CLI](https://github.com/cyberark/conjur-cli)
  - Client Libraries
    - [Golang](https://github.com/cyberark/conjur-api-go)
    - [Java](https://github.com/cyberark/conjur-api-java)
    - [.Net](https://github.com/cyberark/conjur-api-dotnet)
    - [Python 3](https://github.com/cyberark/conjur-api-python3)
    - [Ruby](https://github.com/cyberark/conjur-api-ruby)
- Integrations
  - [Ansible](https://github.com/cyberark/ansible-conjur-host-identity)
  - Cloud Foundry
    - [Service broker](https://github.com/cyberark/conjur-service-broker)
    - [Buildpack](https://github.com/cyberark/cloudfoundry-conjur-buildpack)
  - [Jenkins](https://github.com/cyberark/conjur-credentials-plugin)
  - Kubernetes / OpenShift
    - [Kubernetes authenticator client](https://github.com/cyberark/conjur-authn-k8s-client)
  - [Puppet](https://github.com/cyberark/conjur-puppet)
  - [Terraform](https://github.com/cyberark/terraform-provider-conjur)
- Secrets Delivery
  - [Secretless Broker](https://github.com/cyberark/secretless-broker)
  - [Summon](https://github.com/cyberark/summon)
    - [Summon AWS Secrets Provider](https://github.com/cyberark/summon-aws-secrets)
    - [Summon Chef Databags Provider](https://github.com/cyberark/summon-chefapi)
    - [Summon Conjur Provider](https://github.com/cyberark/summon-conjur)
    - [Summon Keyring Provider](https://github.com/cyberark/summon-keyring)
    - [Summon S3 Provider](https://github.com/cyberark/summon-s3)

## Considerations

### How CyberArk Dynamic Access Provider (DAP) Will Use the OSS Release
At current, when a new DAP appliance is built it is based on a manually pinned
version of Conjur OSS. We propose implementing automation as part of this release
to auto-update the pinned version of Conjur OSS used in DAP with each new OSS
Suite Release, so that DAP stays consistent with the latest stable release of
Conjur OSS.

### Open Questions

- How do we ensure new documented features available in the Conjur OSS Suite Release
  are appropriately propagated to the DAP documentation?
  - We propose this is out of scope for this effort, and should be decided in a
    follow-on effort by the DAP team together with the technical writers.
  - Based on the way documentation currently works, it is likely that new features
    in the Conjur OSS suite will require additional testing and documentation to
    certify the new features for DAP in follow-on efforts.
- How will DAP (built on the open Conjur core) run tests against the non-server
  components of the Conjur OSS suite to ensure the enterprise product remains
  compatible with the OSS components that are certified for DAP?
  - We propose this is out of scope for this effort, and should be decided in a
    follow-on effort by the DAP team (similarly to how the documentation changes
    will work abovce).
- What certification level will each component in the Conjur OSS Suite Release have?
  Should this be evaluated as part of this effort?
- What should the initial scope of the automated tests for the Conjur OSS suite
  release be?
  - Proposal: The OSS release suite should include an end-to-end test for a single
    use case: Deploy Conjur OSS with Helm Chart to GKE and enable an app to connect
    to its database via Secretless using credentials pulled from Conjur.
  - Individual repos are responsible for running their own integration tests against
    Conjur. The suite release test suite will enable integration testing multiple
    components together (not just Component X + Conjur), and as part of the initial
    effort we'll implement one such use case and ensure we're set up to add other
    such use cases as we identify them in the future.
  - Should the scope of this project include evaluating the component repositories
    to determine the state of the automated tests and whether additional integration
    tests need to be added?
  - When a new suite release is being prepared, is there a way to run the automated
    integration tests in each of the components such that the specific versions
    that will be included in the release will be tested together? If so, is there
    a way to visualize the status of this set of builds?
- What updates do we want to make to the official documentation to ensure end users
  are aware of the OSS suite releases?
- Assuming we follow semantic versioning as usual for the OSS suite release, what does
  a major version bump mean?
  - Proposal: Since the core of this suite is the Conjur server, we would not bump
    the major version of the suite unless the major version of Conjur changes.
  - When other components are updated with breaking changes (eg a complete redesign),
    rather than change the major version we may manually update the release to
    include the new version as well as the old one and announce a deprecation timeline
    for the old version before it is removed from the release entirely.
- Are all of the Summon providers part of the Conjur OSS Suite Release, or just the
  Summon Conjur Provider? If not, should we have a separate Summon Suite release?
  Should we consider moving to Summon2 (the version of Summon built into Secretless,
  that includes all providers)?

### Out of Scope
- Including any other public repositories beyond those listed above in the initial
  Conjur OSS Suite Release or on the GitHub landing page.
- Creating a landing page with any functionality beyond a curated list of Conjur
  OSS Suite repositories, with descriptions and links.
- Implementing more than the framework for end-to-end tests and a very basic
  initial end-to-end test for the Conjur OSS Suite. For more comprehensive test
  coverage, we will continue to rely on the integration tests written in the
  individual components, and in future efforts we will review their
  comprehensiveness and determine potential improvements / ways to leverage the
  central Conjur OSS Suite Release repo.
- Automatically including deprecated versions of components during temporary
  deprecation windows.
- Plans for addressing security vulnerabilities in collaboration with downstream
  projects.

### Future Work
- Augmenting landing page to have an easy way to submit a GitHub issue and be
  directed to the right repo's backlog.
- Creating a template for the user-facing READMEs of the component repos beyond
  just directing them to the OSS suite (eg what basic info should always be included
  in the GitHub READMEs, which by custom in open source contains basic usage info).
- Published contributor guidelines are available in a central place in GitHub.

## User Stories

### Open Source Users

|||
|---|---|
|AS A|Conjur Open Source user|
|I WANT|to know what tools and integrations there are for Conjur|
|SO THAT|I can evaluate whether Conjur is suitable for me to use, and which tools / integrations are compatible with my systems.|

|||
|---|---|
|AS A|Conjur Open Source user|
|I WANT|to know what versions of Conjur OSS components to use|
|SO THAT|I am using reliable, well-tested software that works together as expected when used within my systems.|

### OSS Suite Component Maintainers

|||
|---|---|
|AS A|maintainer of a Conjur OSS suite component|
|I WANT|to know how to ensure new versions of my component get into the OSS suite release|
|SO THAT|OSS users can benefit from new features my team is adding to our component.|

|||
|---|---|
|AS A|maintainer of a Conjur OSS suite component|
|I WANT|to know what I'm responsible for testing and what will be tested in the OSS suite|
|SO THAT|it's clear what tests I need to include and maintain in my component repository, and which tests belong in the central OSS suite release repo.|

|||
|---|---|
|AS A|maintainer of a Conjur OSS suite component|
|I WANT|to know what standards I need to maintain in my repository|
|SO THAT|my CHANGELOG entries, releases, READMEs, etc are compatible with the OSS suite release.|

### Conjur OSS Contributors

|||
|---|---|
|AS A|Conjur Open Source contributor|
|I WANT|to know what components there are|
|SO THAT|I can find components that I can contribute to.|

|||
|---|---|
|AS A|Conjur Open Source contributor|
|I WANT|to know what is included in the Conjur OSS suite|
|SO THAT|if there are tools or platforms that are not supported, I can make a difference by building something to fill the gap.|

### Conjur OSS Suite Release Managers

|||
|---|---|
|AS A|Conjur release manager|
|I WANT|o know what changes have been made to components since the last suite release|
|SO THAT|I can decide if enough changes have been made to merit a new release.|

|||
|---|---|
|AS A|Conjur release manager|
|I WANT|to know how to create a new release, including any manual steps that are required|
|SO THAT|I can successfully create a new release without missing any steps.|

|||
|---|---|
|AS A|Conjur release manager|
|I WANT|to know the results of automated tests|
|SO THAT|I can be sure all included components work together as expecteed at the pinned versions.|


### Developer of Project With Conjur Core
|||
|---|---|
|AS A|developer on a downstream project that uses Conjur as its core|
|I WANT|to know when there are new Conjur OSS suite releases|
|SO THAT|I can review the changes and update my project to use the latest OSS suite release version of Conjur.|

|||
|---|---|
|AS A|developer on a downstream project that uses Conjur as its core|
|I WANT|a machine readable summary of what is included in each OSS suite release|
|SO THAT|I can build automation around the OSS suite releases as needed.|

## High-Level Technical Design

The [OSS Suite Release Repo](https://github.com/cyberark/conjur-oss-suite-release)
will include:
- A user-facing README with a high level overview of how Conjur OSS end users
  should leverage the repo, with links to appropriate pages in the official documentation
- A VERSION file that includes the current version of the OSS suite release
- A machine-readable file with the pinned versions included in the current release
- Version tags for each OSS suite release version that correspond to GitHub releases
  that are comprised of auto-generated release notes with links to relevant artifacts
- Scripts for manually or automatically generating releases, which include:
  - GitHub release notes, including change log release notes and links to artifacts
    for each component version included in the release
  - Documentation website-friendly release description, including change log release notes and
    links to artifacts for each component version included in the release
- Scripts for automatically updating our [homebrew](https://github.com/cyberark/homebrew-tools)
  and [helm charts](https://github.com/cyberark/helm-charts) for new suite release
  versions
- A test suite that can be run manually or automatically to test the pinned versions
  included in the release
  - It will be designed so that new test cases can be added as needed going forward
  - The initial test case will test deploying Conjur OSS to GKE using the Helm Chart
    and enabling a sample app to connect to its database via Secretless using credentials
    pulled from Conjur
- A test suite that can be run manually or automatically, and that runs daily against
  the latest versions of all OSS suite components (optional)
- A CONTRIBUTING.md guide for contributors to OSS suite releases (including release
  managers, component contributors, and component maintainers) that includes:
  - Guidelines for building new releases, including any manual steps
  - Guidelines for component repositories to ensure there is a consistent pattern
    for CHANGELOGs, tags, and versioning and tags are not added to component repositories
    unless the build is green.

The GitHub landing page will include:
- An organized view of the GitHub repositories that are part of the Conjur OSS Suite Release

The Conjur OSS documentation will include:
- A page for Conjur OSS Suite releases
- Updates to the "Get Started" flow and/or to OSS suite component pages directing
  end users to use

The GitHub repositories for OSS Suite components will include:
- Updated READMEs that include a snippet on using the versions available in the latest
  Conjur OSS Suite Release when using the given component
- Updated standards for creating component releases to ensure they are compatible with
  the OSS suite release

The Dynamic Access Provider project will include:
- An automatic process for proposing a version bump in the Conjur core version when a
  new Conjur OSS suite release is published
