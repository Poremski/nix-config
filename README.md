# Nix configuration

[![CI][ci-badge]][ci-link]
[![NixOS][nixos-badge]][nixos-link]
[![Home Manager][hm-badge]][hm-link]
[![Neovim][neovim-badge]][neovim-link]
[![License: MIT][license-badge]](LICENSE)

Personal NixOS configuration for `poremski`, a Lenovo ThinkPad X1 Carbon
Gen 7 running KDE Plasma 6. The configuration uses Nix flakes, NixOS 26.05,
Home Manager, and nixos-hardware. Dependencies are pinned in `flake.lock`.

## Disclaimer

This is a personal NixOS configuration, designed around my own hardware,
workflows, and preferences. It is not intended to be a generic drop-in setup.
Review and adapt it before applying it to your own machine. Use at your own risk.

## Host

- `poremski`: Lenovo ThinkPad X1 Carbon 7th Gen, KDE Plasma 6.
- User: `javier`.
- Hardware support: `nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen`.

Machine-specific disks and hardware settings are defined in
`hardware-configuration.nix`. Home Manager manages the user environment
as part of the NixOS configuration.

## Repository structure

- `flake.nix`: system definition, dependencies, formatter, and lint tools.
- `configuration.nix`: base settings and module imports.
- `hardware-configuration.nix`: machine-specific disks and hardware settings.
- `modules/`: desktop, laptop support, packages, Nix maintenance, Home Manager,
  ChatGPT, and 1Password.
- `home/javier.nix`: user environment, Bash, Git, GitHub CLI, and GPG agent
  with SSH support.
- `home/modules/`: Fish, SSH, development tools, terminal tools, editors, and KDE.
- `config/nvim/`: Neovim settings, keymaps, autocommands, and plugin setup.
- `bin/`: helper commands for rebuilding, updating, formatting, and linting.
- `packages/chatgpt/`: ChatGPT package definition.
- `modules/chatgpt.nix`: ChatGPT installation and nix-ld settings.
- `.github/workflows/ci.yml`: automated checks for pushes and pull requests.

## Bootstrap

Run these commands on NixOS with `nix-command` and `flakes` enabled.
The configuration targets the user `javier` and host `poremski`.
Before using it on another machine, adapt the disks, LUKS devices,
hardware profile, username, and GPG settings to your environment.

```bash
git clone https://github.com/Poremski/nix-config.git ~/.nix-config
cd ~/.nix-config
```

Build and temporarily activate the configuration for testing:

```bash
sudo nixos-rebuild test --flake .#poremski
```

Once the test succeeds, activate the configuration for future boots as well:

```bash
sudo nixos-rebuild switch --flake .#poremski
```

Home Manager is activated as part of the NixOS configuration.
GPG keys must be imported separately; private keys are not stored in this repo.

## Recovery

Revert to the previous system generation:

```bash
sudo nixos-rebuild switch --rollback
```

Prepare the current configuration for the next boot without activating it now:

```bash
sudo nixos-rebuild boot --flake .#poremski
```

## Daily environment

Fish is the login shell. Bash remains available. Home Manager and Plasma Manager
configure the user environment, including Breeze Dark and touchpad preferences.
Home Manager installs LibreOffice, VLC, qBittorrent, Kate, Thunderbird, Zed, and
development tools.
Docker and Docker Compose are available without `sudo`. Log out and back in after
the first activation so the new `docker` group membership takes effect. The SSH
client configuration is managed declaratively by Home Manager and uses the GPG
agent for SSH keys. Mullvad requires signing in to your account after activation.
KDE Connect and the ThinkPad keyboard-backlight indicator are enabled.

The repository's `bin` directory is added to your PATH after activation:

- `nix-rebuild`: activate the `poremski` configuration with
  `nixos-rebuild switch`.
- `nix-sync`: pull with `--ff-only`, then run `nix-rebuild`.
- `nix-update`: update flake inputs, then run `nix-rebuild`; review the
  resulting lock file before committing it.
- `nix-fmt`: format Nix files.
- `nix-lint`: check Nix and Markdown files.

`nix-rebuild`, `nix-sync`, and `nix-update` accept `--full-check` to run flake
evaluation before rebuilding. Before activation, use `bash bin/nix-rebuild`
from the repository.

## Neovim

Neovim is the default editor, with `vi` and `vim` aliases. Plugins, language
servers, and Treesitter parsers are provided by Nix and pinned by `flake.lock`.
There is no plugin manager to bootstrap at startup.

Start with `:Tutor` to learn basic editing. Press Escape to return to normal
mode. The leader key is Space; the following shortcuts use normal mode:

| Shortcut | Action |
| --- | --- |
| Space w / Space q | Save / close window |
| Space e | Browse files |
| Space ff / Space fg | Find files / search text |
| Space fb / Space fh | Open buffers / search help |
| gd / gr / K | Definition / references / documentation |
| Space rn / Space ca | Rename symbol / code action |
| Ctrl-h/j/k/l | Move between split windows |

In insert mode, Ctrl-Space opens completion, Tab/Shift-Tab select an entry,
and Enter confirms an explicitly selected entry. Language features activate
when a server recognizes the file and project. Use `:checkhealth vim.lsp`
to diagnose language-server issues.

Edit `config/nvim/options.lua` for basic settings, `keymaps.lua` for shortcuts,
`autocmds.lua` for automatic behavior, and `plugins.lua` for plugin settings.
Add plugins or language-server packages in `home/modules/neovim.nix`.
Rebuild after editing these files, then restart Neovim.

Zed uses declarative settings in `home/modules/zed.nix`. Edit that file and
rebuild to change persistent settings.

## Checks

Run from the repository root:

```bash
nix fmt
nix run .#lint
nix flake check --no-build
```

`nix fmt` formats Nix files with nixfmt through treefmt. CI also runs
`git diff --exit-code` after formatting to detect formatting changes.
The lint command runs Statix, Deadnix, and markdownlint-cli2. The generated
`hardware-configuration.nix` is excluded from Nix linting.

The flake check evaluates the configuration without building the entire system.
CI runs these checks on a self-hosted Linux runner for pushes to `master`
and on `ubuntu-latest` for pull requests. Run full system builds locally
with `nixos-rebuild test`, or build without activation using:

```bash
nix build --no-link .#nixosConfigurations.poremski.config.system.build.toplevel
```

## Updates

Update the pinned flake dependencies, then run the checks and test the system:

```bash
nix flake update
nix fmt
nix run .#lint
nix flake check --no-build
sudo nixos-rebuild test --flake .#poremski
```

Review and commit the changes to `flake.lock` once the test succeeds.

The ChatGPT package is fetched from a `latest` URL with a fixed SHA-256 hash in
`packages/chatgpt/default.nix`. If the upstream file changes, Nix rejects it
until the package source has been verified and the hash updated. A cached
copy may mean this only becomes apparent on another machine or runner.

## License

This repository uses the [MIT License](LICENSE).
Installed third-party packages are covered by their respective licenses.

[ci-badge]: https://github.com/Poremski/nix-config/actions/workflows/ci.yml/badge.svg?branch=master
[ci-link]: https://github.com/Poremski/nix-config/actions/workflows/ci.yml
[nixos-badge]: https://img.shields.io/badge/NixOS-5277C3?logo=nixos&logoColor=white
[nixos-link]: https://nixos.org/
[hm-badge]: https://img.shields.io/badge/Home%20Manager-5E81AC
[hm-link]: https://github.com/nix-community/home-manager
[neovim-badge]: https://img.shields.io/badge/Neovim-57A143?logo=neovim&logoColor=white
[neovim-link]: https://neovim.io/
[license-badge]: https://img.shields.io/badge/License-MIT-yellow.svg
