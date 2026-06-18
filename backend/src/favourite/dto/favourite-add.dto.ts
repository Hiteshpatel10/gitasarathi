import { IsNotEmpty, IsNumber, IsOptional } from 'class-validator';
import { Expose, Type } from 'class-transformer';

export class FavouriteAddDto {
  @IsNotEmpty()
  @IsNumber()
  @Type(() => Number)
  @Expose({ name: 'verse_id' })
  verseId: number;

  @IsNumber()
  @IsOptional()
  @Type(() => Number)
  @Expose({ name: 'list_id' })
  listId?: number;
}