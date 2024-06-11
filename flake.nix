{
outputs = { self }: rec {
  templates = {
    go = {
      path = ./go;
      description = "";
      welcomeText = ''
        # Templated Go project

        This project provides the Go language and LSP, gomod2nix for converting
        your Go modules to Nix, and SOPS for secret management.

        See `README.md` for further information.
      '';
    };

    default = templates.go;
  };
};
}
