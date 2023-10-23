{ pkgs, config, ... }:
let
  backupHost = "cartman";
  backupUser = "butters_backups";
  backupsPassword = config.secrets.butters.backups_password;
  backupsSshKey = config.secrets.butters.backups_ssh_key;
in
{
  users.users.restic = {
    isNormalUser = true;
  };

  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = "restic";
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  services.restic.backups.cartman = {
    user = "restic";
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
    paths = [ ];
  };
}
