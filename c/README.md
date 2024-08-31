# Go template

Provides a C project template with some additional auxiliary tools described
below. To use, first ensure you have Nix with Flake support installed, then
simply run:

```bash
nix flake -t github:mtjon/nix-flake-templates#c
nix develop
```

# Auxiliary tooling

## SOPS

Included [SOPS](https://github.com/getsops/sops) for checking in secrets, run
e.g. `sops secrets/local.yaml` to get started. See the [usage
documentation](https://github.com/getsops/sops?tab=readme-ov-file#2usage) for
further guidance.


## Local scripts

If you have local scripts that you want to package, see the comments in
`flake.nix` for an example on how to add them.

