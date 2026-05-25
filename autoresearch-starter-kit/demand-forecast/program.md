# Demand Forecast Autoresearch Program

Goal: improve holdout WMAPE for demand forecasting.

This track uses units sold, price, ad spend, and market signal history. The editable model should predict future demand.

This track follows the MacBook autoresearch pattern: fixed harness, one editable model file, one metric, a Git branch for the run, and a `results.tsv` log.

## Files

- `prepare.js` - fixed evaluation harness. Do not edit.
- `train.js` - editable forecasting logic. This is the only file the agent edits.
- `data/sample.csv` - small workshop-safe sample data.
- `results.tsv` - experiment log.
- `../scripts/run-experiment.sh` - runs the track and appends the metric.

## Metric

The script prints:

```text
portfolio_wmape: 0.123456
series_evaluated: 3
```

Lower `portfolio_wmape` is better.

## Allowed Ideas

- Moving averages and exponential smoothing.
- Trend models.
- Price and promo adjustments.
- Ad-spend or market-signal regressions.
- Seasonality features.
- Ensembles of simple forecasts.

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
./scripts/setup-run.sh demand-forecast
```

For each attempted idea:

```bash
git add demand-forecast/train.js
git commit -m "try demand forecast idea"
./scripts/run-experiment.sh demand-forecast pending "short description"
```
