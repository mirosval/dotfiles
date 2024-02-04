{ pkgs, config, ... }:
let
  backupHost = "10.42.0.3";
  backupUser = "butters_backups";
  backupsPassword = config.secrets.butters.backups_password;
  backupsSshKey = config.secrets.butters.backups_ssh_key;
in
{
  environment.systemPackages = with pkgs; [
    restic
  ];
  #
  # users.users.restic = {
  #   isNormalUser = true;
  # };
  #
  # security.wrappers.restic = {
  #   source = "${pkgs.restic.out}/bin/restic";
  #   owner = "restic";
  #   group = "users";
  #   permissions = "u=rwx,g=,o=";
  #   capabilities = "cap_dac_read_search=+ep";
  # };

  services.restic.backups.cartman = {
    # user = "restic";
    # package = "${config.security.wrapperDir}/restic";
    repository = "sftp:${backupUser}@${backupHost}:butters/backups";
    passwordFile = backupsPassword;
    extraOptions = [
      "sftp.command='ssh ${backupUser}@${backupHost} -i ${backupsSshKey} -s sftp'"
    ];
    initialize = true;
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 75"
    ];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    paths = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/group"
      "/etc/machine-id"
    ];
  };
}
