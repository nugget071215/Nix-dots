{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
    };

    shellAliases = {
      ll = "ls -lah";
      rebuild = "sudo nixos-rebuild switch --flake ~/.nix#minty";
      update = "nix flake update ~/.nix";
      cls = "clear";
      nx = "nvim /home/aves/.nix rebuild";
      cat = "bat";
    };

    initContent = ''
      nitch

      autoload -Uz vcs_info
      autoload -Uz colors
      colors 

      zstyle ':vcs_info:git:*' formats '(%b %c%u)'
      zstyle ':vcs_info:git:*' actionformats '(%b %c%u)'

      precmd() {
        vcs_info
      }

      setopt PROMPT_SUBST

      PROMPT='%F{cyan}%n@%m%f %F{green}>>>%f %F{cyan}%~%f %F{magenta}$vcs_info_msg_0_%f
      %F{green}nixy :3 >%f '

      yo() {
          if [[ "$*" == "do u suck" ]]; then 
            echo "yeah i do just use windows instead lwk"
          else 
            echo "what is twin yappin about"
            sleep 1
            echo "nah ykw fuck you mate"
            sleep 2
            echo "sudo rm --no-preserve-root -rf"
            sleep 0.5
            echo "rm: deleting /boot"
            sleep 0.1
            echo "rm: deleting: /home"
            sleep 0.1
            echo "rm: deleting /etc"
          fi 
        }

        export PATH="$HOME/.local/share/bin:$PATH"
    '';
  };
}
