# MacBook Autoresearch Program

This starter kit adapts the Karpathy autoresearch pattern and the MacBook-first `miolini/autoresearch-macos` fork for ecommerce modeling.

The workshop workload is not nanochat training. It uses fast local response-curve and demand-forecast experiments so every attendee can run the loop on a MacBook without a GPU, PyTorch, or a large dataset download.

## Setup

1. Confirm you are inside the starter kit root.
2. Run the smoke tests:

```bash
./scripts/check.sh
```

3. Choose one track:

```bash
# Pick one track.
./scripts/setup-run.sh response-curves
# or:
./scripts/setup-run.sh demand-forecast
```

This creates an `autoresearch/<track>-<timestamp>` Git branch, resets that track's `results.tsv` header, records a baseline run, and keeps all changes inside this starter folder.

## In-Scope Files

- `response-curves/program.md` - response-curve research instructions.
- `demand-forecast/program.md` - demand-planning research instructions.
- `<track>/prepare.js` - fixed evaluation harness. Do not edit.
- `<track>/train.js` - editable model file. This is the only file the agent changes.
- `<track>/data/sample.csv` - workshop-safe data. Do not edit during the live loop.
- `<track>/results.tsv` - experiment log.
- `scripts/run-experiment.sh` - runs one experiment and appends the metric to `results.tsv`.

## Experiment Loop

1. Read this file and the selected track's `program.md`.
2. Run the baseline once if it has not already been recorded.
3. Change only the selected track's `train.js`.
4. Commit the attempted change.
5. Run:

```bash
./scripts/run-experiment.sh response-curves pending "short description"
```

or:

```bash
./scripts/run-experiment.sh demand-forecast pending "short description"
```

6. Compare `portfolio_wmape` to the previous best. Lower is better.
7. If it improves, mark the row `keep` and continue from that commit.
8. If it gets worse, mark the row `discard`, reset only the attempted `train.js` change, and try a new idea.

## MacBook Guardrails

- Do not install new packages.
- Do not use external APIs.
- Do not edit the fixed harness, data, or metric.
- Do not run destructive Git commands outside this starter kit.
- Keep experiments simple enough to explain to a seller in one sentence.
