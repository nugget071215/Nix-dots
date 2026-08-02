services.swayidle = {
  enable = true;

  timeouts = [
    {
      timeout = 300;
      command = "${pkgs.swaylock-effects}/bin/swaylock -f";
    }

    {
      timeout = 600;
      command = "mmsg dispatch dpms off";
    }
  ];

  events = {
    before-sleep = "${pkgs.swaylock-effects}/bin/swaylock -f";
  };
};
