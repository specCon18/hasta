tailwind:
    nix run .#tailwind
dev:
    cargo watch -x 'run'

format:
    pnpm prettier --write --ignore-unknown .

init-env:
    pnpm i
