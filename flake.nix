{
  description = "Heizung Pico W";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };
  outputs =
    {
      self,
      ...
    }@inputs:
    with inputs;
    let
      system = "x86_64-linux";
    in
    {
      devShell.${system} =
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        pkgs.mkShell {
          buildInputs = [ pkgs.platformio ];
          shellHook = ''
            export PLATFORMIO_CORE_DIR=$PWD/.platformio
          '';
        };
    };
}
