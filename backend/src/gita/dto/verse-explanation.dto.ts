import { IsNotEmpty, IsNumber, IsOptional, IsBoolean } from 'class-validator';
import { Expose, Type } from 'class-transformer';

export class VerseExplanationDto {
  @IsNotEmpty()
  @IsNumber()
  @Type(() => Number)
  @Expose({ name: 'verse_id' })
  verseId: number;

  @IsOptional()
  @IsNumber()
  @Type(() => Number)
  @Expose({ name: 'translation_author_id' })
  translationAuthorId?: number;

  @IsOptional()
  @IsNumber()
  @Type(() => Number)
  @Expose({ name: 'commentary_author_id' })
  commentaryAuthorId?: number;

  @IsOptional()
  @IsBoolean()
  @Expose({ name: 'all_authors' })
  allAuthors?: boolean;
}
