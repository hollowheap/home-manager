{ config, ... }: let
  inherit (builtins) mapAttrs;
  mkLockedAttrs = mapAttrs (_: value: {
    Value = value;
    Status = "locked";
  });
in {
  programs.zen-browser = {
    enable = true;
    policies = {
      AutofillAddressEnabled = true;

      # Privacy
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisableTelemetry = true;

      # Optimizations
      DontCheckDefaultBrowser = true;
      DisablePocket = true;
      DisableAppUpdate = true;
      FirefoxHome = false;
      Homepage = "none";

      # Preferences
      DisableSetDesktopBackground = true;
      NoDefaultBookmarks = true;
      DisplayMenuBar = "never";

      # Security
      OfferToSaveLogins = false;
      AutofillCreditCardEnabled = false;
      DisableFormHistory = true;
      DisableMasterPasswordCreation = false;
      PasswordManagerEnabled = false;
      PrimaryPassword = false;
      HTTPSOnlyMode = "force_enabled";
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
	EmailTracking = true;
      };
      DNSOverHTTPS = {
        Enabled = true;
        Locked = true;
      };

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
        Remove = [ "Google" "DuckDuckGo" "Bing" "Perplexity" ];
	Default = "Startpage";
	# PreventInstalls = true;
      };
      Preferences = mkLockedAttrs {
	"browser.ctrlTab.sortByRecentlyUser" = true;
	"browser.tabs.hoverPreview.enabled" = true;
        # Enable AI Sidebar
        "browser.ml.chat.enabled" = true;
        "browser.ml.chat.sidebar" = true;
        "browser.ml.chat.provider" = "https://gemini.google.com";

	# Devtools
	"devtools.everOpened" = true;
	"devtools.toolbox.host" = "right";

	"theme.floating_history.position" = "right";

	# Zen settings
	"zen.tabs.show-newtab-vertical" = false;
	"zen.view.show-newtab-button-top" = false;
	"zen.view.compact.hide-toolbar" = true;
	"zen.view.use-single-toolbar" = false;
	"zen.urlbar.behavior" = "float";
	"zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url" = true;
	"zen.workspaces.continue-where-left-off" = true;
	"zen.workspaces.force-container-workspace" = true;
	"zen.workspaces.separate-essentials" = false;
	"zen.welcome-screen.seen" = true;

        # Hardening
	# Disable only on HTTP
        "network.dns.disablePrefetch" = true;
	"geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
      };
    };
    profiles."default" = {
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
      search = {

      };
      spacesForce = true;
      spaces = let
        containers = config.programs.zen-browser.profiles."default".containers;
      in {
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
    };
  };
} 
