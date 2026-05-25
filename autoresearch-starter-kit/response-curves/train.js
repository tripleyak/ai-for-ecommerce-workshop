import { run } from "./prepare.js";

function fitFamily(train) {
  const n = train.length;
  const meanSales = train.reduce((sum, point) => sum + point.sales, 0) / Math.max(n, 1);
  const meanSpend = train.reduce((sum, point) => sum + point.spend, 0) / Math.max(n, 1);

  let numerator = 0;
  let denominator = 0;
  for (const point of train) {
    numerator += (point.spend - meanSpend) * (point.sales - meanSales);
    denominator += (point.spend - meanSpend) ** 2;
  }

  const slope = denominator > 0 ? numerator / denominator : 0;
  const intercept = meanSales - slope * meanSpend;

  return (spend) => Math.max(0, intercept + slope * spend);
}

run(fitFamily);
