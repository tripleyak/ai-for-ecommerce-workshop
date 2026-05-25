# AI for Ecommerce Workshop: Autoresearch Lab Walkthrough

Workshop: AI for Ecommerce x Amazon Sellers
Date: Wednesday, May 27, 2026
Audience: Amazon and ecommerce sellers, not developers
Recommended slot: 25-35 minutes, after SignalSweep and before SkillForge

## Goal

Attendees should leave with a working local autoresearch starter kit on their MacBooks. The examples are:

1. Response curves - recreate the core ProfitCurve pattern by improving spend-to-sales curve fitting.
2. Demand forecasting - build a self-improving forecast loop for future unit demand.

Seller-facing phrase:

> We are not just showing you a finished tool. We are showing you the pattern for building your own tool that keeps testing better versions of itself against a fixed scorecard.

## Source Evidence Checked

- `tripleyak/marketplace-investment-system`, branch `autoresearch/mar13`, resolves to `05d92441b7587a85805e99b1b7f3f5fe00c8de99`.
- Commit `12b7d1ccbd3d60fc0002a1cca8d0f4a5ecc546b7` is the clean modeling checkpoint: `experiment: equal 1/3 three-way blend`.
- `autoresearch/train.ts` has no diff between `12b7d1c` and the branch head.
- Local CurveLab playbook says the response-curve loop reached WMAPE `0.341 -> 0.122` across 384 experiments on 1,073 product families.
- The workshop starter kit now runs locally with Node and no package install.
- `miolini/autoresearch-macos` is the MacBook-first reference for the workflow shape: `program.md`, fixed harness, editable train file, run branch, and results log.

## Presenter Quick Checklist

Before the live segment:

- Open the workshop setup page on the Autoresearch Lab tab.
- Keep `install_autoresearch.sh` and `autoresearch-starter-kit.zip` in the site folder.
- Keep a terminal ready in a clean install of `~/autoresearch-starter-kit`.
- Run `./scripts/check.sh` once before presenting.
- Run `./scripts/setup-run.sh response-curves demo` in a disposable copy before presenting.
- Do not show private Seller Central, Amazon Ads, revenue dashboards, account IDs, customer data, order data, credentials, or internal caches.
- Use sample data first. Mention that real data can be swapped in later after sanitizing it.

## 1. Position It In Plain English

Use this framing:

> Autoresearch is a repeatable improvement loop. You give the AI one file it is allowed to change, one score it has to improve, and one test harness it is not allowed to touch. The AI tries an idea, runs the scorecard, keeps the change if it works, and throws it away if it does not.

Contrast:

| Normal AI workflow | Autoresearch workflow |
|---|---|
| Ask for an answer once | Run many measured experiments |
| Trust the explanation | Trust the fixed scorecard |
| Change prompts manually | Let the agent edit the model file |
| Decide by taste | Keep only metric-improving changes |

## 2. Show The System Shape

Use the starter kit files:

| File | Meaning | Presenter note |
|---|---|---|
| root `program.md` | MacBook-local autoresearch workflow | What the agent reads first |
| track `program.md` | Track-specific research instructions | What the agent reads second |
| `prepare.js` | Fixed harness | The test and metric stay honest |
| `train.js` | Editable file | The only file the agent changes |
| `data/sample.csv` | Workshop-safe data | Replace later with sanitized exports |
| `results.tsv` | Experiment log | Records what worked and failed |
| `scripts/setup-run.sh` | Run setup | Creates the local autoresearch branch |
| `scripts/run-experiment.sh` | Scorecard runner | Runs the metric and appends the result |

Say:

> The important design choice is separation. The AI can change the model, but it cannot move the goalposts.

## 3. Demo Arc And Timing

| Time | Segment | Purpose |
|---:|---|---|
| 0:00-3:00 | What autoresearch is | Explain the self-improvement loop |
| 3:00-6:00 | Starter kit anatomy | Show program, harness, editable file, data, log |
| 6:00-10:00 | Baseline response-curve run | Run `./scripts/setup-run.sh response-curves` |
| 10:00-14:00 | Baseline demand-forecast run | Run `./scripts/check.sh` and show the demand output |
| 14:00-20:00 | Agent prompt | Ask Codex or Claude Code to improve one track |
| 20:00-25:00 | Keep/discard rule | Show WMAPE and results.tsv |
| 25:00-30:00 | Bring-your-own-data path | Explain sanitized CSV replacement |
| 30:00-35:00 | Bridge to SkillForge | Package the repeated process |

If time is tight, run only the response-curve track live and explain the demand track from file structure.

## 4. Live Setup Commands

```bash
curl -fsSL https://ai-ecommerce-workshop.vercel.app/install_autoresearch.sh | bash
cd ~/autoresearch-starter-kit
./scripts/check.sh
# Pick one track for the live loop.
./scripts/setup-run.sh response-curves
```

The installer creates the baseline Git commit. `setup-run.sh` creates the track branch and records the baseline result. If someone wants a different folder or needs to replace an earlier copy, use:

```bash
curl -fsSL https://ai-ecommerce-workshop.vercel.app/install_autoresearch.sh | bash -s -- --dir ~/Documents/autoresearch-starter-kit
curl -fsSL https://ai-ecommerce-workshop.vercel.app/install_autoresearch.sh | bash -s -- --force
```

Say:

> Git is the undo system. Good experiments become commits. Bad experiments get discarded, but only inside this starter folder.

## 5. Agent Prompt

Run this from the starter kit root:

```text
Read program.md and response-curves/program.md. Start or continue an autoresearch loop.

Rules:
- Only edit train.js.
- Do not edit prepare.js or data files.
- After each idea, commit the attempted train.js change.
- Run ./scripts/run-experiment.sh response-curves pending "short description".
- Keep the change only if holdout WMAPE improves.
- If it gets worse, discard the train.js change and try a new idea.
- Prefer simple changes that improve the metric.
```

## 6. Concepts To Teach

Keep it concrete:

- Fixed metric: WMAPE, lower is better.
- Fixed harness: the agent cannot make itself look better by changing the test.
- Editable model: the agent has one clear place to experiment.
- Holdout split: recent data tests whether the model predicts the future.
- Results log: failed ideas are still useful because they stop you from repeating them.
- Simplicity criterion: a simple improvement beats a complex fragile one.

Avoid leading with:

- Complex calculus notation.
- Media mix modeling jargon before the system shape is clear.
- Claims of perfect attribution or perfect forecasting.
- Private portfolio results unless sanitized.

## 7. Track-Specific Framing

Response curves:

> This is the ProfitCurve pattern. We are asking: if spend changes, what sales do we expect, and how accurate is the fitted curve on recent holdout data?

Demand forecasting:

> This is the planning pattern. We are asking: given history, price, spend, promos, and market signals, can the agent discover a better forecast method than the baseline?

## 8. Bring-Your-Own-Data Path

Response curve CSV:

```csv
family,date,spend,sales
Dog Ramp,2026-04-06,1460,1905
```

Demand forecast CSV:

```csv
series,date,units,price,ad_spend,market_signal,promo
Dog Ramp,2026-04-06,157,79,1460,72,0
```

Sanitize first:

- Remove account IDs.
- Remove customer names and order IDs.
- Remove credentials, cookies, and API keys.
- Use generic product family names if presenting publicly.

## 9. Fallback Plan

If the live agent run is slow:

1. Run `./scripts/check.sh` manually.
2. Open `train.js` and explain what the baseline is doing.
3. Open root `program.md` and the track `program.md` to show the workflow and allowed improvement ideas.
4. Show a hypothetical `results.tsv` row.
5. Explain how they continue the loop after the workshop.

Example result row:

```text
commit	portfolio_wmape	time_seconds	status	description
abc1234	0.401220	0.1	keep	add log curve candidate with recency weighting
```

## 10. Bridge To SkillForge

Transition:

> Once you have a working autoresearch loop, you do not want to rebuild the setup every time. SkillForge can turn this into a reusable skill: create a new harness, define the editable file, run the metric, log experiments, and enforce the keep/discard rule.

Use this bridge prompt:

```text
Use SkillForge to create a reusable autoresearch setup skill for ecommerce operators.

The skill should help create:
- a program.md file
- a fixed prepare.js evaluation harness
- an editable train.js file
- sample CSV data
- a results.tsv log
- a safe Git workflow
- an agent prompt for continuous improvement
```

## Quality Bar

The module works if attendees leave knowing:

- How to separate the harness from the editable model.
- How to run a baseline score.
- How to ask an agent to improve only one file.
- How to use holdout WMAPE as the scorecard.
- How ProfitCurve and demand planning are examples of the same reusable autoresearch pattern.
