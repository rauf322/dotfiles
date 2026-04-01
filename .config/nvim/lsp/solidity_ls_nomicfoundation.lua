return {
  cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
  filetypes = { "solidity" },
  single_file_support = true,
  root_markers = {
    "hardhat.config.js",
    "hardhat.config.ts",
    "foundry.toml",
    "remappings.txt",
    "truffle.js",
    "truffle-config.js",
    "ape-config.yaml",
    ".git",
  },
}
