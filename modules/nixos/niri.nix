{ self, inputs, ... }: {
  flake.wrappersModules.niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.terminal = lib.mkOption {
        type = lib.types.str;
        default = "alacritty";
      };

      config.settings =
        let
          noctaliaExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.noctalia;
        in
        {
          xwayland-satellite.path = lib.getExe config.pkgs.xwayland-satellite;

          input.keyboard.xkb.layout = "us";

          spawn-at-startup = [
            # (lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.noctalia)
            noctaliaExe
          ];

          binds = {
            "Mod+Return".spawn = config.terminal;
            "Mod+Space".spawn-sh = "${noctaliaExe} ipc call launcher toggle";
            "Mod+Comma".spawn-sh = "${noctaliaExe} ipc call settings toggle";

            "Mod+Q".close-window = _: { };
            "Mod+F".maximize-column = _: { };
            "Mod+G".fullscreen-window = _: { };
            "Mod+Shift+F".toggle-window-floating = _: { };
            "Mod+C".center-column = _: { };
            "Mod+U".show-hotkey-overlay = _: { };
            "Mod+O".toggle-overview = _: { };

            "Mod+H".focus-column-left = _: { };
            "Mod+L".focus-column-right = _: { };
            "Mod+K".focus-window-up = _: { };
            "Mod+J".focus-window-down = _: { };

            "Mod+Left".focus-column-left = _: { };
            "Mod+Right".focus-column-right = _: { };
            "Mod+Up".focus-window-up = _: { };
            "Mod+Down".focus-window-down = _: { };

            "Mod+Shift+H".move-column-left = _: { };
            "Mod+Shift+L".move-column-right = _: { };
            "Mod+Shift+K".move-window-up = _: { };
            "Mod+Shift+J".move-window-down = _: { };

            "Mod+1".focus-workspace = "w0";
            "Mod+2".focus-workspace = "w1";
            "Mod+3".focus-workspace = "w2";
            "Mod+4".focus-workspace = "w3";
            "Mod+5".focus-workspace = "w4";
            "Mod+6".focus-workspace = "w5";
            "Mod+7".focus-workspace = "w6";
            "Mod+8".focus-workspace = "w7";
            "Mod+9".focus-workspace = "w8";
            "Mod+0".focus-workspace = "w9";

            "Mod+Shift+1".move-column-to-workspace = "w0";
            "Mod+Shift+2".move-column-to-workspace = "w1";
            "Mod+Shift+3".move-column-to-workspace = "w2";
            "Mod+Shift+4".move-column-to-workspace = "w3";
            "Mod+Shift+5".move-column-to-workspace = "w4";
            "Mod+Shift+6".move-column-to-workspace = "w5";
            "Mod+Shift+7".move-column-to-workspace = "w6";
            "Mod+Shift+8".move-column-to-workspace = "w7";
            "Mod+Shift+9".move-column-to-workspace = "w8";
            "Mod+Shift+0".move-column-to-workspace = "w9";

            "Mod+S".spawn-sh = "${noctaliaExe} ipc call launcher toggle";
            "Mod+V".spawn-sh = "${config.pkgs.alsa-utils}/bin/amixer sset Capture toggle";

            # "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
            # "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
            "XF86AudioRaiseVolume".spawn-sh = "${noctaliaExe} ipc call volume increase";
            "XF86AudioLowerVolume".spawn-sh = "${noctaliaExe} ipc call volume decrease";
            "XF86AudioMute".spawn-sh = "${noctaliaExe} ipc call volume muteOutput";
            "XF86MonBrightnessUp".spawn-sh = "${noctaliaExe} ipc call brightness increase";
            "XF86MonBrightnessDown".spawn-sh = "${noctaliaExe} ipc call brightness decrease";

            "Mod+Ctrl+H".set-column-width = "-5%";
            "Mod+Ctrl+L".set-column-width = "+5%";
            "Mod+Ctrl+J".set-window-height = "-5%";
            "Mod+Ctrl+K".set-window-height = "+5%";

            "Mod+WheelScrollDown".focus-column-left = _: { };
            "Mod+WheelScrollUp".focus-column-right = _: { };
            "Mod+Ctrl+WheelScrollDown".focus-workspace-down = _: { };
            "Mod+Ctrl+WheelScrollUp".focus-workspace-up = _: { };

            "Mod+Ctrl+S".spawn-sh =
              "${lib.getExe config.pkgs.grim} -l 0 - | ${config.pkgs.wl-clipboard}/bin/wl-copy";

            "Mod+Shift+E".spawn-sh =
              "${config.pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe config.pkgs.swappy} -f -";

            "Mod+Shift+S".spawn-sh = lib.getExe (
              config.pkgs.writeShellApplication {
                name = "screenshot";
                text = ''
                  ${lib.getExe config.pkgs.grim} -g "$(${lib.getExe config.pkgs.slurp} -w 0)" - \
                  | ${config.pkgs.wl-clipboard}/bin/wl-copy
                '';
              }
            );
          };

          layout = {
            gaps = 5;

            focus-ring = {
              width = 2;
            };
          };

          workspaces =
            let
              settings = {
                layout.gaps = 5;
              };
            in
            {
              "w0" = settings;
              "w1" = settings;
              "w2" = settings;
              "w3" = settings;
              # "w4" = settings;
              # "w5" = settings;
              # "w6" = settings;
              # "w7" = settings;
              # "w8" = settings;
              # "w9" = settings;
            };

          window-rule = {
            geometry-corner-radius = 10;
            clip-to-geometry = true;
          };

          debug = {
            honor-xdg-activation-with-invalid-serial = _: { };
          };
        };
    };

  flake.nixosModules.niri = { pkgs, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
    };
    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd niri-session";
    };
  };

  perSystem = { pkgs, lib, ... }: {
    packages = lib.optionalAttrs pkgs.stdenv.isLinux {
      niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        imports = [ self.wrappersModules.niri ];
      };
    };
  };
}
