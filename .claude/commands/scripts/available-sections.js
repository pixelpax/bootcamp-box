#!/usr/bin/env node

/**
 * Determines which sections are available based on completed dependencies.
 * Reads dependencies from course_map.json, compares against local progress.
 *
 * Usage: node available-sections.js
 *
 * Output: JSON with available, locked, and completed sections
 */

const fs = require('fs');
const path = require('path');

const PROGRESS_FILE = path.join(__dirname, '..', '..', '..', '.teacher', 'progress.json');
const COURSE_MAP_FILE = path.join(__dirname, '..', '..', '..', 'course_map.json');
const COURSE_MAP_URL = 'https://raw.githubusercontent.com/pixelpax/code-chode/main/course_map.json';

async function fetchCourseMap() {
  // Try local file first
  if (fs.existsSync(COURSE_MAP_FILE)) {
    try {
      return JSON.parse(fs.readFileSync(COURSE_MAP_FILE, 'utf-8'));
    } catch (e) {
      console.error('Failed to parse local course_map.json:', e.message);
    }
  }

  // Fall back to GitHub
  try {
    const response = await fetch(COURSE_MAP_URL);
    if (response.ok) {
      return await response.json();
    }
  } catch (e) {
    console.error('Failed to fetch course map from GitHub:', e.message);
  }

  console.error('Could not load course map from any source');
  process.exit(1);
}

function getProgress() {
  if (!fs.existsSync(PROGRESS_FILE)) {
    return { sections: {} };
  }
  try {
    return JSON.parse(fs.readFileSync(PROGRESS_FILE, 'utf-8'));
  } catch (e) {
    return { sections: {} };
  }
}

function isSectionComplete(progress, section) {
  const sectionData = progress.sections?.[section];
  return sectionData?.completed === true;
}

async function main() {
  const courseMap = await fetchCourseMap();
  const progress = getProgress();

  const completed = [];
  const available = [];
  const locked = [];

  for (const [sectionId, section] of Object.entries(courseMap.sections)) {
    const deps = section.dependencies || [];
    const isComplete = isSectionComplete(progress, sectionId);

    if (isComplete) {
      completed.push({
        name: sectionId,
        title: section.title,
        deps
      });
    } else {
      // Check if all deps are completed
      const allDepsComplete = deps.length === 0 || deps.every(dep => isSectionComplete(progress, dep));
      if (allDepsComplete) {
        available.push({
          name: sectionId,
          title: section.title,
          description: section.description,
          deps
        });
      } else {
        const missingDeps = deps.filter(dep => !isSectionComplete(progress, dep));
        locked.push({
          name: sectionId,
          title: section.title,
          deps,
          missingDeps
        });
      }
    }
  }

  const result = {
    completed,
    available,
    locked,
    summary: {
      totalSections: Object.keys(courseMap.sections).length,
      completedCount: completed.length,
      availableCount: available.length,
      lockedCount: locked.length
    }
  };

  console.log(JSON.stringify(result, null, 2));
}

main();
