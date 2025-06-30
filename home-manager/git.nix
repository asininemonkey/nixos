{
  custom,
  pkgs,
  ...
}: {
  home.file = {
    ".config/git/allowed_signers".text = ''
      ${custom.user.email} ${custom.user.ssh}
    '';
  };

  programs.git = {
    diff-so-fancy.enable = true;
    enable = true;

    extraConfig = {
      # https://blog.gitbutler.com/how-git-core-devs-configure-git/
      branch.sort = "-committerdate";
      column.ui = "auto";
      commit.verbose = true;
      diff.algorithm = "histogram";
      diff.colorMoved = "plain";
      diff.mnemonicPrefix = true;
      diff.renames = true;
      fetch.all = true;
      fetch.prune = true;
      fetch.pruneTags = true;
      help.autocorrect = "prompt";
      push.autoSetupRemote = true;
      push.default = "simple";
      push.followTags = true;
      rebase.autoSquash = true;
      rebase.autoStash = true;
      rebase.updateRefs = true;
      rerere.autoupdate = true;
      rerere.enabled = true;
      tag.sort = "version:refname";

      commit.gpgsign = true;
      core.editor = "zeditor --wait";
      credential.helper = "libsecret";
      diff.tool = "zeditor";
      difftool."zeditor".cmd = "zeditor --diff \${LOCAL} \${REMOTE} --wait";
      gpg."ssh".allowedSignersFile = "~/.config/git/allowed_signers";
      # gpg."ssh".program = "/run/current-system/sw/bin/xxx";
      gpg.format = "ssh";
      init.defaultBranch = "main";
      merge.tool = "zeditor";
      mergetool."zeditor".cmd = "zeditor --wait \${MERGED}";
      pull.rebase = true;
      # url."https://github.com".insteadOf = "ssh://git@github.com";
      user.signingkey = custom.user.ssh;
    };

    package = pkgs.gitFull;
    userEmail = custom.user.email;
    userName = custom.user.full;
  };
}
