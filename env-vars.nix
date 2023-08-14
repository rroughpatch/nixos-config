{
  lib,
  system,
  config,
  pkgs,
  inputs,

  username,

  editor,
  browser,
  ...
}:

{
  environment.variables = {
    EDITOR = "${editor}";
    BROWSER = "${browser}";
    NIXPKGS_ALLOW_UNFREE = "1";
  };
}

