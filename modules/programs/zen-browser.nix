{ config, ... }: let
  mkLockedAttrs = builtins.mapAttrs (_: value: {
    Value = value;
    Status = "locked";
  });
in {
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

      DNSOverHTTPS = {
        Enabled = true;
        Locked = true;
        # Optional: ProviderURL = "https://cloudflare-dns.com/dns-query";
      };

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
        Remove = [ "Google" "DuckDuckGo" "Bing" "Perplexity" ];
	Default = "Startpage";
	PreventInstalls = true;
      };
      Preferences = mkLockedAttrs {
        # Network Link Prefetch Shunts (Stops speculative background connections)
        "network.dns.disablePrefetch" = true;
        "network.predictor.enabled" = false;
        "network.prefetch-next" = false;
        "network.http.speculative-parallel-limit" = 0;

	# Search Bar Information Leak Mitigation
	"browser.urlbar.speculativeConnect.enabled" = false;

	# Custom Geolocation override
	"geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";

	# Advanced Content Blocking Definitions (Forces URL parameter stripping)
        "privacy.query_stripping.enabled" = true;
        "privacy.query_stripping.enabled.pbmode" = true;
        "browser.contentblocking.features.strict" = "tp,tpPrivate,cookieBehavior5,cookieBehaviorPBM5,cm,fp,stp,emailTP,emailTPPrivate,-lvl2,rp,rpTop,ocsp,qps,qpsPBM,fpp,fppPrivate,3pcd,btp";

	# Anti fingerprinting
        "dom.battery.enabled" = false;
      };
    };
    profiles."default" = {
      settings = {
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

        # Zen Layout Options
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
      };
      search = {

      };

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
