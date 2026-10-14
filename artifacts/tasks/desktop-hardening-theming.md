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

### Secret Management Strategies for `accounts.email`:
1. **Lightweight Gitignored Secret (Recommended - No `sops-nix` Needed)**:
   - Place a `secrets/email.nix` file with `address` and `userName` in `.gitignore`.
   - In `thunderbird.nix`:
     ```nix
     let
       emailSecrets =
         if builtins.pathExists ../../secrets/email.nix
         then import ../../secrets/email.nix
         else { personal = "user@example.com"; };
     in ...
     ```
   - Zero key-management overhead; email address remains completely private.
2. **Runtime Command Password Retrieval**:
   - `passwordCommand = [ "rbw" "get" "email-password" ];` fetches password dynamically into Thunderbird without storing credentials in the world-readable `/nix/store`.
3. **`sops-nix` / Age Encryption**:
   - Only necessary if committing encrypted secrets to a public Git repository.

---

## 2. Theme Color Audit: MacTahoe vs. Stylix / Noctalia
### Current MacTahoe-Dark Hardcoded Palette:
- **Primary Accent**: `#0088FF` (macOS Blue) / `#2E7CF7`
- **Dark Backgrounds**: `#1f1f1f` / `#1e1e1e` / `#282828`
- **Text & Foreground**: `#dedede` / `#ffffff`
- **Destructive / Error**: `#ED5F5D`
- **Warning**: `#E9873A`

### Current Stylix Active Palette (Generated from Wallpaper):
- **Base00 (Background)**: `#1c1831` (Deep midnight purple)
- **Base05 (Foreground)**: `#e5e3e6` (Off-white)
- **Base0D (Primary Accent)**: `#c58462` (Warm copper)
- **Base0E (Secondary Accent)**: `#808aeb` (Lavender)
- **Base08 (Red / Danger)**: `#c37aa7` (Rose red)

### Rebuilding MacTahoe GTK Theme with Noctalia Colors:
1. **Dynamic Runtime Injection via Noctalia/Matugen (Recommended)**:
   - GTK 3 and GTK 4 load user stylesheet overrides from `~/.config/gtk-3.0/gtk.css` and `~/.config/gtk-4.0/gtk.css`.
   - Noctalia generates dynamic colors from the wallpaper into `$XDG_CACHE_HOME/noctalia/`.
   - By creating a Noctalia template writing `@define-color accent_color {{ colors.primary.default.hex }};` and `@define-color window_bg_color {{ colors.surface.default.hex }};` to `~/.config/gtk-3.0/gtk.css`, MacTahoe dynamically reflects the active wallpaper palette on every theme reload without re-evaluating or rebuilding Nix store closures.
2. **Declarative Build-time SCSS Recompile**:
   - `pkgs/mactahoe-gtk-theme.nix` uses `sassc` during build.
   - Patch `src/_sass/_colors.scss` with `base0D` before running `install.sh`.

---

## 3. Dconf State (Applied Non-Stylix Keys)
Applied to `modules/core/dconf.nix`:
```nix
"org/gnome/desktop/interface" = {
  color-scheme = "prefer-dark";
  gtk-theme = "MacTahoe-Dark";
  icon-theme = "mactahoe-icon-theme-latest-dark";
};
"org/gnome/nautilus/preferences" = {
  default-folder-viewer = "icon-view";
  search-filter-time-type = "last_modified";
  show-delete-permanently = true;
  migrated-gtk-settings = true;
};
"org/gnome/nautilus/icon-view" = {
  default-zoom-level = "medium";
};
"org/gtk/settings/file-chooser" = {
  date-format = "regular";
  location-mode = "path-bar";
  show-hidden = false;
  show-size-column = true;
  show-type-column = true;
  sidebar-width = 215;
  sort-column = "name";
  sort-directories-first = false;
  sort-order = "ascending";
  type-format = "category";
};
```

---

## 4. Pending Tasks Roadmap
- [ ] **Task A: Email Secret Setup**: Implement `secrets/email.nix` (gitignored) and bind to `accounts.email.accounts.personal`.
- [ ] **Task B: Noctalia GTK Color Injection**: Template `~/.config/gtk-3.0/gtk.css` and `~/.config/gtk-4.0/gtk.css` with Noctalia dynamic tokens for live wallpaper sync.
- [ ] **Task C: Thunderbird Account Declarations**: Link Thunderbird profile to `accounts.email.accounts` once secrets file is populated.

