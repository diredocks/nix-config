{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    codex
    claude-code
    opencode
  ];
}
