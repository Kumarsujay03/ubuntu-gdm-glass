# ubuntu-gdm-glass

Give the **Ubuntu login screen (GDM)** a modern **glass-like look** with one command.

```bash
gdm-glass apply
```

Tested on **Ubuntu 26.04 LTS** (GNOME Shell 50, GDM 50, Wayland). Should work
on any Ubuntu release that uses the Yaru GDM theme.

## What it changes

- 🪟 **User list:** translucent glass box, no orange focus border
- 🔑 **Password field:** translucent and rounded, no orange focus outline
- 👤 **"Not listed?" button:** matching glass style
- ⬅️ **Back button:** transparent, with no grey circle, border or shadow
- 🕐 **Clock** (optional): switch between 12-hour and 24-hour
- 🔒 **Backups:** the original theme is saved once and never overwritten, so `undo` and `reset` always work

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/Kumarsujay03/ubuntu-gdm-glass/main/install.sh | bash
```

Or manually:

```bash
git clone https://github.com/Kumarsujay03/ubuntu-gdm-glass.git
cd ubuntu-gdm-glass
sudo install -m 755 gdm-glass /usr/local/bin/
```

Requires `libglib2.0-dev-bin` (`sudo apt install libglib2.0-dev-bin`).

## Usage

```bash
gdm-glass apply                          # glass look with default settings
gdm-glass apply --opacity 0.15           # more frosted (0 = clear, 1 = solid white)
gdm-glass apply --radius 20              # rounder corners (pixels)
gdm-glass apply --clock 12h              # also switch the login clock to 12-hour
gdm-glass remove                         # remove the glass look, keep other customizations
gdm-glass undo                           # go back one step
gdm-glass reset                          # original Ubuntu login screen
gdm-glass status                         # show current state
```

Log out or reboot to see the change.

## Works with gdm-wallpaper

Pair it with [**gdm-wallpaper**](https://github.com/Kumarsujay03/ubuntu-gdm-wallpaper)
to set your own login wallpaper. The glass panels look best over a photo:

```bash
gdm-wallpaper set ~/Pictures/wallpaper.jpg
gdm-glass apply
```

Each tool only touches its own clearly marked CSS block, so you can run them in
any order and as often as you like.

## How it works

GDM's look comes from a compiled theme file
(`/usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource`), so editing a
CSS file on disk is not enough. `gdm-glass`:

1. Saves an untouched copy of the theme the first time (`*.gdm-glass-original`).
2. Extracts the theme and appends a marked CSS block to its `gdm.css`.
3. Recompiles the theme and installs it, keeping the previous one for `undo`.
4. With `--clock`, writes `/etc/dconf/db/gdm.d/90-gdm-glass-clock` and runs `dconf update`.

Running `apply` again replaces the block instead of piling up changes. Want to
do it by hand or tweak the CSS? See the [manual guide](docs/manual-guide.md).

> **Note:** GNOME Shell's CSS has no real background blur, so "glass" here means
> translucent panels over your wallpaper.

## If the login screen breaks

Press **Ctrl + Alt + F3**, log in on the text console, and run:

```bash
gdm-glass reset
sudo reboot
```

If that is not possible, reinstall the stock theme:

```bash
sudo apt install --reinstall yaru-theme-gnome-shell
```

> **Note:** A system update to `yaru-theme-gnome-shell` replaces the theme file
> and removes the glass look. Just run `gdm-glass apply` again.

## Contributing

This project is open source and contributions are welcome! See
[CONTRIBUTING.md](CONTRIBUTING.md). Ideas: support for other distros and
themes, light-mode glass, colour tints, a GUI.

## License

[MIT](LICENSE) © Kumarsujay03
