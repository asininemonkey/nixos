{...}: {
  programs.mangohud = {
    enable = true;

    settings = {
      # https://github.com/flightlessmango/mangohud/blob/master/data/MangoHud.conf
      cpu_stats = true;
      fps = true;
      frametime = true;
      frame_timing = true;
      gpu_stats = true;
    };
  };
}
