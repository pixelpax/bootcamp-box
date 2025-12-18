#!/usr/bin/env node

/**
 * Determines which sections are available based on completed dependencies.
 * Fetches section structure from GitHub, compares against local progress.
 *
 * Usage: node available-sections.js
 *
 * Output: JSON with available, locked, and completed sections
 *
 * Dev mode: Set BOOTCAMP_DEV=1 to use local content/ instead of GitHub
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const REPO = 'pixelpax/code-chode';
const PROGRESS_FILE = path.join(__dirname, '..', '..', '..', '.teacher', 'progress.json');

function isDevMode() {
  return process.env.BOOTCAMP_DEV || fs.existsSync(path.join(__dirname, '..', '..', '..', '.dev'));
}

function getLocalContentDir() {
  const candidates = [
    path.join(__dirname, '..', '..', '..', '..', '..', 'content'),
    path.join(__dirname, '..', '..', '..', '..', 'content'),
    path.join(__dirname, '..', '..', '..', 'content'),
  ];
  for (const dir of candidates) {
    if (fs.existsSync(dir)) return dir;
  }
  return null;
}

function fetchSectionsFromGitHub() {
  try {
    const output = execSync(
      `gh api "repos/${REPO}/contents/content" --jq '.[] | select(.type=="dir") | .name'`,
      { encoding: 'utf-8', stdio: ['pipe', 'pipe', 'pipe'] }
    );
    return output.trim().split('\n').filter(s => !s.startsWith('.'));
  } catch (e) {
    console.error('Failed to fetch sections from GitHub:', e.message);
    process.exit(1);
  }
}

function fetchDepsFromGitHub(section) {
  try {
    const output = execSync(
      `curl -sS "https://raw.githubusercontent.com/${REPO}/main/content/${section}/.teacher/section-dependencies"`,
      { encoding: 'utf-8', stdio: ['pipe', 'pipe', 'pipe'] }
    );
    if (output.includes('404') || output.includes('Not Found')) {
      return [];
    }
    return output.trim().split('\n').map(l => l.trim()).filter(Boolean);
  } catch (e) {
    return [];
  }
}

function getSectionsLocal(contentDir) {
  return fs.readdirSync(contentDir, { withFileTypes: true })
    .filter(d => d.isDirectory() && !d.name.startsWith('.'))
    .map(d => d.name);
}

function getDepsLocal(contentDir, section) {
  const depFile = path.join(contentDir, section, '.teacher', 'section-dependencies');
  if (!fs.existsSync(depFile)) return [];
  const content = fs.readFileSync(depFile, 'utf-8').trim();
  return content ? content.split('\n').map(l => l.trim()).filter(Boolean) : [];
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
  if (!sectionData?.units) return false;

  // A section is complete when ALL units are completed
  const units = Object.values(sectionData.units);
  return units.length > 0 && units.every(u => u.completed === true);
}

function main() {
  const devMode = isDevMode();
  let sections, getDeps;

  if (devMode) {
    const contentDir = getLocalContentDir();
    if (!contentDir) {
      console.error('[DEV MODE] Cannot find content directory');
      process.exit(1);
    }
    console.error(`[DEV MODE] Using local content at ${contentDir}`);
    sections = getSectionsLocal(contentDir);
    getDeps = (s) => getDepsLocal(contentDir, s);
  } else {
    sections = fetchSectionsFromGitHub();
    getDeps = fetchDepsFromGitHub;
  }

  const progress = getProgress();

  // Build dependency map
  const depsMap = new Map();
  for (const section of sections) {
    depsMap.set(section, getDeps(section));
  }

  // Categorize sections
  const completed = [];
  const available = [];
  const locked = [];

  for (const section of sections) {
    const deps = depsMap.get(section) || [];
    const isComplete = isSectionComplete(progress, section);

    if (isComplete) {
      completed.push({ name: section, deps });
    } else {
      // Check if all deps are completed
      const allDepsComplete = deps.every(dep => isSectionComplete(progress, dep));
      if (allDepsComplete) {
        available.push({ name: section, deps });
      } else {
        const missingDeps = deps.filter(dep => !isSectionComplete(progress, dep));
        locked.push({ name: section, deps, missingDeps });
      }
    }
  }

  const result = {
    completed,
    available,
    locked,
    summary: {
      totalSections: sections.length,
      completedCount: completed.length,
      availableCount: available.length,
      lockedCount: locked.length
    }
  };

  console.log(JSON.stringify(result, null, 2));
}

main();