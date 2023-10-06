{ config, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      $hyper = SUPER SHIFT ALT CTRL

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=,preferred,auto,auto

      exec-once = firefox & alacritty

      # Some default env vars.
      env = XCURSOR_SIZE,24

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input {
          kb_layout = us
          kb_variant =
          kb_model =
          kb_options =
          kb_rules =

          follow_mouse = 1

          touchpad {
              natural_scroll = yes 
          }

          sensitivity = 1.0 # -1.0 - 1.0, 0 means no modification.
      }

      general {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          gaps_in = 5
          gaps_out = 20
          border_size = 2
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)

          layout = dwindle
      }

      decoration {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 10
          
          blur {
              enabled = true
              size = 3
              passes = 1
          }

          drop_shadow = yes
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
      }

      animations {
          enabled = yes

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      dwindle {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = yes # you probably want this
      }

      master {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = true
      }

      gestures {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = off
      }

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
      device:epic-mouse-v1 {
          sensitivity = -0.5
      }

      bind = $hyper, B, exec, firefox
      bind = $hyper, A, exec, alacritty
      bind = $hyper, X, killactive
      bind = $hyper, F, fullscreen
      bind = $hyper, M, exit

      # Move focus with hyper + hjkl keys
      bind = $hyper, h, movefocus, l
      bind = $hyper, j, movefocus, d
      bind = $hyper, k, movefocus, u
      bind = $hyper, l, movefocus, d

      # Switch workspaces with hyper + [0-9]
      bind = $hyper, 1, workspace, 1
      bind = $hyper, 2, workspace, 2
      bind = $hyper, 3, workspace, 3
      bind = $hyper, 4, workspace, 4
      bind = $hyper, 5, workspace, 5
      bind = $hyper, 6, workspace, 6
      bind = $hyper, 7, workspace, 7
      bind = $hyper, 8, workspace, 8
      bind = $hyper, 9, workspace, 9
      bind = $hyper, 0, workspace, 10

      # Scroll through existing workspaces with hyper + scroll
      bind = $hyper, mouse_down, workspace, e+1
      bind = $hyper, mouse_up, workspace, e-1

      # Move/resize windows with hyper + LMB/RMB and dragging
      bindm = $hyper, mouse:272, movewindow
      bindm = $hyper, mouse:273, resizewindow
    '';
  };
}
