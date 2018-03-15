# dotfiles
These are my dots which I have uploaded to easily apply them across different machines, and in hopes that it might be helpful to you as well.

## Topics
Configs are organized around topics (like those of [holman](https://github.com/holman/dotfiles)), and the internal structure is such that it can be easily un/linked with GNU Stow.

## Different devices
One issue I have and feel hasn't been properly solved is the management of configs that are different on each machine. For now, each device (currently laptop and desktop) has received its own folder, and topics specific to those are placed in there. When I wish to apply these settings, I run Stow from within those directories rather than the root, e.g.: `stow -t ~ <package>|*`. Files common to all systems have their own folder in the root directory.

## System wide configs
Another problem I encountered is the management of system wide config files (such as those in `/etc`). There is no good solution for this yet, so for now there is a separate `etc` directory, and when I need to apply settings in there (currently only global zsh files), I run from within `etc` the following command: `sudo stow -t /etc/<folder> <folder>` for folders and `sudo stow -t /etc <file>` for individual files.

If you know of better solutions, please don't hesitate to let me know.
