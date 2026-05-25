# Everlearn Workshop Demo Walkthrough

Facilitator guide for the AI for Ecommerce workshop on Wednesday, May 27, 2026.

## Segment Goal

Show attendees how to turn useful AI-session output into a durable local learning system they own.

The core message:

> Everlearn is not another chat window. It is a local-first learning engine that lets Claude Code, Codex, and related tools save reusable learnings, customer signals, research, decisions, workflows, and prompts into your own Markdown or Obsidian vault.

For the workshop, position it through ecommerce examples. Make clear that the system is general: the ecommerce profile is just tonight's starting template.

## What To Emphasize

- AI gets much more valuable when good outputs survive the chat session.
- Most sellers lose useful insights inside transcripts, screenshots, Slack threads, docs, and one-off prompts.
- Everlearn creates a repeatable "capture habit": when the agent learns something useful, it writes a clean note into a vault.
- The vault is local Markdown. Attendees can open it in Obsidian, search it, move it, sync it, or version it.
- The workflow is explicit by default. It does not scrape private chats, customer data, browser history, or the whole computer.
- SignalSweep can be nested inside Everlearn for research capture, without changing SignalSweep's normal save location.

Avoid describing Everlearn as "AI memory" without qualification. Say "local knowledge capture" or "a second-brain workflow for AI agents."

## Demo Timing

Use this as a 15-20 minute segment.

| Time | Step | Outcome |
|---:|---|---|
| 2 min | Frame the problem | Attendees understand why capture matters |
| 3 min | Show install and verify | They see the system is local and concrete |
| 4 min | Capture one customer signal | A note appears in Obsidian |
| 5 min | Run nested SignalSweep capture | Research lands in the Everlearn vault |
| 3 min | Show review and reuse | The system becomes a weekly operating habit |
| 3 min | Attendee prompt practice | They leave with exact prompts to reuse |

If the workshop is running behind, skip the install walkthrough and start from a preinstalled machine.

## Pre-Demo Checklist

Before the live session:

- Open the public setup page: https://ai-ecommerce-workshop.vercel.app
- Download `everlearn-workshop.zip` from the Everlearn tab.
- Confirm the local command works:

```bash
~/.everlearn/bin/everlearn verify
```

- Open Obsidian to `~/Everlearn Vault`.
- Keep Claude Code or Codex open with a fresh session.
- Keep Terminal open in a readable font size.
- Have one ecommerce demo topic ready:

```text
customer complaints about cold plunge accessories
```

Fallback topic:

```text
why shoppers abandon premium standing desk accessories
```

## Step 1: Introduce The Problem

Talk track:

> We are going to build a lot of useful AI output tonight: research, product ideas, customer objections, prompts, operating workflows, and decisions. The problem is that most of this disappears into chat history. Everlearn gives the AI a way to save the useful parts into your own local knowledge base.

Then connect it to ecommerce:

> For sellers, this means your customer research, competitor patterns, listing lessons, ad tests, and product ideas can compound instead of getting rediscovered every week.

Use this one-line definition:

> Everlearn is a local-first continual learning engine for AI agents.

## Step 2: Show What Gets Installed

Show the setup page's Everlearn tab, then explain the four pieces:

| Piece | Plain-English Explanation |
|---|---|
| `~/Everlearn Vault` | The folder of Markdown notes |
| Obsidian | The visual app for browsing the vault |
| Everlearn skill | Instructions Claude Code and Codex can follow |
| `everlearn` command | The local tool that writes notes and runs reviews |
| `/everlearn` | Claude Code and Codex shortcut for the same workflow where custom commands are exposed |

Talk track:

> This is intentionally simple. It is not a cloud account. It is a folder, a small command, and a skill file that tells the agent when and how to capture useful learning.

## Step 3: Install Or Verify

If installing live, use the fast GitHub installer:

```bash
curl -fsSL https://raw.githubusercontent.com/tripleyak/everlearn/v2026-05-27-workshop/scripts/install.sh | bash -s -- --ref v2026-05-27-workshop --profile ecommerce
```

If using the ZIP fallback, use:

```bash
cd ~/Downloads
unzip -o everlearn-workshop.zip
cd everlearn
./scripts/setup.sh --profile ecommerce
~/.everlearn/bin/everlearn verify
```

If already installed, only run:

```bash
~/.everlearn/bin/everlearn verify
```

Say:

> Tonight we use the ecommerce profile because the examples are about customer signals, product research, ads, and marketplace learning. The underlying workflow is general. You can use it later for operations, research, coding, or personal learning.

Expected result:

- Terminal says setup or verification completed.
- `~/Everlearn Vault` exists.
- The vault has folders like `10 Learnings`, `20 Decisions`, `30 Research`, `40 Workflows`, and `60 Reviews`.

## Step 4: Open The Vault In Obsidian

Show the concrete result before using the agent.

Steps:

1. Open Obsidian.
2. Click "Open folder as vault."
3. Select `~/Everlearn Vault`.
4. Show the folder list.

Talk track:

> This is the trust boundary. If it is not in this folder, I do not count it as captured. The agent can say it remembered something, but the proof is the Markdown note in the vault.

## Step 5: Capture A Customer Signal

Use Claude Code or Codex with a simple natural-language prompt.

Prompt:

```text
Use Everlearn to save this as a customer signal:

Customers keep asking whether the starter bundle includes replacement filters. That probably means the listing is not clear enough and the bundle page should answer maintenance questions before price comparison starts.
```

Expected agent behavior:

- It should recognize the Everlearn skill.
- It should create a `signal` or `research/customer signal` note.
- It should write into `~/Everlearn Vault`.

Then show the created note in Obsidian.

Talk track:

> Notice what changed. We did not ask the model for another answer. We asked it to preserve a learning in a reusable place. That is the operating habit.

If the agent does not invoke the skill cleanly, use the command fallback:

```bash
~/.everlearn/bin/everlearn capture \
  --type signal \
  --title "Starter bundle filter confusion" \
  "Customers keep asking whether the starter bundle includes replacement filters. The listing should answer maintenance questions before price comparison starts."
```

Claude Code and Codex shortcut:

```text
/everlearn signal Customers keep asking whether the starter bundle includes replacement filters.
```

## Step 6: Capture A Decision

Use a second prompt to show that Everlearn is not only for research.

Prompt:

```text
Use Everlearn to capture this decision:

For the next listing test, we will add a maintenance FAQ above the comparison chart before changing price. Rationale: the customer signal suggests uncertainty, not price resistance.
```

Show the note under `20 Decisions`.

Talk track:

> This is where AI starts becoming operational. The same system can capture why we made a decision, not just what the decision was.

## Step 7: Nested SignalSweep Research Capture

Explain first:

> SignalSweep is for finding market signals across many sources. Everlearn can run SignalSweep as part of the capture workflow, so the raw research and the synthesized note both land in the Everlearn vault.

Important clarification:

> This does not change SignalSweep's normal save directory. Everlearn scopes the save location for this one run only.

Run:

```bash
~/.everlearn/bin/everlearn signalsweep \
  --topic "customer complaints about cold plunge accessories" \
  -- --quick
```

For a fast no-network fallback, use:

```bash
~/.everlearn/bin/everlearn signalsweep \
  --topic "customer complaints about cold plunge accessories" \
  -- --mock
```

Show:

- The Everlearn research note.
- The linked raw artifact under `30 Research/SignalSweep`.

Talk track:

> This is the bigger pattern: research agent runs, durable capture happens automatically, and next week the source material is still findable.

## Step 8: Run A Review

Run:

```bash
~/.everlearn/bin/everlearn review
```

Show the review note under `60 Reviews`.

Talk track:

> The weekly review is how the vault becomes a system. You are not just collecting notes. You are asking the agent to summarize what changed, what decisions were made, and what should be reused.

## Step 9: Give Attendees The Three Prompts

Have attendees paste these into Claude Code or Codex after setup.

Prompt 1:

```text
Use Everlearn to capture the most reusable learning from this session.
```

Claude Code and Codex shortcut:

```text
/everlearn learning The most reusable learning from this session was ...
```

Prompt 2:

```text
Use Everlearn to save this as a customer signal: [paste a real customer objection, review pattern, support question, or sales-call note].
```

Prompt 3:

```text
Use Everlearn and SignalSweep to research [your product or niche] customer complaints and save the research into my Everlearn vault.
```

Explain:

> You do not need to memorize commands. Start with plain English. The commands are there when you want a precise fallback.

## Step 10: Close With The Habit

End with:

> The goal is not to capture everything. The goal is to capture what should make future work better: customer signals, decisions, workflows, research, and prompts worth reusing.

Recommended after-workshop assignment:

1. Capture one customer signal from a real review or support message.
2. Capture one decision from the workshop.
3. Run one SignalSweep topic into Everlearn.
4. Open Obsidian and confirm all three notes exist.
5. Run `~/.everlearn/bin/everlearn review` at the end of the week.

## Troubleshooting Script

If someone is stuck, diagnose in this order:

1. Did they install from the latest public ZIP?
2. Does `~/.everlearn/bin/everlearn verify` pass?
3. Did they restart Claude Code or Codex after installing?
4. Did they open the correct Obsidian vault folder: `~/Everlearn Vault`?
5. Are they expecting notes in the old SignalSweep directory instead of Everlearn?

Useful commands:

```bash
~/.everlearn/bin/everlearn verify
ls "$HOME/Everlearn Vault"
find "$HOME/Everlearn Vault" -type f -name "*.md" | tail -20
```

## Demo Boundaries

Say these clearly:

- Do not capture API keys, passwords, cookies, payment data, or private customer data.
- Everlearn captures what you or your agent explicitly save.
- The vault is local Markdown, so attendees are responsible for their own sync, backup, and sharing policy.
- Ecommerce is tonight's profile, not the limit of the system.

## Best One-Sentence Description

Use this in the workshop:

> Everlearn gives your AI agent a local notebook, so the best lessons from your research, decisions, customer signals, and workflows compound instead of disappearing into chat history.
