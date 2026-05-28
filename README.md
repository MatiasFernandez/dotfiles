# dotfiles

My personal macOS dotfiles for a dev environment.

## What's included

- **Zsh** config with [antidote](https://getantidote.github.io/) plugin manager (powerlevel10k, autosuggestions, syntax highlighting, fzf-tab, completions, atuin history search)
- **Git** config with 40+ aliases and GitHub CLI credential integration
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
dev/         rails, heroku, pnpm, localstack, docker, sqitch, pryrc
homebrew/    Brewfile, brew-wrap init
zoxide/      shell init (zsh + bash)
networking/  latency monitors, public IP
utils/       general helpers, fns picker
```

Extensions: `.src` sourced by both shells, `.zsh` zsh-only, `.bash` bash-only, `.symlink` linked to `~/`.

## Private config

Both `~/.bashrc.mine` and `~/.zshrc.mine` will source `~/.priv-dotfiles/` if it exists — useful for secrets and machine-local overrides that shouldn't live in a public repo.
