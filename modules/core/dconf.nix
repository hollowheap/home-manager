{ ... }:
{
  dconf = {
    enable = true;
    settings = {
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
    };
  };
}
