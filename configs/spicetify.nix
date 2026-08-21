{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};

  # Opacity of the different surfaces. 0 = fully see-through, 1 = opaque.
  mainAlpha = "0.60"; # main background / sidebar / player bar / topbar
  cardAlpha = "0.50"; # cards, tracklists, menus, inputs
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  programs.spicetify = {
    enable = true;

    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];

    theme = spicePkgs.themes.ziro // {
      additionalCss = ''
        /* ===== Transparent overrides ===== */
        :root {
          --spice-main: rgba(var(--spice-rgb-main), ${mainAlpha});
          --spice-main-elevated: rgba(var(--spice-rgb-main), ${mainAlpha});
          --spice-highlight: rgba(var(--spice-rgb-main), ${mainAlpha});
          --spice-highlight-elevated: rgba(var(--spice-rgb-main), ${mainAlpha});
          --spice-card-elevated: rgba(var(--spice-rgb-card), ${cardAlpha});
          --spice-sidebar: rgba(var(--spice-rgb-main), ${mainAlpha});
          --spice-player: rgba(var(--spice-rgb-main), ${mainAlpha});
          --spice-card: rgba(var(--spice-rgb-card), ${cardAlpha});
          --spice-button-disabled: rgba(var(--spice-rgb-button-disabled), 0.55);
        }

        /* outermost containers must be see-through for the compositor */
        html, body, .Root, .Root__container, .Root__top-container {
          background: transparent !important;
        }

        /* album/playlist header gradient was fully opaque */
        .main-entityHeader-container.main-entityHeader-withBackgroundImage {
          background-image: linear-gradient(50deg, rgba(var(--spice-rgb-card), 0.55) 30%, rgba(var(--spice-rgb-card), 0.35) 60%, transparent 90%) !important;
        }
      '';
    };
    colorScheme = "rose-pine-moon";
  };
}
