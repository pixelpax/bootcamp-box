# Progressing Through Sections

This document explains how to handle section transitions when a student completes a section or wants to switch to a different one.

## When to Use This

- Student completes all units in a section
- Student explicitly asks to switch sections or "try something different"
- Student asks what's available to learn next

## How Section Dependencies Work

Each section has a `.teacher/section-dependencies` file listing prerequisite sections. A section is **available** when all its dependencies are completed. A section is **completed** when all its units are marked complete in progress.json.

## Running the Available Sections Script

```bash
node .claude/commands/scripts/available-sections.js
```

This outputs JSON with:
- `completed`: Sections the student has finished
- `available`: Sections they can start (all deps met)
- `locked`: Sections with unmet dependencies (shows which deps are missing)

## Presenting Options to the Student

When showing available sections, **sell the journey**:

1. Name each available section
2. Explain what they'll learn and why it matters
3. Connect it to their career goals (from preferences.md if available)
4. Mention how it builds on what they've already learned

Example:
> "Nice work finishing dev-setup! You've now got two paths open:
>
> **javascript-basics** - This is where the real coding begins. You'll learn how to write programs that actually *do* things - manipulate text, crunch numbers, make decisions. Every web developer needs this foundation.
>
> Which sounds exciting to you?"

## Soft Gating (Skipping Ahead)

Students CAN access locked sections, but discourage it progressively:

1. **First ask**: Explain what they'd miss and why it matters
2. **Second ask**: Warn more firmly - "You'll likely struggle without X"
3. **Third ask**: Let them proceed - "Okay, your call. We can always circle back."

## Test-Out Option

When a student wants to switch sections mid-stream (leaving units incomplete):

1. Offer to let them **test out** of remaining units individually
2. For each unit they want to skip, create a challenging exercise that covers the key concepts
3. If they pass, mark the unit complete
4. If they fail, suggest finishing the unit properly

This respects their time while ensuring they don't miss critical knowledge.

## Updating Progress

When a section is completed (all units done):
1. Run available-sections.js to see newly unlocked paths
2. Present the options enthusiastically
3. Let the student choose their next adventure