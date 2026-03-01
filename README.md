# Imposter Mock Engine - Agent Skills

[Agent Skills](https://agentskills.io) for working with the [Imposter](https://docs.imposter.sh) mock engine. These skills teach AI coding agents how to create, configure, and manage API mocks using Imposter.

## Available skills

| Skill | Description |
|-------|-------------|
| [imposter](./imposter/) | Mock APIs with the Imposter mock engine - CLI usage, configuration, Docker, CI/CD, and test integration |

## Installation

### Claude Code

**Personal (all projects):**

```bash
# Clone the repository
git clone https://github.com/imposter-project/agent-skills.git

# Symlink the skill into your personal skills directory
mkdir -p ~/.claude/skills
ln -s "$(pwd)/agent-skills/imposter" ~/.claude/skills/imposter
```

**Project-level (single project):**

```bash
# From your project root
mkdir -p .claude/skills
cp -r /path/to/agent-skills/imposter .claude/skills/imposter
```

Or add this repository as a git submodule:

```bash
git submodule add https://github.com/imposter-project/agent-skills.git .claude/agent-skills
ln -s ../agent-skills/imposter .claude/skills/imposter
```

### GitHub Copilot (VS Code)

GitHub Copilot in VS Code discovers skills from `~/.copilot/skills/` and `~/.claude/skills/`:

```bash
# Option 1: Copilot-specific directory
mkdir -p ~/.copilot/skills
ln -s /path/to/agent-skills/imposter ~/.copilot/skills/imposter

# Option 2: Shared directory (works for both Claude Code and Copilot)
mkdir -p ~/.claude/skills
ln -s /path/to/agent-skills/imposter ~/.claude/skills/imposter
```

**Project-level:**

```bash
# From your project root
mkdir -p .github/skills
cp -r /path/to/agent-skills/imposter .github/skills/imposter
```

### Verify installation

In Claude Code, ask:

```
What skills are available?
```

You should see the `imposter` skill listed. You can also invoke it directly:

```
/imposter
```

## What's included

```
imposter/
├── SKILL.md                          # Main skill instructions
├── scripts/
│   ├── healthcheck.sh                # Check if mock server is healthy
│   └── wait-for-mock.sh              # Wait for mock server readiness
└── references/
    ├── ci-cd-github-actions.md       # GitHub Actions integration
    ├── docker.md                     # Docker deployment
    ├── imposter-js.md                # JavaScript/Node.js test bindings
    ├── jvm-embedding.md              # JVM test embedding (JUnit/TestNG)
    └── configuration.md              # Detailed configuration reference
```

## Covered scenarios

- **Local development** - Install the CLI, start/stop mocks, scaffold configuration from OpenAPI specs, health checking
- **CI/CD pipelines** - GitHub Actions for setup, starting mocks, running tests, and cleanup
- **Docker** - Running Imposter containers directly, building self-contained images
- **JavaScript tests** - Embedding mocks in Jest/Mocha tests with imposter-js
- **JVM tests** - Embedding mocks in JUnit/TestNG tests with the embedded engine

## Links

- [Imposter documentation](https://docs.imposter.sh)
- [Imposter CLI](https://github.com/imposter-project/imposter-cli)
- [Imposter GitHub Actions](https://github.com/imposter-project/imposter-github-action)
- [Agent Skills specification](https://agentskills.io/specification)
- [Configuration examples](https://github.com/imposter-project/examples)

## License

MIT
