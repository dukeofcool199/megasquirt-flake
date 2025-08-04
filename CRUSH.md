# CRUSH Documentation

## Setup
- Run "nix develop" to enter the development environment.
- Use "nix build" to compile the project and "nix flake check" for dependency validations.

## Build
- Execute "nix build" to build the project.

## Test
- Run "nix test" to run the complete test suite.
- For a single test, use "nix run .#tests -- <test-case>".

## Lint
- Run "nix fmt" to format Nix files; other files follow the project's lint rules as specified in the README.

## Code Style Guidelines
- Imports should be at the top, sorted alphabetically.
- Use 2-space indentation consistently.
- Explicit type annotations are encouraged for clarity.
- Naming conventions: camelCase for variables/functions, PascalCase for types and modules.
- Errors must be handled explicitly, checking for non-zero return codes.
- Code should be modular, clean, and well-documented.

## Additional Rules
- Check ".cursor/rules/" for Cursor-specific guidelines, if available.
- Refer to ".github/copilot-instructions.md" for Copilot rules.
- The .crush directory is automatically ignored (see .gitignore).

## Commands Summary
- Setup: nix develop
- Build: nix build
- Test: nix test or nix run .#tests -- <test-case>
- Lint: nix fmt

💘 Generated with Crush
