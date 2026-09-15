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
            "URLTemplate" = "https://www.startpage.com/sp/search";
            "IconURL" = "https://www.startpage.com/sp/search";
            "PostData" =
              "query={searchTerms}&cat=web&t=devic&segment=startpage.apex.desktop&prfe=3e1a53333ebb17d8c9e68e19d8eb8957cffa9bb8412427f6a48ef8147f4602bd734547fb39acd86a1b3ce46801d30fb83e2913f3cacabeb34f962e3d3f5da410bf92cd3c92fa4a2ee5857c7a05c0abc0";
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
        builtins.mapAttrs
          (_: pluginId: {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
            installation_mode = "force_installed";
          })
          {
            "sponsorBlocker@ajay.app" = "sponsorblock";
            "uBlock0@raymondhill.net" = "ublock-origin";
            "{b86e4813-687a-43e6-ab65-0bde4ab75758}" = "localcdn-fork-of-decentraleyes";
            "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes";
            "enhancerforyoutube@maximerf.addons.mozilla.org" = "enhanced-for-youtube";
            "gdpr@cavi.au.dk" = "consent-o-matic";
            "{91aa3897-2634-4a8a-9092-279db23a7689}" = "zen-internet";
          };

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
      keyboardShortcutsVersion = 20;

      containersForce = true;
      containers = {
        Personal = {
          id = 1;
          color = "blue";
          icon = "fingerprint";
        };
        School = {
          id = 2;
          color = "purple";
          icon = "briefcase";
        };
        Entertainment = {
          id = 3;
          color = "red";
          icon = "chill";
        };
        Social = {
          id = 4;
          color = "green";
          icon = "tree";
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
            icon = "chrome://browser/skin/zen-icons/selectable/lightning.svg";
            pins = {
              "Gemini" = {
                url = "https://gemini.google.com";
                id = "e86cf37-a127-4f24-b919-d265b5ce29a2";
                position = 100;
                isEssential = true;
                container = containers.Personal.id;
              };
              "MyNixOS" = {
                url = "https://mynixos.com";
                id = "e86cf37-a127-4f24-b919-d265b5ce29a5";
                position = 100;
                container = containers.Personal.id;
              };
            };
            routes = {
              "github" = {
                reference = "github.com";
              };
              "gemini" = {
                reference = "gemini.google.com";
              };
              "mynixos" = {
                reference = "mynixos.com";
              };
            };
          };
          School = {
            position = 2000;
            container = containers.School.id;
            id = "6c9a5583-86cb-4578-876b-e7619e192bc6";
            icon = "chrome://browser/skin/zen-icons/selectable/school.svg";
            routes = {
              "lms" = {
                reference = "xsite.singaporetech.edu.sg";
              };
              "portal" = {
                reference = "in4sit.singaporetech.edu.sg";
              };
            };
            pins = {
              "xSITe" = {
                url = "https://xsite.singaporetech.edu.sg";
                id = "e86cf37-a127-4f24-b919-d265b5ce29a3";
                position = 100;
                container = containers.School.id;
              };
              "In4SIT" = {
                url = "https://in4sit.singaporetech.edu.sg";
                id = "e86cf37-a127-4f24-b919-d265b5ce29a4";
                position = 200;
                container = containers.School.id;
              };
            };
          };
          Entertainment = {
            position = 3000;
            container = containers.Entertainment.id;
            id = "7f6c77b3-6de3-4d36-9e7c-63960006197d";
            icon = "chrome://browser/skin/zen-icons/selectable/game-controller.svg";

            pins = {
              "Youtube" = {
                url = "https://www.youtube.com";
                id = "6c9a5583-86cb-4578-876b-e7619e192bc5";
                position = 200;
                isEssential = true;
                container = containers.Entertainment.id;
              };
            };

            routes = {
              "youtube" = {
                reference = "www.youtube.com";
              };
            };
          };
          Social = {
            position = 4000;
            container = containers.Social.id;
            icon = "chrome://browser/skin/zen-icons/selectable/chat.svg";
            id = "50414e4d-873d-4940-8ed4-8145c4a95bc6";

            pins = {
              "Telegram" = {
                url = "https://web.telegram.org";
                id = "6c9a5583-86cb-4578-876b-e7619e192bc7";
                position = 300;
                isEssential = true;
                container = containers.Social.id;
              };
              "WhatsApp" = {
                url = "https://web.whatsapp.com";
                id = "6c9a5583-86cb-4578-876b-e7619e192bc8";
                position = 400;
                isEssential = true;
                container = containers.Social.id;
              };
            };

            routes = {
              "telegram" = {
                reference = "web.telegram.org";
              };
            };
          };
        };

      pinsForce = true;

      mods = [
        "72f8f48d-86b9-4487-acea-eb4977b18f21" # Better Ctrl Tab Panel
        "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
        "c01d3e22-1cee-45c1-a25e-53c0f180eea8" # Ghost Tabs
        "642854b5-88b4-4c40-b256-e035532109df" # Transparent Zen
        "4a222d82-2803-4ed2-a390-90abfce4f195" # Back Fwd Always Hidden
        "cb5efa80-f1e1-43ce-8c0b-fece8462d225" # Container Halo
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
