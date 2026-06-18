import { IsNotEmpty, IsNumber, IsOptional } from 'class-validator';
import { Expose, Type } from 'class-transformer';

export class StopChallengeDto {
  @IsNotEmpty()
  @IsNumber()
  @Type(() => Number)
  @Expose({ name: 'user_challenge_id' })
  userChallengeId: number;
}
