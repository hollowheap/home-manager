{ ... }:
{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/nautilus/preferences" = {
        default-folder-viewer = "icon-view";
        search-filter-time-type = "last_modified";
        show-delete-permanently = true;
      };
      "org/gnome/nautilus/icon-view" = {
        default-zoom-level = "medium";
      };
    };
  };
}
