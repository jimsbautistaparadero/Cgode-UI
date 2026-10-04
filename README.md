# Vape V4

This repository contains the Vape V4 source maintained under the `Vape-V4-ChatGPT` repository.

Repository: https://github.com/jimsbautistaparadero/Vape-V4-ChatGPT

## Purpose

This is a repository migration and maintenance copy of the existing project. The goal of this repository is to keep the source, loader, build configuration, and documentation internally consistent with this repository without changing the project's existing runtime behavior.

## Project layout

- `NewMainScript.lua` - public entry script.
- `loadstring` - example entry-point loader for the repository.
- `src/` - source modules, GUI code, libraries, and game-specific modules.
- `.github/workflows/` - repository build automation and bundler configuration.
- `README/` - documentation image assets.

## Entry point

The repository entry point is:

```text
NewMainScript.lua
```

The `loadstring` file points to this repository's `main` branch so the entry point no longer depends on the original source repository. Runtime compiled resources referenced by the project remain separate dependencies where the existing architecture requires them.

## Maintenance scope

This migration does not intentionally add features, redesign the interface, or change gameplay behavior. Changes are limited to repository consistency and restoring the existing project structure.

Use the project only where its use is authorized and permitted by the applicable platform rules.
