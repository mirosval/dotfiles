{ self, inputs, ... }: {
  flake.nixosModules.llama = { pkgs, ... }: {
    networking.firewall.allowedTCPPorts = [ 8083 ];
    services.llama-cpp = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.llama;
      host = "0.0.0.0";
      port = 8083;
      extraFlags = [
        "--ctx-size"
        "65536"
        "--n-gpu-layers"
        "99"
        "--flash-attn"
        "on"
      ];
      # settings.model-preset = (pkgs.formats.ini { }).generate "models-preset.ini" {
      modelsPreset = {
        "Qwen3" = {
          hf-repo = "unsloth/Qwen3.6-35B-A3B-GGUF";
          hf-file = "Qwen3.6-35B-A3B-UD-IQ3_S.gguf";
          alias = "unsloth/Qwen3.6-35B-A3B";
          temp = "1.0";
          top-p = "0.95";
          top-k = "20";
        };
      };
    };
  };

  perSystem =
    { system, ... }:
    let
      unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages.llama = unstable.llama-cpp-rocm;
    };
}
