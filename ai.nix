{
  config,
  pkgs,
  ...
}:

{
  environment.systemPackages = (if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then with pkgs; [
  ] ++ (with pkgs.unstable; [
  ]) else []) ++ (with pkgs; [
  ]) ++ (with pkgs.unstable; [
    alpaca
    gollama
  ]);

  home-manager.users.jcardoso = { ... }: {
    programs.zed-editor.userSettings.assistant.default_model = {
      model = if config.networking.hostName == "asus-zenbook" || config.networking.hostName == "macbook-pro-work" then "llama3.2:1b" else "llama3.2:3b";
      provider = "ollama";
    };
  };

  services.ollama = {
    enable = true;

    loadModels = if config.networking.hostName == "asus-zenbook" || config.networking.hostName == "macbook-pro-work" then [
      "llama3.2:1b"
      "tinyllama:1.1b"
    ] else [
      "llama3.2:3b"
      "mistral:7b"
    ];

    package = pkgs.unstable.ollama;
  };
}
