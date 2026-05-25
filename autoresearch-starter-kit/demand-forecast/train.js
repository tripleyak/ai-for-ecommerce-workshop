import { run } from "./prepare.js";

function fitSeries(train) {
  const window = train.slice(-4);
  const averageUnits = window.reduce((sum, point) => sum + point.units, 0) / Math.max(window.length, 1);

  return () => Math.max(0, averageUnits);
}

run(fitSeries);
