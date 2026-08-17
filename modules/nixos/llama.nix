{ self, inputs, ... }: {
  flake.nixosModules.llama = { pkgs, ... }: {
    networking.firewall.allowedTCPPorts = [ 8083 ];
    services.llama-cpp = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.llama;
      host = "0.0.0.0";
      port = 8083;
      extraFlags = [
        # --- CPU THREADING -----------------------------------------------------------
        # Reserve 1 core for OS/services during decode.
        # Use all 4 threads during prompt prefill bursts.
        "--threads"
        "14"
        "--threads-batch"
        "14"

        # --- SERVER / CONCURRENCY ---------------------------------------------------
        # Single slot, disabled continuous batching for maximum single-user throughput.
        # "--parallel"
        # "1"
        # "--cont-batching"
        # "0"

        # --- GPU / VRAM FIT ---------------------------------------------------------
        "--flash-attn"
        "on"
        "--fit"
        "on"

        # Safety headroom for VRAM physical limit (MiB).
        # Set low (128) because system is headless (100% VRAM available for inference).
        # NOTE: If using MTP draft KV caches, watch out for double VRAM allocation.
        # Bump to 128-256 if you encounter OOMs.
        "--fit-target"
        "128"

        # --- CONTEXT & CACHING ------------------------------------------------------
        "--ctx-size"
        "65536"
        "--context-shift"
        # "1"

        # Disable context checkpoints (avoids reprocessing issues in hybrid architectures)
        "--ctx-checkpoints"
        "0"

        # RAM Prompt Cache (2 GiB)
        "--cache-ram"
        "2048"

        # --- GLOBAL KV CACHE --------------------------------------------------------
        "--cache-type-k"
        "q5_1"
        "--cache-type-v"
        "q5_1"

        # --- PREFILL / BATCHING -----------------------------------------------------
        "--batch-size"
        "2048"
        "--ubatch-size"
        "1024"

        # --- DEFAULT SAMPLING (Coding / Precision) ----------------------------------
        "--temp"
        "0.2"
        "--top-p"
        "0.95"
        "--top-k"
        "20"
        "--min-p"
        "0.0"
        "--repeat-penalty"
        "1.0"
        "--presence-penalty"
        "0.1"
        "--frequency-penalty"
        "0.0"
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
        "Qwen38" = {
          hf-repo = "unsloth/Qwen3.8-27B-GGUF";
          hf-file = " Qwen3.8-27B-Q4_K_M.gguf ";
          alias = "unsloth/Qwen3.8-27B";
          # Disable "fit" to prevent layers from being loaded into the CPU due to an automatic calculation error
          "fit" = "off";
          "ctx-size" = "73728";
          "context-shift" = "1";

          # Native Model MTP (Speculative Decoding)
          "spec-type" = "ngram-mod,draft-mtp";
          "spec-draft-n-max" = "2";

          # KV Quantization (q4_1 allows us to fit 73k context in 16GB VRAM)
          "cache-type-k" = "q4_1";
          "cache-type-v" = "q4_1";

          # Thinking / Reasoning Budget Params
          "chat-template-kwargs" = ''{"preserve_thinking": true, "reasoning_effort":"medium"}'';
          "reasoning-budget" = "5000";

          # Reduced batch sizes to prevent VRAM spikes during massive prefills
          "batch-size" = "1024";
          "ubatch-size" = "512";

          # Official / Recommended Quant Sampler Tuning
          "temp" = "0.4";
          "top-p" = "0.90";
          "top-k" = "15";
          "min-p" = "0.02";
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
