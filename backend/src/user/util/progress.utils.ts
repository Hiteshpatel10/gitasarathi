// src/common/utils/progress.utils.ts
import { BadRequestException } from '@nestjs/common';

export type ProgressEntity = {
  userId: number;
  chapter: number;
  verses: string;
  progress: number;
};

// Helper function to validate chapter and get total verses
export function getChapterVerseCount(chapterNo: number): number {
  const gitaChapters: Record<number, number> = {
    1: 47,
    2: 72,
    3: 43,
    4: 42,
    5: 29,
    6: 47,
    7: 30,
    8: 28,
    9: 34,
    10: 42,
    11: 55,
    12: 20,
    13: 35,
    14: 27,
    15: 20,
    16: 24,
    17: 28,
    18: 78,
  };

  if (!gitaChapters[chapterNo]) {
    throw new BadRequestException(`Invalid chapter number: ${chapterNo}`);
  }

  return gitaChapters[chapterNo];
}

// Helper function to calculate progress percentage
export function calculateProgress(verseCount: number, chapterNo: number): number {
  const totalVerses = getChapterVerseCount(chapterNo);
  return Math.round((verseCount / totalVerses) * 100);
}

// Helper function to process verses string and return updated verses + progress
export function processVerses(
  existingVerses: string | null,
  newVerseNo: number,
  chapterNo: number,
): { verses: string; progress: number; isNewVerse: boolean } {
  const verseStr = `${newVerseNo}`;
  const verses = existingVerses ? existingVerses.split(',') : [];
  const verseSet = new Set(verses);

  if (verseSet.has(verseStr)) {
    return {
      verses: existingVerses || '',
      progress: calculateProgress(verseSet.size, chapterNo),
      isNewVerse: false,
    };
  }

  verseSet.add(verseStr);
  const updatedVerses = Array.from(verseSet).join(',');
  const progress = calculateProgress(verseSet.size, chapterNo);

  return {
    verses: updatedVerses,
    progress,
    isNewVerse: true,
  };
}