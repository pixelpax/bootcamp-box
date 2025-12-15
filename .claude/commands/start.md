# Start Command

The student wants to begin or continue their learning journey.

## If first time (no .learner/profile.md exists):
1. Welcome them warmly to Bootcamp Box
2. Ask a few quick onboarding questions:
   - What's their name?
   - Any prior programming experience? (none / a little / some)
   - What's their goal? (career change, hobby, school, etc.)
   - Do they prefer detailed explanations or learn-by-doing?
3. Create `.learner/profile.md` with their answers
4. Create `.learner/notebook.md` (your private notes, start empty)
5. Create `.learner/progress.json` with initial structure
6. Fetch and present the first lesson

## If returning (profile exists):
1. Welcome them back by name
2. Check progress.json for where they left off
3. Offer to continue current lesson or review their last completed one

## Progress.json structure:
```json
{
  "current_course": "fundamentals",
  "current_lesson": "01-hello-terminal",
  "completed": [],
  "struggles": []
}
```