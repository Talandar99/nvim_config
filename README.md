# Neovim configuration

## Requirements

- Neovim 0.12 or newer.
- `git`, `make`, a C compiler, and network access.
- `ripgrep` (`rg`) for Telescope `live_grep` (`<leader>sg`). On Gentoo, run
  `sudo emerge --ask sys-apps/ripgrep`.
- A Nerd Font, because `vim.g.have_nerd_font` is enabled.
- `xclip` for the X11 clipboard and `alacritty` for the Oil launcher.
- Python 3 with `dbus-python` and PyGObject, plus `gdbus`, for the Oil
  launcher.

## Install

Clone the repository directly to the Neovim config directory and run the
bootstrap script:

```sh
git clone git@github.com:Talandar99/nvim_config.git ~/.config/nvim
~/.config/nvim/bootstrap.sh
```

`bootstrap.sh` runs `Lazy! sync`. lazy.nvim is cloned automatically if it is
missing. Mason servers and Treesitter parsers are installed on first Neovim
start.

The equivalent manual command is:

```sh
nvim --headless -c "Lazy! sync" -c qa
```

`lazy-lock.json` is gitignored, so plugin versions are currently resolved to
the latest available versions instead of being pinned.

## Oil launcher

The launcher registers Neovim Oil as a FileManager1 D-Bus service. It requires
a running user D-Bus session.

```sh
~/.config/nvim/oil-launcher/manage.sh install
xdg-mime default nvim-oil.desktop inode/directory
```

To remove it:

```sh
~/.config/nvim/oil-launcher/manage.sh remove
```

`manage.sh` generates the desktop entry from `nvim-oil.desktop` and fills in
the launcher path for the current machine.

## Optional tools used by configured features

Search and formatting:

- `rg` and `fd` for Telescope file and content search.
- `stylua`, `clang-format`, and `tofu` for formatting.
- `pycodestyle` for pylsp.

Preview helpers:

- `chafa`, `python3`, `openscad`, `bgcode`, `pdftotext`, `w3m`, `aseprite`,
  `ffprobe`, `pandoc`, `man`, and `col`.
- `libreoffice25.8` for DOC, DOCX, and spreadsheet previews. The versioned
  binary name is Gentoo specific.
- `blender-thumbnailer` for BLEND previews. The helper also checks
  `/opt/blender-bin-*` when it is not on `PATH`.

File handlers and system tools:

- `dragon` for the Oil drag mapping `yd`.
- `prusa-slicer` for STL and 3MF files through `gx`.
- `lsblk` and `udisksctl` for USB device bookmarks.
- `xdg-open` for other files through `gx`.

REPLs, runners, and integrations:

- `bash`, `python3`, `mongosh`, and `tar`.
- Flutter and Dart SDKs on `PATH`.
- Database clients for the schemes configured in vim-dadbod-ui: SQLite,
  PostgreSQL, MySQL, MongoDB, and Redis.

Mason manages LSP servers, `debugpy`, `codelldb`, `tree-sitter-cli`, and other
language tooling. Use `:Mason` to inspect them.

## Machine-specific settings

- The git remote uses SSH: `git@github.com:Talandar99/nvim_config.git`.
- `robotframework_ls` logs to `/tmp/robotframework_ls.log` and uses
  `$VIRTUAL_ENV/bin/python` when available.
- The calcurse filetype rule matches `/tmp/calcurse*` and
  `*/workspace/notes/calcurse/notes/*`.
- Undo files are stored under `~/.local/.nvim-undo`.
- Oil bookmarks and run.nvim state are stored under Neovim's `stdpath("data")`.
