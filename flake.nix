{
outputs = { self }: rec {
  templates = {
    rust = { 
      path = ./rust;
      description = "Rust template";
      welcomeText = ''
        # Templated Rust project

        This template provides the Rust language and LSP, cargo2nix for converting
        your Cargo modules to Nix, and SOPS for secret management.

        See `README.md` for further information.
      '';
    };

    go = {
      path = ./go;
      description = "Go template";
      welcomeText = ''
        # Templated Go project

        This template provides the Go language and LSP, gomod2nix for converting
        your Go modules to Nix, and SOPS for secret management.

        See `README.md` for further information.
      '';
    };

    default = templates.go;
  };
};
}
