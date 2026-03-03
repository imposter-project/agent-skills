# Imposter Mock Engine - Agent Skills

[Agent Skills](https://agentskills.io) for working with the [Imposter](https://docs.imposter.sh) mock engine. These skills teach AI coding agents how to create, configure, and manage API mocks using Imposter.

Also available as a [Claude Code plugin](#claude-code-plugin-recommended).

## Available skills

| Skill | Description |
|-------|-------------|
| [mocks](./skills/mocks/) | Mock APIs with the Imposter mock engine - CLI usage, configuration, Docker, CI/CD, and test integration |

## Installation

### Claude Code plugin (recommended)

Install as a plugin for automatic discovery, version control, and easy updates.

**From the marketplace:**

```bash
# Add the marketplace (one-time setup)
/plugin marketplace add imposter-project/agent-skills

# Install the plugin
/plugin install imposter@imposter-agent-skills
```

**Team/organization setup** — add to your project's `.claude/settings.json` so team members get prompted to install automatically:

```json
{
  "extraKnownMarketplaces": {
    "imposter-agent-skills": {
      "source": {
        "source": "github",
        "repo": "imposter-project/agent-skills"
      }
    }
  }
}
```

Team members can then install with:

```bash
/plugin install imposter@imposter-agent-skills
```

**Local development / testing:**

```bash
git clone https://github.com/imposter-project/agent-skills.git
claude plugin install --plugin-dir ./agent-skills
```

After installation, invoke the skill with:

```
/imposter:mocks
```

### Manual installation (Claude Code)

If you prefer manual setup without the plugin system:

**Personal (all projects):**

```bash
# Clone the repository
git clone https://github.com/imposter-project/agent-skills.git

# Symlink the skill into your personal skills directory
mkdir -p ~/.claude/skills
ln -s "$(pwd)/agent-skills/skills/mocks" ~/.claude/skills/mocks
```

**Project-level (single project):**

```bash
# From your project root
mkdir -p .claude/skills
cp -r /path/to/agent-skills/skills/mocks .claude/skills/mocks
```

Or add this repository as a git submodule:

```bash
git submodule add https://github.com/imposter-project/agent-skills.git .claude/agent-skills
ln -s ../agent-skills/skills/mocks .claude/skills/mocks
```

### GitHub Copilot (VS Code)

GitHub Copilot in VS Code discovers skills from `~/.copilot/skills/` and `~/.claude/skills/`:

```bash
# Option 1: Copilot-specific directory
mkdir -p ~/.copilot/skills
ln -s /path/to/agent-skills/skills/mocks ~/.copilot/skills/mocks

# Option 2: Shared directory (works for both Claude Code and Copilot)
mkdir -p ~/.claude/skills
ln -s /path/to/agent-skills/skills/mocks ~/.claude/skills/mocks
```

**Project-level:**

```bash
# From your project root
mkdir -p .github/skills
cp -r /path/to/agent-skills/skills/mocks .github/skills/mocks
```

### Verify installation

In Claude Code, ask:

```
What skills are available?
```

You should see the `mocks` skill listed. If installed as a plugin, invoke it with:

```
/imposter:mocks
```

## What's included

```
skills/
  mocks/
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
