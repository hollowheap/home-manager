# Desktop Applications, Zen Hardening, Theming & Dconf Review

## 1. Home Manager `accounts.*` Ecosystem & Thunderbird Integration
Home Manager provides a unified, declarative user account framework under `accounts`:
- `accounts.email.accounts.<name>`:
  - Canonical declarative specification for personal, school, and work emails.
  - Options: `address`, `realName`, `userName`, `imap` (host/port/tls), `smtp` (host/port/tls), `signature`, `passwordCommand` (e.g. `rbw get <entry>`).
  - Native Thunderbird integration:
    ```nix
    accounts.email.accounts.personal = {
      address = "user@example.com";
      realName = "Hollow Heap";
      userName = "user@example.com";
      primary = true;
      imap = { host = "imap.example.com"; port = 993; tls.enable = true; };
      smtp = { host = "smtp.example.com"; port = 465; tls.enable = true; };
      thunderbird = {
        enable = true;
        profiles = [ "default" ];
      };
    };
    ```
- `accounts.calendar.accounts.<name>` & `accounts.contact.accounts.<name>`:
  - Declarative CalDAV and CardDAV endpoints automatically mapped to Thunderbird's Lightning calendar and address books without manual GUI setup.

---

## 2. Rebuilding MacTahoe GTK Theme with Noctalia Colors
### Build-time vs. Runtime Approaches:
1. **Dynamic Runtime Injection via Noctalia/Matugen (Recommended)**:
   - GTK 3 and GTK 4 natively load user stylesheet overrides from `~/.config/gtk-3.0/gtk.css` and `~/.config/gtk-4.0/gtk.css`.
   - Noctalia generates dynamic colors from the wallpaper into `$XDG_CACHE_HOME/noctalia/`.
   - By creating a Noctalia template writing `@define-color accent_color {{ colors.primary.default.hex }};` and `@define-color window_bg_color {{ colors.surface.default.hex }};` to `~/.config/gtk-3.0/gtk.css`, MacTahoe dynamically reflects the active wallpaper palette on every theme reload without re-evaluating or rebuilding Nix store closures.
2. **Declarative Build-time SCSS Recompile**:
   - `pkgs/mactahoe-gtk-theme.nix` uses `sassc` during build.
   - We can parameterize `pkgs/mactahoe-gtk-theme.nix` with Stylix / Base16 palette attributes (e.g. `base0D` for primary accent) by patching `src/_sass/_colors.scss` before running `install.sh`.

---

## 3. Dconf Review (Live State vs. Current Declarations)
Current `modules/core/dconf.nix` only manages:
- `org/gnome/desktop/interface/color-scheme = "prefer-dark"`
- `org/gnome/nautilus/preferences` (folder viewer, search filter, delete permanently)
- `org/gnome/nautilus/icon-view/default-zoom-level`

Live unmanaged dconf keys discovered via `dconf dump /`:
```ini
[org/gnome/desktop/interface]
cursor-size=20
cursor-theme='Bibata-Modern-Classic'
font-name='VictorMono NFP 12'
gtk-theme='MacTahoe-Dark'
icon-theme='mactahoe-icon-theme-latest-dark'

[org/gnome/nautilus/preferences]
migrated-gtk-settings=true

[org/gnome/nautilus/window-state]
initial-size=(890, 550)
maximized=true

[org/gtk/settings/file-chooser]
date-format='regular'
location-mode='path-bar'
show-hidden=false
show-size-column=true
show-type-column=true
sidebar-width=215
sort-column='name'
sort-directories-first=false
sort-order='ascending'
type-format='category'
window-position=(0, 0)
window-size=(1310, 982)
```
*Recommendation*: Promote `cursor-theme`, `cursor-size`, `font-name`, `gtk-theme`, and `icon-theme` into `modules/core/dconf.nix` to prevent desktop environment drift.
