import { IsString } from 'class-validator';
import { Expose } from 'class-transformer';

export class FcmTokenDto {
  @IsString()
  @Expose({ name: 'fcm_token' })
  fcmToken: string;
}
