{
  description = "Rust project templated from github:mtjon/nix-flake-templates#rust.";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    naersk = {
      url = "github:nix-community/naersk/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, flake-utils, naersk }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        naersk-lib = pkgs.callPackage naersk { };
        # Example of local packaged script
        #my-script-buildInputs = with pkgs; [ curl ];
        #my-script = (pkgs.writeScriptBin "my-script" (builtins.readFile ./scripts/my_script.sh)).overrideAttrs(old: {
        #  buildCommand = "${old.buildCommand}\n patchShebangs $out";
        #});
      in
      {
        name = "Rust project.";

        packages = {
          # Example of local packaged script
          #my-script = pkgs.symlinkJoin {
          #  name = my-script;
          #  paths = [ my-script ] ++ my-script-buildInputs;
          #  buildInputs = [ pkgs.makeWrapper ];
          #  postBuild = "wrapProgram $out/bin/my-script --prefix PATH : $out /bin";
          #};
          default = naersk-lib.buildPackage ./.;
        };
        apps = {};
        devShells = {
          default = import ./shell.nix { 
            inherit pkgs;
            dependencies = with pkgs; [
              cargo 
              rustc
              rustfmt
              rustPackages.clippy
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

