---
name: sync-dotfiles
description: Use whenever the user asks to sync, commit, or push dotfiles (e.g. "sync it with dotfiles", "push changes in dotfiles", "sync config and push", "update my dotfiles repo"). Mirrors live ~/.config into ~/dotfiles/.config via the repo's own dev-env script, picks the correct branch for this machine, screens for secrets, then commits and pushes without re-explaining the workflow each time.
---

# Sync dotfiles

`~/dotfiles` is a separate git repo (remote `origin` →
`https://github.com/rauf322/dotfiles.git`) from `~/.config` itself. `~/.config`
has no remote — it's local-only, used for editing. Publishing changes always
means mirroring `~/.config` into `~/dotfiles/.config` and committing/pushing
**there**, never adding a remote to `~/.config`.

## Branches — pick the right one first, every time

- **`main`** — this machine (personal, supermaven active).
- **`corporate-branch`** — a different (work) laptop where supermaven is
  unusable. It is `main` + exactly one commit removing
  `nvim/lua/plugins/supermaven.lua` (and its `pack.lua`/lockfile entries).

Before syncing, check the current branch:

```bash
cd ~/dotfiles && git branch --show-current
```

This machine's live `~/.config` has supermaven active, so **syncing from
here always targets `main`**. If `corporate-branch` is checked out, switch to
`main` first (see "Branch mismatch" below) — do not sync onto
`corporate-branch` from this machine.

## Workflow

1. **Check current branch**, switch to `main` if not already there (clean
   working tree first — `git status --short` should be empty before
   switching).

2. **Sync** (mirrors `~/.config` → `~/dotfiles/.config` via `rsync -a
   --delete`, respecting `dev-env`'s own skip/exclude lists — secrets,
   `.git`, `node_modules`, agent artifacts, app caches are already excluded
   by the script itself):

   ```bash
   cd ~/dotfiles && ./dev-env --copy:root:config
   ```

3. **Review the diff before committing**:
   ```bash
   git status --short | sort
   git diff | grep -inE "password|secret|token|api[_-]?key" | grep -v "^-"
   ```
   An empty grep result is clean. If something matches, stop and flag it —
   don't commit a leaked secret even if `dev-env`'s exclude list should have
   caught it.

4. **Watch for branch-specific divergence** showing up as unexpected
   untracked/deleted files (e.g. a file `main` has removed that
   `corporate-branch` doesn't, or vice versa). That means the wrong branch
   was checked out during sync — fix the branch, don't paper over the file.

5. **Commit** with a short, factual summary of what changed (matches this
   repo's existing style — e.g. `sync from ~/.config: nvim workspace-diagnostics
   removal, tsgo GOMEMLIMIT, meridian zsh wrapper, opencode + clockify
   additions`). List the actual areas touched, not a generic "sync" message.

6. **Push**:
   ```bash
   git push origin main
   ```
   No confirmation needed for this specific push — the user has standing
   authorized this dotfiles-sync-and-push workflow. (This does not extend to
   force-pushing, rewriting history, or pushing to `corporate-branch` without
   being asked.)

## Branch mismatch recovery

If `corporate-branch` is checked out and there are uncommitted changes from a
sync already run there:

```bash
cd ~/dotfiles
git stash                      # tracked changes only
git checkout main              # will fail if an untracked file (e.g.
                                # supermaven.lua) would be overwritten
# if it fails: diff the untracked file against main's tracked version;
# if identical, `rm` the untracked copy and retry `git checkout main`
git stash pop
```

## Other repos

This skill is scoped to `~/dotfiles` specifically. It does not grant standing
push authorization for any other repository — confirm those individually as
normal.
