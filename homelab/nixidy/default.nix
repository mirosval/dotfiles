{
  nixidy.target.repository = "https://github.com/mirosval/dotfiles.git";
  nixidy.target.branch = "master";
  nixidy.target.rootPath = "./homelab/generated_manifests";
  imports = [
    ./argocd.nix
  ];
}
