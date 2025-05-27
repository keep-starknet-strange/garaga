---
icon: file-doc
---

# Updating these docs

### Overview

Gitbook website is synced with the `docs` branch.

Documentation updates are handled through an automated bidirectional sync between the `main` and `docs` branches:

* **GitBook edits** → `docs` branch → automated PR to `main`
* **Code changes** → `main` branch → automated sync to `docs` branch

### Making Documentation Changes

#### For Contributors: PR to Main (Recommended)

1. Create a branch from `main`
2. Edit files in `docs/gitbook/` folder
3. PR directly to `main` branch
4. Changes will automatically sync to `docs` branch after merge and reflected on the website.

#### For Maintainers: GitBook Interface

Repo maintainers and selected contributors can edit directly in GitBook - changes automatically sync to the `docs` branch and create a PR to `main`.

### Automated Workflow

* **Documentation-only changes**: Auto-labeled and ready for review
* **Mixed changes** (docs + code): Flagged for manual review with `needs-review` label
* **Code changes on main**: Non-docs files automatically sync to `docs` branch
* All PRs use squash & merge to maintain clean history

The GitBook website updates automatically when changes reach the `docs` branch.
