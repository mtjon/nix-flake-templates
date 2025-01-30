{
outputs = { self }: rec {
  templates = {
    c = {
      path = ./c;
      description = "C template";
      welcomeText = ''
        # Templated C project

        This template provides the C language and LSP, and SOPS for secret
        management.

        See `README.md` for further information.
      '';
    };

    go = {
      path = ./go;
      description = "Go template";
      welcomeText = ''
        # Templated Go project

        This template provides the Go language and LSP, gomod2nix for
        converting your Go modules to Nix, and SOPS for secret management.

        See `README.md` for further information.
      '';
    };

    go = {
      path = ./go;
      description = "Go template";
      welcomeText = ''
        # Templated Go project

        This template provides the Go language and LSP, gomod2nix for
        converting your Go modules to Nix, and SOPS for secret management.
    rust = { 
      path = ./rust;
      description = "Rust template";
      welcomeText = ''
        # Templated Rust project

        This template provides the Rust language and LSP, naersk for converting
        your Cargo modules to Nix, and SOPS for secret management.

        See `README.md` for further information.
      '';
    };

    zig = {
      path = ./zig;
      description = "Zig template";
      welcomeText = ''
        # Templated Zig project

        This template provides the Zig language and LSP and SOPS, Age, and yq
        for secret management.

        See `README.md` for further information.
      '';
    };

    default = templates.go;
  };
};
}
