{ ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Web / Browser
      "text/html" = "zen-twilight.desktop";
      "text/xml" = "zen-twilight.desktop";
      "application/xhtml+xml" = "zen-twilight.desktop";
      "application/vnd.mozilla.xul+xml" = "zen-twilight.desktop";
      "x-scheme-handler/http" = "zen-twilight.desktop";
      "x-scheme-handler/https" = "zen-twilight.desktop";
      "x-scheme-handler/about" = "zen-twilight.desktop";
      "x-scheme-handler/unknown" = "zen-twilight.desktop";

      # Email & Calendar
      "x-scheme-handler/mailto" = "thunderbird.desktop";
      "message/rfc822" = "thunderbird.desktop";
      "text/calendar" = "thunderbird.desktop";
      "text/x-vcard" = "thunderbird.desktop";

      # File Manager
      "inode/directory" = "org.gnome.Nautilus.desktop";
    };
  };
}
