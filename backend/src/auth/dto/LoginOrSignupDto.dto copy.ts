import { IsEmail, IsNotEmpty, IsOptional } from 'class-validator';
import { Expose } from 'class-transformer';

export class SuperAuthDto {
  @IsEmail()
  @IsNotEmpty()
  @Expose({ name: 'email' })
  email: string;

  @IsNotEmpty()
  @Expose({ name: 'secret' })
  secret: string;
}
