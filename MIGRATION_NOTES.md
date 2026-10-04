# Repository Migration Notes

Target repository: `https://github.com/jimsbautistaparadero/Vape-V4-ChatGPT`

## What was changed

- Repository-facing documentation now identifies `Vape-V4-ChatGPT` as the project repository.
- The public `loadstring` entry point now loads `NewMainScript.lua` from this repository.
- Existing source paths and project structure are preserved.
- Existing compiled-runtime dependency references remain pointed at the compiled distribution they already use.
- No new gameplay features or UI redesigns were introduced.

## What was deliberately not changed

The project contains a source tree and a separate compiled distribution. Replacing every compiled-distribution URL with this repository would make the loader request files that are not present here and would therefore break the existing runtime. Those URLs remain unchanged intentionally.

## Verification checklist

- Repository name and documentation URLs use `Vape-V4-ChatGPT`.
- `loadstring` targets the new repository entry point.
- `NewMainScript.lua` remains the entry script.
- `src/` remains the source tree.
- Build configuration remains compatible with the existing bundler workflow.
