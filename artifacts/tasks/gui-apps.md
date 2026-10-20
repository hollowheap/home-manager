# Task: GUI Applications & Browsers (from overview.md)

- [x] `programs.vesktop.settings`: Discord / Vesktop client customization with Vencord and Noctalia theme styling.
- [x] `programs.zen-browser`: Hardened privacy policies, DNS-over-HTTPS, Startpage search routing, and multi-space container routing (`Personal`, `School`, `Entertainment`, `Social`).
- [x] `programs.zen-browser.hardening`: Enabled WebHID support (`dom.webhid.enabled = true`), organized prefs into categorized sections, disabled DNS/link prefetching, and applied WebRTC IP leakage mitigation (`ice.default_address_only = true`, `ice.no_host = true`).
- [x] `programs.zen-browser.spaces`: Monotonically ordered spaces (`Personal` 1000, `School` 2000, `Entertainment` 3000, `Social` 4000) with RFC4122 v4 UUID helpers (`a1...0001`..`0004`), sequential pin UUIDs (`b1...0001`..`0008`), global essentials (`separate-essentials = false`), Claude added to essentials, Telegram removed from browser essentials, and forced space routing.
- [x] `programs.zen-browser`: Bumped `keyboardShortcutsVersion = 21` to sync with live profile.
- [x] `programs.obs-studio.plugins`: Configure OBS Studio plugins (`obs-vaapi`, `obs-vkcapture`, `obs-pipewire-audio-capture`).
- [x] `home.packages`: Install `prismlauncher` and `telegram-desktop`.
- [x] `programs.thunderbird`: Configured `programs.thunderbird.profiles.default.isDefault = true;` and `defaultApps.mail = "thunderbird";`.
- [x] `xdg.mimeApps`: Configured default applications mapping web to `zen-twilight.desktop`, mail/calendar to `thunderbird.desktop`, and directories to `org.gnome.Nautilus.desktop`.
