{ pkgs ? import <nixpkgs> {}
, dependencies ? [] }:
pkgs.mkShell {
  name = "devshell";
  packages = with pkgs; [
    age 
    sops
    yq-go
    ] ++ dependencies;
  shellHook = ''
  '';
}

