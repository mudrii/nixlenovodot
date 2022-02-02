{ config, pkgs, lib, ... }:

{
  home-manager.users.mudrii = {
    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = "mudrii";
      userEmail = "mudreac@gmail.com";
      ignores = [ "*~" "*.swp" ];

      signing = {
        key = "C37CEF50333B225E2FCA7D2003B8C6E70C3ED787";
        signByDefault = true;
      };

      aliases = {
        unstage = "reset HEAD --";
        pr = "pull --rebase";
        addp = "add --patch";
        comp = "commit --patch";
        co = "checkout";
        ci = "commit";
        c = "commit";
        b = "branch";
        p = "push";
        d = "diff";
        a = "add";
        s = "status";
        f = "fetch";
        pa = "add --patch";
        pc = "commit --patch";
        rf = "reflog";
        l = "log --graph --pretty='%Cred%h%Creset - %C(bold blue)<%an>%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)' --abbrev-commit --date=relative";
        pp = "!git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)";
        recent-branches = "branch --sort=-committerdate";
      };
      extraConfig = {
        branch = { autoSetupMerge = "always"; };
        stash = { showPatch = true; };
        status = { showUntrackedFiles = "all"; };
        transfer = { fsckobjects = false; };
        #commit = { gpgsign = true; };

        core = {
          #            pager = "less -R";
          #            autocrlf = "input";
          editor = "nvim";
        };

        /*         credential."https://github.com" = {
          #helper = "!${pkgs.gh}/bin/gh auth git-credential";
          helper = "!/run/current-system/sw/bin/gh auth git-credential";
          }; */

        merge = {
          conflictstyle = "diff3";
          ff = "only";
          summary = true;
          tool = "vimdiff";
          renamelimit = 10000;
        };

        remote = {
          push = [
            "refs/heads/*:refs/heads/*"
            "refs/tags/*:refs/tags/*"
          ];

          fetch = [
            "refs/heads/*:refs/remotes/origin/*"
            "refs/tags/*:refs/tags/*"
          ];
        };

        pull = {
          rebase = true;
        };

        rebase = {
          stat = true;
          autoSquash = true;
          autostash = true;
        };
      };
    };
  };
}
