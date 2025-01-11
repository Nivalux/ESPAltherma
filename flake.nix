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
        (pkgs.buildFHSUserEnv {
          name = "platformio-fhs";
          targetPkgs =
            pkgs: with pkgs; [
              python312
              (vscode-with-extensions.override {
                vscode = vscodium;
                vscodeExtensions =
                  with vscode-extensions;
                  [
                    ms-python.python
                    ms-vscode.cpptools
                  ]
                  ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
                    {
                      name = "platformio-ide";
                      publisher = "platformio";
                      version = "3.3.3";
                      sha256 = "sha256-cVYnFhdeClHhuVaTWRU2IDIA1mFq1iLveZUIhEhMSck=";
                    }
                  ];
              })
            ];
        }).env;
    };
}
