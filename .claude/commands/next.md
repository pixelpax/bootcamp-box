# Next Command

The student wants to move to the next lesson.

## Pre-check:
1. Verify current lesson is in "completed" array in progress.json
2. If not completed, remind them to `/submit` first

## Discovering Next Lesson:
The curriculum is defined by folder structure. Use `gh` to discover what's available:

```bash
# List lessons in current unit (dev mode - local)
ls ../content/<section>/<unit>/

# List lessons in current unit (production - from GitHub)
gh api repos/pixelpax/code-chode/contents/content/<section>/<unit> --jq '.[].name'
```

Lessons are numbered (01-, 02-, etc). Find the next one after current.

If no more lessons in current unit, check for next unit in the section.
If no more units, check for next section or congratulate on completion.

## Fetching Next Lesson:
Once you know the next lesson path:
```bash
./.claude/scripts/fetch-lesson.sh <section>/<unit>/<lesson>
```

## Starting the Lesson:
1. Read the new `.teacher/instructions.md` (keep private)
2. Present `lesson.md` to the student
3. Explain what they'll learn
4. Guide them to the starter code
5. Update progress.json with new current_lesson

## If No More Lessons:
- Congratulate them on completing the unit!
- Let them know more content is coming
- Suggest reviewing any topics from their "struggles" list