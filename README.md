# git-sync
A small utility script to sync local Git repos with remote.

It works by looping over the user's `home/` directory for folders containing a `.git` sub-directory. Users are given an option to check the local repo against remote and, only if the user wants, runs `git pull`.

By using `git remote update; git status -uno`, the local repo is checked against remote _before_ running `git pull`. This is safer than running `git pull` outright over each repo, since overwriting local repos  may have unintended effects. 

## Prerequistes
1. Environment to run Bash scripts
2. Git, grep, and sed installed (should be available on most UNIX and GNU/Linux devices)

## How to Use
The script can be run as follows:
```bash
cd src/
bash git-sync.sh
```
When prompted, enter `y` or `n` at each repository to proceed with checking for updates (non-breaking check).

If updates are available, enter `y` again to pull changes from remote.

## TODO
- [ ] Add further error catches and print helpful error messages
- [ ] Add a small `man` page
- [ ] Implement further tests on different environments

## License
Licensed under BSD 3-Clause.
