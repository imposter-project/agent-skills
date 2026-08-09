# Evals for the `mocks` skill

`evals.json` follows the [Agent Skills eval format](https://agentskills.io/skill-creation/evaluating-skills): a `skill_name` plus a list of test cases, each with a realistic `prompt`, an `expected_output` description, optional input `files`, and objective `assertions`.

## How to run them

Run each case twice - once with the skill loaded, once without - in a fresh context each time, then grade the assertions against the outputs. The without-skill run is the baseline: an assertion that passes in both configurations is not measuring anything the skill adds, and should be replaced.

Input files listed under `files` are relative to the skill directory and should be copied into the run's working directory before the prompt is given.

## What these cases target

Each case is built around something an agent is unlikely to get right without the skill:

| Case | What it discriminates on |
|------|--------------------------|
| `quick-start-rest-mock` | The `-config.yaml` / `-config.json` naming convention and the basic `up` / call / `down` loop |
| `scaffold-from-openapi-spec` | Reaching for `imposter scaffold` instead of hand-writing REST resources |
| `engine-without-docker-or-java` | The native engine, and that it is v5-only |
| `groovy-script-on-v5` | Groovy is gone in v5 however you run it - the Docker image is not a workaround |
| `run-v5-under-docker` | Version-to-engine derivation, and that an explicit engine type wins |
| `github-actions-mock-in-ci` | The official actions, and stopping mocks with `if: always()` |
| `config-not-discovered` | Diagnosing a real failure mode rather than inventing a CLI flag |
| `wait-for-readiness-before-tests` | `/system/status`, the bundled wait script, and `-d healthy` over a fixed sleep |
| `request-matching-by-query-and-header` | `resources`, `queryParams` and `requestHeaders` matching syntax |

The set deliberately mixes casual and precise phrasings, and includes troubleshooting prompts where the user's own diagnosis is wrong (cases 4, 5 and 7), since those are where a skill either corrects the premise or follows the user down the wrong path.

## Changing the skill

When `SKILL.md` or a reference changes in a way that alters any of the behaviours above, update the matching assertions in the same commit.
