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

export function loadFamilies() {
  const rows = parseCsv(fs.readFileSync(DATA_PATH, "utf8"));
  const grouped = new Map();

  for (const row of rows) {
    const family = row.family;
    if (!grouped.has(family)) grouped.set(family, []);
    grouped.get(family).push({
      family,
      date: row.date,
      spend: Number(row.spend),
      sales: Number(row.sales),
    });
  }

  const families = [];
  for (const [family, points] of grouped) {
    const sorted = points.sort((a, b) => a.date.localeCompare(b.date));
    const splitIndex = Math.max(2, Math.round(sorted.length * (1 - HOLDOUT_PCT)));
    families.push({
      family,
      train: sorted.slice(0, splitIndex),
      holdout: sorted.slice(splitIndex),
      all: sorted,
    });
  }
  return families;
}

export function computeWMAPE(predict, points) {
  let error = 0;
  let total = 0;
  for (const point of points) {
    const predicted = predict(point.spend);
    if (!Number.isFinite(predicted)) return Infinity;
    error += Math.abs(predicted - point.sales);
    total += Math.abs(point.sales);
  }
  return total > 0 ? error / total : Infinity;
}

export function run(fitFamily) {
  const started = performance.now();
  const families = loadFamilies();
  let weightedError = 0;
  let weightedActual = 0;
  let failed = 0;

  for (const family of families) {
    try {
      const predict = fitFamily(family.train, { family: family.family, all: family.all });
      for (const point of family.holdout) {
        const predicted = predict(point.spend);
        if (!Number.isFinite(predicted)) throw new Error("non-finite prediction");
        weightedError += Math.abs(predicted - point.sales);
        weightedActual += Math.abs(point.sales);
      }
    } catch {
      failed++;
    }
  }

  const portfolioWmape = weightedActual > 0 ? weightedError / weightedActual : Infinity;
  const elapsed = (performance.now() - started) / 1000;

  console.log("---");
  console.log(`portfolio_wmape:    ${portfolioWmape.toFixed(6)}`);
  console.log(`families_evaluated: ${families.length - failed}`);
  console.log(`families_total:     ${families.length}`);
  console.log(`families_failed:    ${failed}`);
  console.log(`time_seconds:       ${elapsed.toFixed(2)}`);
}
