{ data, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = data.git.userName;
        email = data.git.userEmail;
      };
      commit.gpgSign = true;
      init.defaultBranch = "master";
    };
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519";
    };
  };
}
