{
  custom,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    aichat
    gollama
    oterm
  ];

  services.ollama = {
    enable = true;

    loadModels =
      if custom.host.name == "asrock-x570-linux"
      then [
        "deepseek-r1:8b"
        "mistral:7b"
        "qwen3:8b"
      ]
      else [
        "tinyllama:1.1b"
      ];

    package =
      if custom.host.name == "asrock-x570-linux"
      then pkgs.ollama-cuda
      else pkgs.ollama-rocm;
  };
}
