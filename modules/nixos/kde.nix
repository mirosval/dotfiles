{ self, inputs, ... }: {
  flake.nixosModules.kde = { ... }: {

    # KDE global shortcuts: Nix is the source of truth for
    # ~/.config/kglobalshortcutsrc. Home manager rewrites the file on
    # every activation, so whatever was set in the UI gets overridden.
    # Edit ./kglobalshortcutsrc to change them.
    home-manager.users.miro = {
      xdg.configFile.kglobalshortcutsrc.source = ./kglobalshortcutsrc;
    };
  };
}
