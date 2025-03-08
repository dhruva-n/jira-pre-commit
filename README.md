# jira-pre-commit

A [`pre-commit`](https://pre-commit.com) hook to check commit messages for
[Conventional Commits](https://conventionalcommits.org) formatting.

## Usage

Make sure `pre-commit` is [installed](https://pre-commit.com#install).

Create a blank configuration file at the root of your repo, if needed:

```console
touch .pre-commit-config.yaml
```

Add a new repo entry to your configuration file:

```yaml
repos:
  - repo: https://github.com/erskaggs/jira-pre-commit
    rev: v1.0.4
    hooks:
      - id: jira-pre-commit
        stages: [commit-msg]
```

Install the `pre-commit` script:

```console
pre-commit install --hook-type commit-msg
```

Make a (normal) commit without a jira ticket:

```console
$ git commit -m "add a new feature"
Jira Ticket Key..........................................................Failed
- hook id: jira-pre-commit
- exit code: 1

Aborting commit. Your commit message is missing either a JIRA Issue, i.e. JIRA-1234.

```

Make a commit with a jira ticket
```console
$ git commit -m "JIRA-1234 add a new feature"
Jira Ticket Key..........................................................Passed
```

## Commit Message Guidelines

- Commit titles must follow the Conventional Commits format:
  - Format: type(scope?): description
  - Valid types include:
    - feat: A new feature
    - fix: A bug fix
    - docs: Documentation changes
    - style: Formatting, missing semi-colons, etc; no code change
    - refactor: Code change that neither fixes a bug nor adds a feature
    - perf: Performance improvements
    - test: Adding or correcting tests
    - build: Changes that affect the build system or external dependencies
    - ci: Changes to CI configuration and scripts
    - chore: Other changes that do not modify src or test files
    - revert: Reverts a previous commit

### Examples

Good commit messages:
- Single-line commit:
  - feat: Add user authentication
  - fix: Resolve login error for invalid credentials
- Multi-line commit:
  - 
    ```
    feat: Add user authentication

    Introduces JWT-based login for enhanced security.
    JIRA-1234
    ```
- Breaking change (note the "!" indicating a breaking change):
  - 
    ```
    refactor!: Update API endpoint structure

    Modify endpoints to support versioning.
    JIRA-5678
    ```

Bad commit messages:
- Missing commit type:
  - Add user authentication feature
- Invalid commit type:
  - ticket: Implement new payment system
- Missing description:
  - fix:
- For multi-line commits, missing JIRA ticket on the last line:
  - 
    ```
    feat: Implement new dashboard layout

    Improves UI for better usability.
    ```

> Note: For single-line commit messages (using git commit -m), only the title is validated. For multi-line commit messages, the last non-empty line must include a valid JIRA ticket (e.g., JIRA-1234).

## Versioning

Versioning generally follows [Semantic Versioning](https://semver.org/).

In addition to the strict version tag, we also maintain a "latest" tag for each
major version, e.g. `v1` always points to the latest `v1.x.x` tag.

## License

[Apache 2.0](LICENSE)

Inspired by matthorgan's [`pre-commit-conventional-commits`](https://github.com/matthorgan/pre-commit-conventional-commits).
