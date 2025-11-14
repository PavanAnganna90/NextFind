# Contributing to NextFind

Thanks for considering a contribution! This project aims to be a reference-quality e-commerce platform, so every change should improve reliability, observability, or developer experience.

## Code of Conduct
By participating you agree to the [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). Report unacceptable behavior to the maintainer.

## Quick Start
1. **Fork & Clone**
   ```bash
   git clone https://github.com/<you>/NextFind.git
   cd NextFind
   pnpm install
   ```
2. **Create a branch**
   ```bash
   git checkout -b feat/amazing-idea
   ```
3. **Make changes**
   - Keep files under 500 LOC.
   - Follow PEP8 for Python utilities and Google-style docstrings.
   - Use Relative imports inside packages.
4. **Tests & lint**
   ```bash
   pnpm lint
   pnpm test
   ```
5. **Commit**
   - Use Conventional Commits (`feat: add wishlist badge`, `fix: handle redis reconnect`).
6. **Open a PR**
   - Fill out `PULL_REQUEST_TEMPLATE.md`.
   - Link related issues (e.g., `Closes #42`).

## Testing Requirements
- Add pytest unit tests for Python changes (`tests/` mirrors project structure).
- For frontend, add unit or component tests (Vitest/Playwright).
- Provide at least: one happy-path, one edge case, one failure case.

## Documentation
- Update `README.md`, `docs/architecture.md`, or `docs/operations.md` when behavior, flags, or deployment steps change.
- For infra work, include inline `# Reason:` comments explaining non-obvious choices.

## Reporting Issues
Use the GitHub issue templates:
- **Bug report**: include environment, reproduction steps, expected vs actual behavior, logs.
- **Feature request**: describe the problem, proposed solution, and alternatives.

## Release Flow
- Merge to `main` only via PR.
- Maintainer cuts releases by tagging (`git tag v1.0.0 && git push origin --tags`) and updating `CHANGELOG.md`.

Thank you for helping make NextFind a professional, open-source showcase!

