import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { performance } from "node:perf_hooks";

const TRACK_DIR = path.dirname(fileURLToPath(import.meta.url));
const DATA_PATH = path.join(TRACK_DIR, "data", "sample.csv");
const HOLDOUT_PCT = 0.25;

export function parseCsv(text) {
  const lines = text.trim().split(/\r?\n/);
  const headers = lines.shift().split(",");
  return lines.map((line) => {
    const values = line.split(",");
    return Object.fromEntries(headers.map((header, index) => [header, values[index]]));
  });
}

export function loadSeries() {
  const rows = parseCsv(fs.readFileSync(DATA_PATH, "utf8"));
  const grouped = new Map();

  for (const row of rows) {
    const series = row.series;
    if (!grouped.has(series)) grouped.set(series, []);
    grouped.get(series).push({
      series,
      date: row.date,
      units: Number(row.units),
      price: Number(row.price),
      ad_spend: Number(row.ad_spend),
      market_signal: Number(row.market_signal),
      promo: Number(row.promo),
    });
  }

  const seriesList = [];
  for (const [series, points] of grouped) {
    const sorted = points.sort((a, b) => a.date.localeCompare(b.date));
    const splitIndex = Math.max(2, Math.round(sorted.length * (1 - HOLDOUT_PCT)));
    seriesList.push({
      series,
      train: sorted.slice(0, splitIndex),
      holdout: sorted.slice(splitIndex),
      all: sorted,
    });
  }
  return seriesList;
}

export function run(fitSeries) {
  const started = performance.now();
  const seriesList = loadSeries();
  let weightedError = 0;
  let weightedActual = 0;
  let failed = 0;

  for (const series of seriesList) {
    try {
      const predict = fitSeries(series.train, { series: series.series, all: series.all });
      for (const point of series.holdout) {
        const predicted = predict(point);
        if (!Number.isFinite(predicted)) throw new Error("non-finite prediction");
        weightedError += Math.abs(predicted - point.units);
        weightedActual += Math.abs(point.units);
      }
    } catch {
      failed++;
    }
  }

  const portfolioWmape = weightedActual > 0 ? weightedError / weightedActual : Infinity;
  const elapsed = (performance.now() - started) / 1000;

  console.log("---");
  console.log(`portfolio_wmape:    ${portfolioWmape.toFixed(6)}`);
  console.log(`series_evaluated:   ${seriesList.length - failed}`);
  console.log(`series_total:       ${seriesList.length}`);
  console.log(`series_failed:      ${failed}`);
  console.log(`time_seconds:       ${elapsed.toFixed(2)}`);
}
