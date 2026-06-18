import { IsNotEmpty, IsNumber, Min, Max } from 'class-validator';
import { Expose, Type } from 'class-transformer';

export class MonthlyUserReadDto {
  @IsNotEmpty()
  @IsNumber()
  @Type(() => Number)
  @Min(1, { message: 'Month must be at least 1' })
  @Max(12, { message: 'Month cannot be more than 12' })
  @Expose({ name: 'month' })
  month: number;

  @IsNotEmpty()
  @IsNumber()
  @Type(() => Number)
  @Min(2023, { message: 'Year must be at least 2023' })
  @Max(new Date().getFullYear(), {
    message: `Year cannot be greater than ${new Date().getFullYear()}`,
  })
  @Expose({ name: 'year' })
  year: number;
}
