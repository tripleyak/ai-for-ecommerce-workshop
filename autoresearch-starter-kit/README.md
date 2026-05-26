# Autoresearch Starter Kit

This is a local workshop starter kit for building a Karpathy-inspired autoresearch loop on a MacBook.

It uses `miolini/autoresearch-macos` as the MacBook-first reference for the workflow shape, then swaps the LLM-training workload for fast ecommerce modeling tasks that run locally without a GPU.

It has two tracks:

1. `response-curves` - recreate the core idea behind ProfitCurve: fit spend-to-sales response curves and improve holdout WMAPE.
2. `demand-forecast` - create a demand planning forecast loop and improve holdout WMAPE.

The pattern is the same in both tracks:

- Root `program.md` explains the autoresearch workflow.
- Track `program.md` files explain the research task.
- `prepare.js` is the fixed evaluation harness. Do not edit it.
- `train.js` is the editable file. The AI agent modifies this file.
- `results.tsv` logs every experiment.
- The metric is holdout WMAPE. Lower is better.

## Quick Start

```bash
curl -fsSL https://ai-ecommerce-workshop.vercel.app/install_autoresearch.sh | bash
cd ~/autoresearch-starter-kit
```

The installer downloads the starter kit, runs both smoke tests, and creates a baseline Git commit inside the starter folder.

## Manual Smoke Tests

```bash
./scripts/check.sh
```

## Start A Run

```bash
./scripts/setup-run.sh response-curves
```

or:

```bash
./scripts/setup-run.sh demand-forecast
```

Each command creates a local `autoresearch/<track>-<timestamp>` branch and records a baseline result.

Only run destructive Git commands inside this starter folder.

## Agent Prompt

Use this in Codex or Claude Code from the starter kit root:

```text
Read program.md and the selected track program.md. Start or continue an autoresearch loop.

Rules:
- Only edit train.js.
- Do not edit prepare.js or data files.
- After each idea, commit the attempted train.js change.
- Run ./scripts/run-experiment.sh response-curves pending "short description"
  or ./scripts/run-experiment.sh demand-forecast pending "short description".
- Keep the change only if holdout WMAPE improves.
- If it gets worse, discard the train.js change and try a new idea.
- Prefer simple changes that improve the metric.
```

## Workshop Safety

Use the sample data first. If you bring your own data, remove account IDs, customer data, order IDs, credentials, and anything you would not show on a projector.
