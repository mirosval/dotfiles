{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # terminal
    direnv
    starship
    zsh-syntax-highlighting

    # silly
    cowsay
    neofetch
  ];
}
