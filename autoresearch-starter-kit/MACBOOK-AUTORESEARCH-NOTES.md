# MacBook Autoresearch Notes

This kit uses `miolini/autoresearch-macos` as the MacBook-first reference for the workflow shape, not as the live workshop workload.

## What We Borrow

- A small repo with one fixed harness and one editable model file.
- `program.md` as the agent's operating instructions.
- A dedicated `autoresearch/<run>` Git branch for experiments.
- A tab-separated `results.tsv` log.
- A fixed metric that the agent is not allowed to modify.
- A keep/discard loop based on measured improvement.

## What We Replace

The Mac fork runs a small LLM training workload with Python, `uv`, PyTorch, MPS/Metal support, and a five-minute training budget. That is useful as the original pattern, but it is too heavy and too indirect for an ecommerce seller workshop.

This kit replaces that workload with two fast local business modeling tracks:

- `response-curves` - spend-to-sales curve fitting for ProfitCurve-style modeling.
- `demand-forecast` - demand planning forecasts for SKU or product-family history.

Both tracks run with Node.js and local CSV files. No GPU is required.

## Workshop Rule

Teach the autoresearch pattern with ecommerce metrics first. Use the original Mac fork only as the reference implementation for attendees who want to study the LLM-training version later.
