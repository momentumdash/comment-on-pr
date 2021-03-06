# Issue Number Commenter on PR via GitHub Action

A GitHub action to comment issue number when a PR is opened.
issue number can be found from PR title or Branch name.
Will check if issue number has been commented before and will not comment again if so.

## Finds PRO-* Issues

## Usage

- Requires the `GITHUB_TOKEN` secret.
- Supports `pull_request` event types.

Create the following file in the root directory of your project 
`.github/workflows/issue-comment-on-pr.yml`

### issue-comment-on-pr.yml

```yaml
name: comment issue number on PR

on: 
  pull_request:
    types: [opened]

jobs:
  comment:
    runs-on: ubuntu-latest

    steps:
      - name: comment issue number on PR
        uses: momentumdash/comment-on-pr@master
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
