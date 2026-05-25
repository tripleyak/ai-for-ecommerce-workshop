# Response Curve Autoresearch Program

Goal: improve holdout WMAPE for spend-to-sales response curves.

This is the ProfitCurve-style track. Each product family has historical spend and sales data. The editable model should predict sales from spend.

This track follows the MacBook autoresearch pattern: fixed harness, one editable model file, one metric, a Git branch for the run, and a `results.tsv` log.

## Files

- `prepare.js` - fixed evaluation harness. Do not edit.
- `train.js` - editable model and fitting logic. This is the only file the agent edits.
- `data/sample.csv` - small workshop-safe sample data.
- `results.tsv` - experiment log.
- `../scripts/run-experiment.sh` - runs the track and appends the metric.

## Metric

The script prints:

```text
portfolio_wmape: 0.123456
families_evaluated: 3
```

Lower `portfolio_wmape` is better.

## Allowed Ideas

- Model types: linear, log, quadratic, saturation, piecewise.
- Weighting: recency weighting, inverse-sales weighting, spend weighting.
- Preprocessing: weekly aggregation, outlier removal, spend buckets.
- Selection: pick the best model by training WMAPE or validation split.
- Ensembles: blend top models when they are close.

## Rules

- Only edit `train.js`.
- Do not edit `prepare.js`.
- Do not edit `data/sample.csv`.
- Do not install packages or call external APIs.
- Keep changes small and explainable.
- Log every experiment in `results.tsv`.
- Keep an experiment only if holdout WMAPE improves.

## Loop

From the starter kit root:

```bash
./scripts/setup-run.sh response-curves
```

For each attempted idea:

```bash
git add response-curves/train.js
git commit -m "try response curve idea"
./scripts/run-experiment.sh response-curves pending "short description"
```
