import { IsNumber, IsOptional, IsString } from 'class-validator';
import { Expose, Type } from 'class-transformer';

export class UserActivityDto {
  @IsOptional()
  @IsNumber()
  @Type(() => Number)
  @Expose({ name: 'chapter_no' })
  chapterNo?: number;

  @IsOptional()
  @IsNumber()
  @Type(() => Number)
  @Expose({ name: 'verse_no' })
  verseNo?: number;

  @IsString()
  @Expose({ name: 'activity'})
  activity: string;  

  @IsOptional()
  @IsString()
  @Expose({ name: 'session_id' })
  sessionId?: string | null; 
}
