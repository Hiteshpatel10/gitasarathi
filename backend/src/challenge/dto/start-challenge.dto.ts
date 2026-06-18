import { IsNotEmpty, IsNumber, IsOptional } from 'class-validator';
import { Expose, Type } from 'class-transformer';

export class StartChallengeDto {
  @IsNotEmpty()
  @IsNumber()
  @Type(() => Number)
  @Expose({ name: 'challenge_id' })
  challengeId: number;
}
