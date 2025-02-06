{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = if pkgs.stdenv.isDarwin then "buttonless" else "None";
        startup_mode = if pkgs.stdenv.isDarwin then "SimpleFullscreen" else "Fullscreen";
        option_as_alt = "Both";
      };
      font =
        let
          font = "MonaspiceAr Nerd Font";
          #font = "Hasklug Nerd Font";
        in
        {
          size = 11;
          normal = {
            family = font;
            style = if pkgs.stdenv.isDarwin then "Light" else "Regular";
          };
          bold = {
            family = font;
            style = "Medium";
          };
          italic = {
            family = font;
            style = "Italic";
          };
          bold_italic = {
            family = font;
            style = "Medium Italic";
          };
        };
      # TokyoNight Alacritty Colors
      colors = {
        primary = {
          background = "0x1a1b26";
          foreground = "0xc0caf5";
        };
        normal = {
          black = "0x15161E";
          red = "0xf7768e";
          green = "0x9ece6a";
          yellow = "0xe0af68";
          blue = "0x7aa2f7";
          magenta = "0xbb9af7";
          cyan = "0x7dcfff";
          white = "0xa9b1d6";
        };
        bright = {
          black = "0x414868";
          red = "0xf7768e";
          green = "0x9ece6a";
          yellow = "0xe0af68";
          blue = "0x7aa2f7";
          magenta = "0xbb9af7";
          cyan = "0x7dcfff";
          white = "0xc0caf5";
        };
        indexed_colors = [
          { index = 16; color = "0xff9e64"; }
          { index = 17; color = "0xdb4b4b"; }
        ];
      };
      keyboard.bindings = [
        {
          key = "F";
          mods = "Command|Control";
          action = if pkgs.stdenv.isDarwin then "ToggleSimpleFullscreen" else "ToggleFullscreen";
        }
      ];
    };
  };
}
