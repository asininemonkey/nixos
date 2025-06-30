{
  custom,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    alpaca
    gollama
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
  };
}
