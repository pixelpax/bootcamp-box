# Submit Command

The student is submitting their work for the current lesson.

## Grading Process:
1. Read `.teacher/rubric.md` for the current lesson
2. Check their work against each rubric item:
   - Run any tests in `.teacher/tests/` if they exist
   - Run any scripts in `.teacher/scripts/` if needed
   - Check for inline comment answers if required
   - Request screenshots if the rubric requires visual verification
3. Provide feedback:
   - What they did well
   - What needs improvement (if anything)
   - If they pass: congratulate and mark complete
   - If they don't pass: explain what's missing, offer hints

## After Grading:
1. Update `.teacher/progress.json`:
   - If passed: add lesson to "completed" array
   - If struggled: add topic to "struggles" array
2. Update `.teacher/notes_about_student.md` with observations:
   - Did they need hints?
   - What concepts seemed shaky?
   - Any patterns in their code style?
3. Ask a quick follow-up question to verify understanding
4. Let them know they can `/next` when ready

## If They Don't Pass:
- Be encouraging, not discouraging
- Point them toward what to fix
- Offer Socratic hints, not solutions
- They can `/submit` again when ready
