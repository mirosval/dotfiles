---
name: jj
description: |
  use for working with jj (jujutsu) version control system
---

# JJ

This skill should clarify how to work with version control in general so that the agent doesn't interfere with the user's work.

There are 2 workflows, depending on how the repo is set up. These are actions the user will perform in the course of working with the repo. Do not perform any actions in these workflows without being specifically asked to.

## Single user repos

Where I am the sole committer and master is not protected, we usually commit directly to master.

1. `jj git fetch` to get the newest changes
2. `jj desc -m '<description>'` to describe the change
3. `jj bookmark set master -r@` to advance master
4. `jj git push` to push

## Multi-user repos

Work repos where master is protected and there are multiple users, we always work with branches/bookmarks.

The workflow:

1. Work starts by `jj git fetch`
2. `jj rebase -d master` to make sure we have the newest changes
3. `jj desc -m '<planned change description>'`
4. `jjbk` to create a bookmark from the current change description (see Scripts below)
5. actual work
6. `jjpr` to push and open the GitHub PR creation URL (see Scripts below)
7. If there are review changes, `jj new` to do fixes in a new changeset, `jj squash` to merge them

## Scripts

### jjbk

Creates a jj bookmark named from the current change description. The description must follow conventional commit format (`type: summary`). It slugifies the summary part and creates a bookmark named `type/summary-slug`.

```zsh
jjbk() {
    name=$(jj show --template "description" --no-patch --no-pager | \
        awk -F':' 'NR==1{
            t=tolower($2)
            gsub(/[^a-z0-9]+/,"-",t)
            sub(/^-|-$/,"",t)
            print $1 "/" t
        }')

    if [[ -z $name ]]; then
        print -u2 "Error: there was no description to generate bookmark from"
        return 1
    fi

    jj bookmark create --revision @ "$name"
}
```

### jjpr

Pushes the current revision to GitHub (`--allow-new` to create the remote branch if needed) and opens the PR creation URL in the browser.

```zsh
jjpr() {
    jj git push --allow-new 2>&1 | awk '/https:\/\/github.com\/.*\/pull\/new/ {print $2; exit}' | xargs open
}
```

## Reviewing

To review the current changes use `jj status` to get the changed files and/or use `jj diff --from master` to see all the changes.

## Resolving conflicts

When asked to resolve conflicts, in this case you can identify conflicted changesets using `jj log` and then switch to the earliest one using `jj edit`, create a new changeset on top usiing `jj new`, resolve the conflict and then `jj squash`. Repeat until all conflicts are resolved.

## Commands to avoid

Generally jj has undo, so most mistakes can be reverted with `jj undo` or inspecting the oplog. But it's important that you do not perform any writing jj operations unless specifically asked. 

Write operations include:

* jj commit
* jj desc
* jj git push
* jj rebase
* jj squash

## Allowed commands

Use these commands any time to gain understanding of the current changeset, or past changes.

* `jj status` to just get the list of changed files
* `jj log` with any parameters to find what revisions exist and how they relate to each other
* `jj diff` with `--from master` to see the whole PR or with `-r` and a specific revision
