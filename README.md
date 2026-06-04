# dotfiles

My personal macOS dotfiles for a dev environment.

## What's included

- **Zsh** config with [antidote](https://getantidote.github.io/) plugin manager (powerlevel10k, autosuggestions, syntax highlighting, fzf-tab, completions, atuin history search)
- **Git** config with 30+ aliases and GitHub CLI credential integration
- **Homebrew** [Brewfile](homebrew/Brewfile) with my full toolset
- **Pry** config with clipboard helpers
- Topic-organized shell functions and aliases (dev, git, networking, utils)

## Install

```bash
git clone https://github.com/MatiasFernandez/dotfiles ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

The bootstrap script will:
1. Prompt for your git author name and email
2. Ask which shell(s) to configure (bash, zsh, or both)
3. Install antidote via Homebrew (if zsh selected)
4. Symlink all config files to your home directory

## Structure

Topic-based layout — each top-level folder owns everything for that tool.

```
git/         gitconfig, git aliases
zsh/         zshrc, plugins, p10k theme, fns widget
bash/        bashrc, bash-only aliases, gitprompt
dev/         rails, heroku, pnpm, python, localstack, docker, sqitch, pryrc
homebrew/    Brewfile, brew-wrap init
zoxide/      shell init (zsh + bash)
networking/  latency monitors, public IP
utils/       general helpers, fns picker
```

Extensions: `.src` sourced by both shells, `.zsh` zsh-only, `.bash` bash-only, `.symlink` linked to `~/`.

## Documenting functions & aliases

Functions and aliases are made discoverable through the `fns` picker (run `fns`, or
press `Ctrl-F` in zsh) — a fuzzy finder that lists documented definitions that are
currently defined in the shell, and drops the selected name onto the command line.

To document a definition, put a comment of the form `## @<category> <description>` on the
line **directly above** it. Category is a single word (letters, digits, `_`, `-`).

```sh
## @utils Create a timestamped copy of a file
backup() { cp "$1" "$1_$(date +%Y%m%d_%H%M%S)"; }

## @docker docker-compose shorthand
alias dc="docker-compose"
```

Git aliases work the same way — add the comment above the alias inside the `[alias]`
section of [git/gitconfig.symlink](git/gitconfig.symlink); the picker inserts `git <name>`.

### Argument references — `{N}`

When a definition takes positional arguments, tag the word in the description that the
argument fills with `{N}`, where `N` is the argument position. This makes the mapping
between description and arguments explicit:

```sh
## @utils Find file matching pattern{1} inside directory{2}
ff() { find "$2" -type f -regex "$1"; }

## @rails Migrations created since commit{1}. Defaults to master
migr_since() { git whatchanged "${1-master}"..HEAD | grep "db/migrate"; }
```

Here `pattern{1}` ↔ `$1`, `directory{2}` ↔ `$2`. The tag attaches directly to the word
(no space) and may point at a literal default too (e.g. `port 9090{2}`). For aliases that
collect all arguments (`$*` / `$@`), tag the collective noun with `{1}` (e.g. `message{1}`).

## Private config

Both `~/.bashrc.mine` and `~/.zshrc.mine` will source `~/.priv-dotfiles/` if it exists — useful for secrets and machine-local overrides that shouldn't live in a public repo.
