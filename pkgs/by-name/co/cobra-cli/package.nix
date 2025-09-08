{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  go,
}:

buildGoModule rec {
  pname = "cobra-cli";
  version = "v1.3.0-21-g1d43487";

  src = fetchFromGitHub {
    owner = "spf13";
    repo = "cobra-cli";
    rev = "1d43487";
    sha256 = "sha256-8lJUn0LDTKwEFrV8GE77y779Ge0BAXJClDswcma8KVw=";
  };

  vendorHash = "sha256-hYi1A9ZXMJX353EVAVs/ampVSadU/4NSkrnRT/zahB8=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  allowGoReference = true;

  postPatch = ''
    substituteInPlace "cmd/add_test.go" \
      --replace "TestGoldenAddCmd" "SkipGoldenAddCmd"
    substituteInPlace "cmd/init_test.go" \
      --replace "TestGoldenInitCmd" "SkipGoldenInitCmd"
  '';

  postFixup = ''
    wrapProgram "$out/bin/cobra-cli" \
      --prefix PATH : ${go}/bin
  '';

  postInstall = ''
    installShellCompletion --cmd cobra-cli \
      --bash <($out/bin/cobra-cli completion bash) \
      --fish <($out/bin/cobra-cli completion fish) \
      --zsh <($out/bin/cobra-cli completion zsh) \
  '';

  meta = {
    description = "Cobra CLI tool to generate applications and commands";
    mainProgram = "cobra-cli";
    homepage = "https://github.com/spf13/cobra-cli/";
    changelog = "https://github.com/spf13/cobra-cli/releases/tag/${version}";
    license = lib.licenses.afl20;
    maintainers = [ lib.maintainers.ivankovnatsky ];
  };
}
