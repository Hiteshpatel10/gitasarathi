import { ChapterEntity } from 'src/gita/entities/chapter.entity';
import { UserReadsEntity } from '../entities/user-reads.entity';
import { VerseEntity } from 'src/gita/entities/verse.entity';
import { UserListensEntity } from '../entities/user-listen.entity';

export function applyUserReadProgress(
  chapters: ChapterEntity[],
  userProgress: UserReadsEntity[],
): ChapterEntity[] {
  const progressMap = new Map<number, number>();
  const verseMap = new Map<number, Set<number>>();

  userProgress.forEach((record) => {
    // Convert string chapter to number
    const chapterNum = parseInt(record.chapter.toString(), 10);
    progressMap.set(chapterNum, record.progress);

    const verseSet = new Set<number>();
    if (record.verses) {
      record.verses.split(',').forEach((v) => {
        const num = parseInt(v, 10);
        if (!isNaN(num)) verseSet.add(num);
      });
    }
    verseMap.set(chapterNum, verseSet);
  });

  chapters.forEach((chapter) => {
    if (progressMap.has(chapter.id)) {
      chapter.progress = progressMap.get(chapter.id);
    }

    const versesToFlag = verseMap.get(chapter.id);
    if (versesToFlag) {
      chapter.verses.forEach((verse: VerseEntity) => {
        const verseNum = parseInt(verse.verseNumber.toString(), 10);

        if (versesToFlag.has(verseNum)) {
          verse.isRead = true; // directly mutate
        }
      });
    }
  });

  return chapters;
}

export function applyUserListenProgress(
  chapters: ChapterEntity[],
  userProgress: UserListensEntity[],
) {
  const progressMap = new Map<number, number>();
  const verseMap = new Map<number, Set<number>>();

  userProgress.forEach((record) => {
    // Convert string chapter to number
    const chapterNum = parseInt(record.chapter.toString(), 10);
    progressMap.set(chapterNum, record.progress);

    const verseSet = new Set<number>();
    if (record.verses) {
      record.verses.split(',').forEach((v) => {
        const num = parseInt(v, 10);
        if (!isNaN(num)) verseSet.add(num);
      });
    }
    verseMap.set(chapterNum, verseSet);
  });

  chapters.forEach((chapter) => {
    if (progressMap.has(chapter.id)) {
      // Round to 2 decimals
      chapter.listenProgress =
        Math.round(progressMap.get(chapter.id)! * 100) / 100;
    }

    const versesToFlag = verseMap.get(chapter.id);
    if (versesToFlag) {
      chapter.verses.forEach((verse: VerseEntity) => {
        const verseNum = parseInt(verse.verseNumber.toString(), 10);
        if (versesToFlag.has(verseNum)) {
          verse.isListen = true; // directly mutate
        }
      });
    }
  });
}
