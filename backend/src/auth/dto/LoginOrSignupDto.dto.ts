import { IsEmail, IsNotEmpty, IsOptional } from 'class-validator';
import { Expose } from 'class-transformer';

export class LoginOrSignupDto {
  @IsEmail()
  @IsNotEmpty()
  @Expose({ name: 'email' })
  email: string;

  @IsNotEmpty()
  @Expose({ name: 'google_auth_id' })
  googleAuthId: string;

  @IsNotEmpty()
  @Expose({ name: 'display_name' })
  displayName: string;

  @IsOptional()
  @Expose({ name: 'display_image' })
  displayImage?: string;
}
