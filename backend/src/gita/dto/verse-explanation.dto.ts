import { IsNotEmpty, IsNumber } from 'class-validator';
import { Expose, Type } from 'class-transformer';

export class VerseExplanationDto {
  @IsNotEmpty()
  @IsNumber()
  @Type(() => Number)
  @Expose({ name: 'verse_id' })
  verseId: number;

  @IsNotEmpty()
  @IsNumber()
  @Type(() => Number)
  @Expose({ name: 'translation_author_id' })
  translationAuthorId: number;

  @IsNotEmpty()
  @IsNumber()
  @Type(() => Number)
  @Expose({ name: 'commentary_author_id' })
  commentaryAuthorId: number;
}
