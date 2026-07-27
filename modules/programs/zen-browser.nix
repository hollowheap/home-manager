{ config, lib, ... }:
let
  mkLockedAttrs = builtins.mapAttrs (
    _: value: {
      Value = value;
      Status = "locked";
    }
  );
in
{
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
    policies = {
      # Telemetry
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisableFeedbackCommands = true;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };

      # Authentication
      HTTPSOnlyMode = "force_enabled";
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      PrimaryPassword = false;
      DisableMasterPasswordCreation = false;

      DNSOverHTTPS = true;

      # User and form data
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableFormHistory = true;

      # Startup optimizations
      Homepage = "none";
      FirefoxHome = false;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      DisableAppUpdate = true;
      NoDefaultBookmarks = true;

      # Preferences
      DisableSetDesktopBackground = true;
      DisplayMenuBar = "never";

      SearchEngines = {
        Add = [
          {
            "Name" = "Startpage";
            "Method" = "POST";
            "URLTemplate" = "https://www.startpage.com/do/search";
            "IconURL" = "https://www.startpage.com/sp/search";
            "PostData" = "query={searchTerms}&cat=web&t=device";
            "SuggestURLTemplate" = "https://www.startpage.com/osuggestions?q={searchTerm}";
          }
        ];
        Remove = [
          "Google"
          "DuckDuckGo"
          "Bing"
          "Perplexity"
        ];
        Default = "Startpage";
        PreventInstalls = true;
      };

      ExtensionSettings =
        lib.attrsets.genAttrs
          [
            "uBlock0@raymondhill.net"
            "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}"
            "sponsorBlocker@ajay.app"
          ]
          (pluginId: {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
          });

      Preferences = mkLockedAttrs {
        "browser.aboutConfig.showWarning" = false;
        "browser.tabs.warnOnClose" = false;

        # New tab page
        "browser.newtabpage.activity-stream.default.sites" = "";

        # Block auto-updates
        "app.update.background.scheduling.enabled" = false;

        # Safe Browsing
        "browser.safebrowsing.provider.google4.gethashURL" = "";
        "browser.safebrowsing.provider.google4.updateURL" = "";
        "browser.safebrowsing.provider.google4.dataSharingURL" = "";
        "browser.safebrowsing.provider.google.gethashURL" = "";
        "browser.safebrowsing.provider.google.updateURL" = "";

        "browser.safebrowsing.downloads.remote.url" = "";

        "browser.fixup.alternate.enabled" = false;

        # Network Link Prefetch Shunts (Stops speculative background connections)
        "browser.places.speculativeConnect.enabled" = false;
        "network.http.speculative-parallel-limit" = 0;
        "network.gio.supported-protocols" = "";
        "network.file.disable_unc_paths" = true;
        "permissions.manager.defaultsUrl" = "";
        "network.IDN_show_punycode" = true;

        # Search Bar Information Leak Mitigation
        "browser.urlbar.speculativeConnect.enabled" = false;

        # Block Telemetry
        "beacon.enabled" = false;

        # Crash Reports
        "breakpad.reportURL" = false;

        # Custom Geolocation override
        "geo.provider.network.url" =
          "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
        "geo.provider.use_gpsd" = false;
        "geo.provider.use_geoclue" = false;
        "browser.region.network.url" = "";
        "browser.region.update.enabled" = false;

        # Advanced Content Blocking Definitions (Forces URL parameter stripping)
        "privacy.query_stripping.enabled" = true;
        "privacy.query_stripping.enabled.pbmode" = true;
        "browser.contentblocking.features.strict" =
          "tp,tpPrivate,cookieBehavior5,cookieBehaviorPBM5,cm,fp,stp,emailTP,emailTPPrivate,-lvl2,rp,rpTop,ocsp,qps,qpsPBM,fpp,fppPrivate,3pcd,btp";

        # Anti fingerprinting
        "dom.battery.enabled" = false;
        "privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.randomization.canvas.use_siphash" = true;
        "privacy.resistFingerprinting.randomization.daily_reset.enabled" = true;
        "privacy.resistFingerprinting.randomization.daily_reset.private.enabled" = true;
        "privacy.resistFingerprinting.block_mozAddonManager" = true;
        "privacy.spoof_english" = 1;
        "privacy.firstparty.isolate" = true;
        "network.cookie.cookieBehavior" = 5;

      };
    };
    profiles."default" = {
      settings = {
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.ctrlTab.sortByRecentlyUser" = true;
        "browser.tabs.hoverPreview.enabled" = true;
        "theme.floating_history.position" = "right";

        # Devtools UI States
        "devtools.everOpened" = true;
        "devtools.toolbox.host" = "right";

        # AI Sidebar Integration
        "browser.ml.chat.enabled" = true;
        "browser.ml.chat.sidebar" = true;
        "browser.ml.chat.provider" = "https://gemini.google.com";

        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Zen Layout Options
        "zen.tabs.show-newtab-vertical" = false;
        "zen.tabs.ctrl-tab.ignore-essential-tabs" = true;
        "zen.tabs.ctrl-tab.ignore-pending-tabs" = true;
        "zen.view.show-newtab-button-top" = false;
        "zen.view.compact.enable-at-startup" = true;
        "zen.view.compact.hide-toolbar" = true;
        "zen.view.use-single-toolbar" = false;
        "zen.urlbar.behavior" = "float";
        "zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url" = true;
        "zen.welcome-screen.seen" = true;
        "zen.workspaces.continue-where-left-off" = true;
        "zen.workspaces.force-container-workspace" = true;
        "zen.workspaces.separate-essentials" = false;
      };

      keyboardShortcuts = [
        {
          id = "key_quitApplication";
          disabled = true;
        }
      ]
      ++ (builtins.genList (
        i:
        let
          key = toString (i + 1);
        in
        {
          id = "zen-workspace-switch-${key}";
          inherit key;
          modifiers = {
            shift = true;
            alt = true;
          };
        }
      ) 8);
      keyboardShortcutsVersion = 19;

      containersForce = true;
      containers = {
        Personal = {
          id = 1;
          color = "blue";
          icon = "fingerprint";
        };
        Work = {
          id = 2;
          color = "yellow";
          icon = "briefcase";
        };
        School = {
          id = 3;
          color = "purple";
          icon = "tree";
        };
        Social = {
          id = 4;
        };
        Entertainment = {
          id = 5;
        };
      };

      spacesForce = true;
      spaces =
        let
          containers = config.programs.zen-browser.profiles."default".containers;
        in
        {
          Personal = {
            position = 1000;
            container = containers.Personal.id;
            id = "4ee215ee-c47c-429a-9480-576f8b1a624e";
          };
          Work = {
            position = 2000;
            container = containers.Work.id;
            id = "6c9a5583-86cb-4578-876b-e7619e192bc6";
          };
          School = {
            position = 3000;
            container = containers.School.id;
            id = "7f6c77b3-6de3-4d36-9e7c-63960006197d";
          };
        };

      mods = [
        "72f8f48d-86b9-4487-acea-eb4977b18f21" # Better Ctrl Tab Panel
        "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
        "c01d3e22-1cee-45c1-a25e-53c0f180eea8" # Ghost Tabs
        "3ff55ba7-4690-4f74-96a8-9e4416685e4e" # Colored Container Tab
        "1e86cf37-a127-4f24-b919-d265b5ce29a0" # Lean
        "4c2bec61-7f6c-4e5c-bdc6-c9ad1aba1827" # Vertical Tab Split Groups
        "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
        "ae7868dc-1fa1-469e-8b89-a5edf7ab1f24" # Load Bar
        "79dde383-4fe7-404a-a8e6-9be440022542" # Tidy Popup
        "87196c08-8ca1-4848-b13b-7ea41ee830e7" # Tab Preview Enhanced
        "fd24f832-a2e6-4ce9-8b19-7aa888eb7f8e" # Quietify
        "f4866f39-cfd6-4498-ab92-54213b8279dc" # Animation Plus
      ];
    };
  };
}
