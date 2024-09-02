{
  description = "C project templated from github:mtjon/nix-flake-templates#c.";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, flake-utils, devshell }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlays.default ];
        };
        # Example of local packaged script
        #my-script-buildInputs = with pkgs; [ curl ];
        #my-script = (pkgs.writeScriptBin "my-script" (builtins.readFile ./scripts/my_script.sh)).overrideAttrs(old: {
        #  buildCommand = "${old.buildCommand}\n patchShebangs $out";
        #});
      in
      rec {
        name = "C project.";

        packages = {
          c = {};
          default = packages.c;
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

            packages = with pkgs; [
                gcc
                ccls
                sops # sops
                age # used for sops encryption
                #yq-go # used to filter yaml from sops secrets
                # add further packages here, e.g.:
                #openapi-generator-cli
                # can also add local scripts from flake's packages
                #my-script
              ];
          };
        };
      }
    );
}
