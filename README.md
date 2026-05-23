# dotfiles

My personal macOS dotfiles for a Rails/Node/Go dev environment.

## What's included

- **Zsh** config with [antidote](https://getantidote.github.io/) plugin manager (autosuggestions, syntax highlighting, fzf, completions)
- **Git** config with 40+ aliases and GitHub CLI credential integration
- **Homebrew** [Brewfile](configs/macos/Brewfile) with my full toolset
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

```
configs/    tool configs (git, pry, Brewfile)
shell/      shell config organized by topic
install/    reserved for future install scripts
```

Shell topics under `shell/` each contain `.src` files (sourced at shell init) and `.symlink` files (linked to `~/`). Adding a new topic directory with a `.src` file is enough for it to be picked up automatically.

## Private config

Both `~/.bashrc.mine` and `~/.zshrc.mine` will source `~/.priv-dotfiles/` if it exists — useful for secrets and machine-local overrides that shouldn't live in a public repo.
