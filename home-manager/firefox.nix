{custom, ...}: let
  locale = "en-GB";
in {
  programs.firefox = {
    enable = true;

    languagePacks = [
      locale
    ];

    policies = {
      # https://mozilla.github.io/policy-templates/
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableFirefoxStudies = true;
      DisableFormHistory = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "always";

      DNSOverHTTPS = {
        Enabled = true;
        # Fallback = false;
        ProviderURL = "https://firefox.dns.nextdns.io/";
      };

      EncryptedMediaExtensions = true;

      ExtensionSettings = let
        install_url_prefix = "https://addons.mozilla.org/firefox/downloads/latest";
      in {
        "{${custom.password-manager.mozilla-extension.id}}" = {
          default_area = "navbar";
          install_url = "${install_url_prefix}/${custom.password-manager.mozilla-extension.name}/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
        };

        "{74145f27-f039-47ce-a470-a662b129930a}" = {
          default_area = "menupanel";
          install_url = "${install_url_prefix}/clearurls/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
        };

        "aboutsync@mhammond.github.com" = {
          default_area = "menupanel";
          install_url = "${install_url_prefix}/about-sync/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
        };

        "addon@darkreader.org" = {
          default_area = "menupanel";
          install_url = "${install_url_prefix}/darkreader/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
        };

        "enhancerforyoutube@maximerf.addons.mozilla.org" = {
          default_area = "menupanel";
          install_url = "${install_url_prefix}/enhancer-for-youtube/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
        };

        "testpilot-containers" = {
          default_area = "menupanel";
          install_url = "${install_url_prefix}/multi-account-containers/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
        };

        "uBlock0@raymondhill.net" = {
          default_area = "navbar";
          install_url = "${install_url_prefix}/ublock-origin/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
        };
      };

      FirefoxHome = {
        Highlights = false;
        Locked = true;
        Pocket = false;
        Snippets = false;
        SponsoredPocket = false;
        SponsoredTopSites = false;
        TopSites = false;
      };

      FirefoxSuggest = {
        ImproveSuggest = false;
        SponsoredSuggestions = false;
        WebSuggestions = false;
      };

      Homepage = {
        URL = "https://start.duckduckgo.com/?kad=en_GB&kak=-1&kaq=-1&kau=-1&kbe=0&kbg=-1&kl=uk-en&kn=1";
      };

      HttpsOnlyMode = "enabled";

      ManagedBookmarks = [
        {
          toplevel_name = "NixOS";
        }
        {
          name = "Home Manager Option Search";
          url = "https://home-manager-options.extranix.com/";
        }
        {
          name = "NixOS Flake Search";
          url = "https://search.nixos.org/flakes";
        }
        {
          name = "NixOS Option Search";
          url = "https://search.nixos.org/options";
        }
        {
          name = "NixOS Package Search";
          url = "https://search.nixos.org/packages";
        }
        {
          name = "NixOS Releases";
          url = "https://releases.nixos.org/?prefix=nixos";
        }
        {
          name = "NixOS Status";
          url = "https://status.nixos.org/";
        }
      ];

      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;

      PopupBlocking = {
        Allow = [
          "https://mail.proton.me"
        ];

        Default = true;
      };

      RequestedLocales = locale;
      SanitizeOnShutdown = true;

      SearchEngines = {
        Add = [
          {
            Alias = "@searxng";
            Description = "SearXNG is a metasearch engine that respects your privacy.";
            IconURL = "https://search.rhscz.eu/static/themes/simple/img/favicon.png";
            Method = "GET";
            Name = "SearXNG";
            SuggestURLTemplate = "https://search.rhscz.eu/autocompleter?language=${locale}&q={searchTerms}";
            URLTemplate = "https://search.rhscz.eu/search?language=${locale}&q={searchTerms}";
          }
        ];

        Default = "DuckDuckGo";

        Remove = [
          "Bing"
          "eBay"
          "Google"
        ];
      };

      ShowHomeButton = true;
      SkipTermsOfUse = true;
      SSLVersionMin = "tls1.2";

      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        FirefoxLabs = false;
        MoreFromMozilla = false;
        SkipOnboarding = true;
        UrlbarInterventions = false;
      };
    };

    profiles."${custom.user.name}".settings = {
      # resource:///defaults/preferences/firefox.js
      # resource://gre/greprefs.js
      "app.shield.optoutstudies.enabled" = false; # No Policy
      "browser.aboutConfig.showWarning" = false; # No Policy
      "browser.bookmarks.addedImportButton" = true; # No Policy
      "browser.crashReports.unsubmittedCheck.autoSubmit2" = false; # No Policy
      "browser.preferences.experimental.hidden" = true; # No Policy
      "browser.search.suggest.enabled.private" = true; # No Policy
      "browser.toolbars.bookmarks.showOtherBookmarks" = false; # No Policy

      "browser.uiCustomization.state" = builtins.toJSON {
        currentVersion = 22;

        placements.nav-bar = [
          "back-button"
          "forward-button"
          "stop-reload-button"
          "home-button"
          "customizableui-special-spring1"
          "urlbar-container"
          "customizableui-special-spring2"
          "developer-button"
          "downloads-button"
          "print-button"
          "screenshot-button"
          "fxa-toolbar-menu-button"
          "customizableui-special-spring3"
          "_${custom.password-manager.mozilla-extension.id}_-browser-action"
          "ublock0_raymondhill_net-browser-action"
          "unified-extensions-button"
        ];
      }; # No Policy

      "browser.tabs.loadInBackground" = false; # No Policy
      "browser.urlbar.suggest.engines" = false; # No Policy
      "browser.urlbar.suggest.trending" = false; # No Policy
      "font.minimum-size.x-western" = custom.font.sans.size; # No Policy
      "font.name.monospace.x-western" = custom.font.mono.name; # No Policy
      "font.name.sans-serif.x-western" = custom.font.sans.name; # No Policy
      "font.name.serif.x-western" = custom.font.sans.name; # No Policy
      "font.size.monospace.x-western" = custom.font.mono.size; # No Policy
      "font.size.variable.x-western" = custom.font.sans.size; # No Policy
      "layout.css.prefers-color-scheme.content-override" = 0; # No Policy
      "network.cookie.lifetimePolicy" = 2; # No Policy
      "places.history.enabled" = false; # No Policy
      "privacy.cpd.cache" = true; # No Policy
      "privacy.cpd.cookies" = true; # No Policy
      "privacy.cpd.formdata" = true; # No Policy
      "privacy.cpd.history" = true; # No Policy
      "privacy.cpd.offlineApps" = true; # No Policy
      "privacy.cpd.passwords" = true; # No Policy
      "privacy.cpd.sessions" = true; # No Policy
      "privacy.cpd.siteSettings" = true; # No Policy
      "privacy.globalprivacycontrol.enabled" = true; # No Policy
      "privacy.history.custom" = true; # No Policy
      "signon.autofillForms" = false; # No Policy
      "signon.firefoxRelay.feature" = "disabled"; # No Policy
      "signon.generation.enabled" = false; # No Policy
      "signon.management.page.breach-alerts.enabled" = false; # No Policy
      "widget.gtk.overlay-scrollbars.enabled" = false; # No Policy
      "xpinstall.signatures.required" = true; # No Policy
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };
}
