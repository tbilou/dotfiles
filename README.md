# Dotfiles

### Changelog

* Stopped using ohmyzsh in favor of a custom configuration. Got inspiration from [Josean](https://www.josean.com) and [devops toolbox](https://github.com/omerxx/dotfiles)
* Still using powerlevel10k as prompt mostly because of the Transient feature. Tried using [Starship](https://starship.rs). Could kinda replicate what I'm used to but the lack of Transient was a deal breaker.
* Zsh configuration from https://thevaluable.dev/zsh-install-configure-mouseless/
* Added support for linux

## Config
### Gnu Stow
Just call `stow .` inside this folder for all the files to be symlinked to the parent directory.

I created the `.stow-local-ignore` to ignore certain files

### Public + private setup

Decided to make this repo public, so the work related configs are in another (private) repo
- public repo: `~/dotfiles`
- private repo: `~/dotfiles.work`

Then stow both repos into `~`.

Those local overlay paths are ignored here so they never get committed to the public repo.

### Linux setup
The top-level `.zshrc` dispatches to `.zshrc.linux` on Linux and `.zshrc.macos` on macOS.


### 1password
Create the symlink for the `.ssh/config` to work
```
mkdir -p ~/.1password && ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock
```
