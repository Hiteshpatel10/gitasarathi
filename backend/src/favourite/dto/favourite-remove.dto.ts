import { IsNotEmpty, IsNumber, IsOptional } from 'class-validator';
import { Expose, Type } from 'class-transformer';

export class FavouriteRemoveDto {
  @IsNotEmpty()
  @IsNumber()
  @Type(() => Number)
  @Expose({ name: 'favourite_id' })
  favouriteId: number;

  @IsNumber()
  @IsOptional()
  @Type(() => Number)
  @Expose({ name: 'list_id' })
  listId?: number;
}
