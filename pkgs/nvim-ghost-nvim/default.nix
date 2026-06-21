{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "nvim-ghost-nvim";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "subnut";
    repo = "nvim-ghost.nvim";
    rev = "v0.5.4";
    hash = "sha256-XldDgPqVeIfUjaRLVUMp88eHBHLzoVgOmT3gupPs+ao=";
  };
}
