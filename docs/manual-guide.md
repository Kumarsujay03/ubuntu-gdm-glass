# Manual guide: glass login screen by hand

This is what `gdm-glass` does for you, step by step. Use it if you want to
understand the process or customise the CSS yourself.

Tested on Ubuntu 26.04 LTS (GNOME Shell 50, GDM 50, Yaru theme).

## 1. Why the theme must be rebuilt

The GDM login screen CSS is embedded inside a compiled file:

```text
/usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource
```

Editing `/usr/share/gnome-shell/theme/Yaru/gnome-shell.css` does **not** change
the login screen. You have to extract the resource, edit `gdm.css`, and compile
it again.

## 2. Extract the theme

```bash
mkdir -p ~/gdm-rebuild/src && cd ~/gdm-rebuild
RES=/usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource
PREFIX=/org/gnome/shell/theme

{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo "<gresources><gresource prefix=\"$PREFIX\">"
  for path in $(gresource list "$RES"); do
    rel="${path#$PREFIX/}"
    mkdir -p "src/$(dirname "$rel")"
    gresource extract "$RES" "$path" > "src/$rel"
    echo "<file>$rel</file>"
  done
  echo "</gresource></gresources>"
} > theme.gresource.xml
```

> **Fish shell users:** run these commands inside `bash` first, since fish
> doesn't support this syntax.

## 3. Add the glass CSS

Append this to the end of `src/gdm.css`. Adjust `0.08` (opacity) and `12px`
(corner radius) to taste.

```css
/* Glass user list */
.login-dialog-user-list-view .login-dialog-user-list .login-dialog-user-list-item,
.login-dialog-user-list-view .login-dialog-user-list .login-dialog-user-list-item:selected,
.login-dialog-user-list-view .login-dialog-user-list .login-dialog-user-list-item:focus,
.login-dialog-user-list-view .login-dialog-user-list .login-dialog-user-list-item:hover {
    background-color: rgba(255, 255, 255, 0.08) !important;
    box-shadow: none !important;
    border: none !important;
    border-radius: 12px !important;
}

/* Glass password field */
.login-dialog StEntry,
.login-dialog StEntry:focus,
.login-dialog .login-dialog-prompt-entry,
.login-dialog .login-dialog-prompt-entry:focus {
    background-color: rgba(255, 255, 255, 0.08) !important;
    border: none !important;
    border-color: transparent !important;
    box-shadow: none !important;
    border-radius: 12px !important;
}

/* Glass "Not listed?" button */
.login-dialog-not-listed-button,
.login-dialog-not-listed-button:hover,
.login-dialog-not-listed-button:focus,
.login-dialog-not-listed-button:active {
    background-color: rgba(255, 255, 255, 0.08) !important;
    color: #f2f2f2 !important;
    border: none !important;
    box-shadow: none !important;
    border-radius: 12px !important;
}

/* Transparent back button */
.login-dialog .cancel-button,
.login-dialog .cancel-button:hover,
.login-dialog .cancel-button:focus,
.login-dialog .cancel-button:active,
.login-dialog .cancel-button:checked {
    background-color: transparent !important;
    background-image: none !important;
    border: none !important;
    border-color: transparent !important;
    box-shadow: none !important;
    text-shadow: none !important;
}
.login-dialog .cancel-button StIcon {
    color: #f2f2f2 !important;
}
```

The `:hover`, `:focus`, `:active` and `:checked` states matter. Without them,
the orange border or grey circle comes back when you interact with the element.

## 4. Compile and check

```bash
glib-compile-resources theme.gresource.xml --sourcedir=src --target=new.gresource
gresource extract new.gresource /org/gnome/shell/theme/gdm.css | tail -60
```

The output should end with your CSS.

## 5. Back up and install

```bash
sudo cp -a "$RES" "$RES.backup"
sudo install -m 644 new.gresource "$RES"
```

Log out or reboot to see it.

## 6. Optional: 12-hour clock

```bash
printf "[org/gnome/desktop/interface]\nclock-format='12h'\n" \
  | sudo tee /etc/dconf/db/gdm.d/90-clock
sudo dconf update
```

Use `'24h'` to switch back, or delete the file and run `sudo dconf update` again.

## 7. Recovery

If the login screen breaks, press **Ctrl + Alt + F3**, log in, and run:

```bash
sudo install -m 644 /usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource.backup \
                    /usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource
sudo reboot
```

As a last resort: `sudo apt install --reinstall yaru-theme-gnome-shell`.

## After Ubuntu updates

An update to `yaru-theme-gnome-shell` replaces the theme file. Don't copy an
old backup over a newer theme. Re-run the steps above (or `gdm-glass apply`)
on the new version instead.
