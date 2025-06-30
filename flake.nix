{
  description = "NixOS Configuration";

  inputs = {
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-25.05";
    };

    lix-module = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nur = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nur";
    };

    plasma-manager = {
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };

      url = "github:nix-community/plasma-manager";
    };
  };

  outputs = {
    disko,
    home-manager,
    lix-module,
    nix-flatpak,
    nixpkgs,
    nixpkgs-unstable,
    nur,
    plasma-manager,
    ...
  }: let
    custom = {
      desktop = "kde";

      font = {
        mono = {
          name = "IosevkaTerm Nerd Font";
          package = pkgs.nerd-fonts.iosevka-term;
          size = 14;
        };

        sans = {
          name = "Arcticons Sans";
          package = pkgs.arcticons-sans;
          size = 14;
        };
      };

      host = {
        id = "desktop";
        network.interface = "enp4s0";
        name = "asrock-x570-linux";
        system = "x86_64-linux";
      };

      image = {
        greet = builtins.fetchurl {
          sha256 = "sha256:14cfwkv4fbqgxkn21zw1bnypg163ql4rgpgy586hn7qx0jhw6499";
          url = "https://raw.githubusercontent.com/dharmx/walls/refs/heads/main/unsorted/a_street_with_buildings_and_trees.png";
        };

        lock = builtins.fetchurl {
          sha256 = "sha256:0znjg0n95ylqwfgdnvma43pbxkizl07z1c46mh9vjvjvw9n6a532";
          url = "https://raw.githubusercontent.com/dharmx/walls/refs/heads/main/unsorted/a_girl_walking_on_a_road_in_a_forest.jpg";
        };

        wall = builtins.fetchurl {
          sha256 = "sha256:17mzhlic6pg89lk16clnd73hxz426i97lx1pr6z19vkvrs0sb257";
          url = "https://raw.githubusercontent.com/dharmx/walls/refs/heads/main/unsorted/a_group_of_people_standing_on_a_road_with_a_city_in_the_background.jpg";
        };
      };

      password-manager =
        if custom.desktop == "niri"
        then {
          chrome-extension = "nngceckbapebfimnlniiiahkandclblb";

          mozilla-extension = {
            id = "446900e4-71c2-419f-a6a7-df9c091e268b";
            name = "bitwarden-password-manager";
          };

          ssh-agent = ".bitwarden-ssh-agent.sock";
        }
        else {
          chrome-extension = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";

          mozilla-extension = {
            id = "d634138d-c276-4fc8-924b-40a0ea21d284";
            name = "1password-x-password-manager";
          };

          ssh-agent = ".1password/agent.sock";
        };

      tailnet = {
        name = "fable-blues.ts.net";
        server = "intel-nuc";
      };

      webdav = {
        name = "intel-nuc";
        server = "files.josecardoso.net";
      };

      user = {
        email = "65740649+asininemonkey@users.noreply.github.com";
        full = "Jose Cardoso";
        name = "jcardoso";
        ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQowLl5Bzn87ig+Gs7Ze5kWODRTdHiD+V8sOCwOx16Z personal";
      };
    };

    pkgs = nixpkgs.legacyPackages.${custom.host.system};
    pkgs-nur = nur.legacyPackages.${custom.host.system};
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${custom.host.system};
  in {
    nixosConfigurations.${custom.host.id} = nixpkgs.lib.nixosSystem {
      modules = [
        ./nixos/configuration.nix

        disko.nixosModules.disko
        lix-module.nixosModules.default
        nix-flatpak.nixosModules.nix-flatpak

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = {
              inherit custom pkgs-nur pkgs-unstable;
            };

            sharedModules = [
              plasma-manager.homeManagerModules.plasma-manager
            ];

            useGlobalPkgs = true;
            useUserPackages = true;
            users.${custom.user.name} = import ./home-manager/configuration.nix;
          };
        }
      ];

      specialArgs = {
        inherit custom pkgs-nur pkgs-unstable;
      };
    };
  };
}
