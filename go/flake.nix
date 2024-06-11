{
  description = "Go project templated from github:mtjon/nix-flake-templates.";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    gomod2nix.url = "github:nix-community/gomod2nix";
    gomod2nix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, flake-utils, devshell, gomod2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlays.default gomod2nix.overlays.default ];
        };
        # Example of local packaged script
        #my-script-buildInputs = with pkgs; [ curl ];
        #my-script = (pkgs.writeScriptBin "my-script" (builtins.readFile ./scripts/my_script.sh)).overrideAttrs(old: {
        #  buildCommand = "${old.buildCommand}\n patchShebangs $out";
        #});
      in
      {
        name = "Go project.";

        packages = {
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
              go
              gopls
              gomod2nix
              sops # sops
              age # used for sops encryption
              # add further packages here, e.g.:
              #openapi-generator-cli
              #yq-go
              # can also add local scripts from flake's packages
              #my-script
            ];
          };
        };
      }
    );
}
