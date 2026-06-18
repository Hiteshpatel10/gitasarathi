import { IsNotEmpty, IsNumber } from 'class-validator';
import { Expose, Type } from 'class-transformer';

export class ChapterAndVerseDto {
  @IsNotEmpty()
  @IsNumber()
  @Type(() => Number)
  @Expose({ name: 'chapter_no' })
  chapterNo: number;

  @IsNotEmpty()
  @IsNumber()
  @Type(() => Number)
  @Expose({ name: 'verse_no' })
  verseNo: number;
}

  const gitaChapters: Record<number, number> = {
    1: 47, 2: 72, 3: 43, 4: 42, 5: 29, 6: 47, 7: 30, 8: 28,
    9: 34, 10: 42, 11: 55, 12: 20, 13: 35, 14: 27, 15: 20,
    16: 24, 17: 28, 18: 78,
  };