{ lib, ... }:
{
  applications.argocd = {
    namespace = "argocd";
    createNamespace = true;
    helm.releases.argocd = {
      chart = lib.helm.downloadHelmChart {
        repo = "https://argoproj.github.io/argo-helm/";
        chart = "argo-cd";
        version = "8.3.5";
        chartHash = "sha256-lBNSmaxhT0/zoT/9rF6lDuTO0eM8RWZMpbDzxG4O2SA=";
      };
      values = {
        configs.secret.argocdServerAdminPassword = "$2y$10$afCoYAVuSdaC4k3P4lhUcezO4HCLVzCLBaYu03tGi.9WP7Lt47gcC";
      };
    };
  };
}
