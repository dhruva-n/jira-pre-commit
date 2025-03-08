#!/usr/bin/env bash

# set this to your active development branch
develop_branch="develop"
current_branch="$(git rev-parse --abbrev-ref HEAD)"
# regex to validate in commit msg
commit_regex='([A-Z]+-[0-9])'
conventional_commit_regex='^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-zA-Z0-9_-]+\))?!?:\s.+'
error_msg="Aborting commit. Your commit message is missing either a JIRA Issue, i.e. JIRA-1234, or the jira key is not IN ALL CAPS."
conventional_error_msg="Aborting commit. Your commit message must follow the Conventional Commits format (type(scope): description)."

# Check if input is a file or direct message
if [ -f "$1" ]; then
    # Input is a file
    commit_msg=$(cat "$1")
    commitTitle="$(head -n1 "$1")"
    # Count non-empty, non-comment lines
    lineCount=$(grep -v "^#" "$1" | sed '/^$/d' | wc -l)
    # Get last non-empty, non-comment line
    lastLine=$(grep -v "^#" "$1" | sed '/^$/d' | tail -n 1)
else
    # Input is direct message
    commit_msg="$*"
    commitTitle="$*"
    # For direct input, consider it a single line
    lineCount=1
    lastLine="$*"
fi

# ignore merge requests
if echo "$commitTitle" | grep -qE "^Merge branch \'"; then
  echo "Commit hook: ignoring branch merge"
  exit 0
fi

[ "$current_branch" == "$develop_branch" ] && exit 0

# Check if the commit title follows conventional commits format
if ! echo "$commitTitle" | grep -qE "$conventional_commit_regex"; then
    echo "$conventional_error_msg" >&2
    exit 1
fi

# For single line commits (git commit -m), don't enforce JIRA ticket
if [ "$lineCount" -eq 1 ]; then
    # No JIRA ticket check for single-line commits
    exit 0
# For multi-line commits, check if the last line contains a JIRA ticket
elif [ "$lineCount" -gt 1 ]; then
    if ! echo "$lastLine" | grep -qE "$commit_regex"; then
        echo "Aborting commit. For multi-line commits, the last line must include a JIRA ticket (e.g., JIRA-1234)." >&2
        exit 1
    fi
fi