import { BadRequestException, Injectable, Post, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import { UserEntity } from '../user/entities/user.entity';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(UserEntity)
    private readonly usersRepository: Repository<UserEntity>,
    private readonly jwtService: JwtService,
  ) {}

  async loginOrSignup(
    email: string,
    googleAuthId: string,
    displayName: string,
    displayImage?: string,
  ): Promise<{ token: string }> {
    let user = await this.usersRepository.findOne({ where: { email } });

    if (user) {
      // Update GoogleAuthID if different
      if (user.googleAuthId !== googleAuthId) {
        user.googleAuthId = googleAuthId;
        await this.usersRepository.save(user);
      }
    } else {
      // Create a new user
      user = this.usersRepository.create({
        email,
        googleAuthId,
        displayName,
        displayImage,
      });
      await this.usersRepository.save(user);
    }

    // Generate JWT
    const payload = { user_id: user.id, email: user.email };
    const token = await this.jwtService.signAsync(payload);

    return { token };
  }


    async getUserByEmail(
    email: string,
  ): Promise<{ token: string }> {
    let user = await this.usersRepository.findOne({ where: { email } });

    if(user == null){
      throw new BadRequestException('No user found');
    }

    const payload = { user_id: user.id, email: user.email };
    const token = await this.jwtService.signAsync(payload);

    return { token };
  }
}
