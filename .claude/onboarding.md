# Start Command

The student wants to begin or continue their learning journey.

## If first time (no .teacher/preferences.md exists):
1. Welcome them warmly to Bootcamp Box
2. Ask a few quick onboarding questions (keep it very brief):
   - What would you like me to call you? 
   - How should I talk? Professional? Like we're friends? With dad jokes? With some bitter sarcasm? Zillenial emojis? Victorian street urchin?
   - Any prior programming experience? (none / a little / some)
3. Create `.teacher/preferences.md` with their answers
4. Create `.teacher/notes.md` (your private notes, start empty)
5. Create `.teacher/progress.json` with initial structure
6. Fetch the first lesson in the section "dev-setup" to begin. You can use `./list-available-lessons.sh` to see available lessons.

## If returning (profile exists):
1. Welcome them back by name
2. Check progress.json for where they left off
3. Offer to continue current lesson or review their last completed one

## Progress.json structure:

```json
{
  "lessons_so_far": {
    "fundamentals": {
      "01-terminal-basics": {
        "01-hello-terminal": {
            "status": "completed",
            "score": 95,
            "memory-aids": [""], // Optional: any memory aids they created, encourage them to make them
            "topic-notes": "Struggled a bit with navigation commands, but got it eventually."
            }
        }
    }
  }
}
```
