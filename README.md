# AI for Ecommerce Workshop Site

Static setup guide, downloadable kits, and facilitator materials for the AI for Ecommerce x Amazon Sellers workshop.

## Live Site

- Current public URL: https://ai-ecommerce-workshop.vercel.app
- Vercel project: `ai-for-ecommerce-workshop`
- Deploy command: `vercel --yes --prod`

## What This Repo Contains

- `index.html` - the public workshop setup site.
- `install_autoresearch.sh` - one-line installer for the Autoresearch Lab.
- `autoresearch-starter-kit/` - source for the MacBook-first autoresearch starter kit.
- `autoresearch-starter-kit.zip` - downloadable copy used by the website installer.
- `AUTORESEARCH-LAB-WALKTHROUGH.md` - presenter guide for the Autoresearch Lab.
- `EVERLEARN-DEMO-WALKTHROUGH.md` - presenter guide for Everlearn.
- `everlearn-workshop.zip` - downloadable Everlearn workshop package.
- `*.png` - framework diagrams and workshop images rendered on the setup site.

## Workshop Modules

| Module | Surface | Purpose |
|---|---|---|
| Setup guide | `index.html` | Account, tool, and prerequisite setup for attendees |
| Claude / Codex desktop setup | `index.html` | Desktop-app-first setup for Claude Desktop and Codex app, custom plugin marketplaces, MCP setup, and optional Ghostty CLI paths |
| SignalSweep | `index.html` | Research-engine install and smoke test |
| Autoresearch Lab | `autoresearch-starter-kit/`, `install_autoresearch.sh` | MacBook-local recursive improvement loop for response curves and demand forecasts |
| SkillForge | `index.html` | Turn repeated ecommerce workflows into reusable AI skills |
| Everlearn | `EVERLEARN-DEMO-WALKTHROUGH.md`, `everlearn-workshop.zip` | Local-first knowledge capture into an Obsidian-compatible vault |

## Autoresearch Lab

The Autoresearch Lab uses `miolini/autoresearch-macos` as the MacBook-first reference for the workflow shape, then replaces the LLM-training workload with fast ecommerce modeling tasks that run locally without a GPU.

Attendee install command:

```bash
curl -fsSL https://ai-ecommerce-workshop.vercel.app/install_autoresearch.sh | bash
```

After install:

```bash
cd ~/autoresearch-starter-kit
./scripts/check.sh
./scripts/setup-run.sh response-curves
```

Benchmark framing:

| Source | Baseline | Best / Current | Scope |
|---|---:|---:|---|
| Original CurveLab autoresearch | `0.341` | `0.122` | 384 experiments across 1,073 product families |
| Workshop response-curve starter | `0.472456` | `0.472456` | Small local sample CSV; baseline only |
| Workshop demand-forecast starter | `0.072079` | `0.072079` | Small local sample CSV; baseline only |

## Packaging Notes

When editing the starter kit source, rebuild the ZIP before deploying:

```bash
rm -f autoresearch-starter-kit.zip
zip -qr autoresearch-starter-kit.zip autoresearch-starter-kit
```

The standalone local HTML copy is kept outside this repo at:

```text
/Users/jackatlasov/Documents/Work/AI-Ecommerce-Workshop-Prereqs.html
```

Sync it after editing `index.html`:

```bash
cp index.html /Users/jackatlasov/Documents/Work/AI-Ecommerce-Workshop-Prereqs.html
```

## Verification

Before publishing:

```bash
git diff --check
curl -fsSL https://ai-ecommerce-workshop.vercel.app/install_autoresearch.sh | bash -s -- --dir /tmp/autoresearch-live-check --force
/tmp/autoresearch-live-check/scripts/setup-run.sh response-curves live-check
```

The response-curve baseline should print `portfolio_wmape: 0.472456`.
