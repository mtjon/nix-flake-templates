{
  description = "Go project templated from github:mtjon/nix-flake-templates#go.";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
  outputs = { self, nixpkgs, flake-utils, devshell, gomod2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlays.default gomod2nix.overlays.default ];
        };
        goAttrs = {
          pname = "hello-go";
          version = "0.1";
          pwd = ./.;
          src = ./.;
          modules = ./gomod2nix.toml; 
          vendorHash = null;
        };
        goBuild = pkgs.buildGoModule goAttrs;
        goBuildCross = pkgs.pkgsCross.aarch64-multiplatform.buildGoModule goAttrs;
        dockerImage = pkgs.dockerTools.buildLayeredImage {
          # change name appropriately
          name = "go-project";
          tag = "0.1.0-snapshot";
          # select appropriate architecture
          architecture = "amd64";
          # change Cmd appropriately
          config.Cmd = [ "${goBuildCross}/bin/hello-world" ];
          # Set the created to some meaningful date, breaking reproducibility
          #created = "now";
        };
        # Example of local packaged script
        #my-script-buildInputs = with pkgs; [ curl ];
        #my-script = (pkgs.writeScriptBin "my-script" (builtins.readFile ./scripts/my_script.sh)).overrideAttrs(old: {
        #  buildCommand = "${old.buildCommand}\n patchShebangs $out";
        #});
      in
      rec {
        name = "Go project.";

        packages = {
          go = goBuild;
          docker = dockerImage;
          default = packages.go;
          # Example of local packaged script
          #my-script = pkgs.symlinkJoin {
          #  name = my-script;
          #  paths = [ my-script ] ++ my-script-buildInputs;
          #  buildInputs = [ pkgs.makeWrapper ];
          #  postBuild = "wrapProgram $out/bin/my-script --prefix PATH : $out /bin";
          #};
        };
        apps = {};
        devShells = {
          default = pkgs.devshell.mkShell {
            # Define the environment of your devshell
            env = [
            # e.g.
            #{
            #  name = "FOO";
            #  eval = "$(sops -d ./secrets/local.yaml | yq '.foo')";
            #}
            ];

            packages = (with pkgs; [
                go
                gopls
                sops # sops
                age # used for sops encryption
                skopeo # used for copying docker/ oci images between registries
                # add further packages here, e.g.:
                #openapi-generator-cli
                #yq-go
                # can also add local scripts from flake's packages
                #my-script
              ]) ++ [
                gomod2nix.packages.${system}.default
              ];
          };
        };
      }
    );
}
