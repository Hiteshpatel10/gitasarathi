import { Module } from '@nestjs/common';
import { ChallengeService } from './challenge.service';
import { ChallengeController } from './challenge.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ChallengeEntity } from './entities/challenges.entity';
import { UserChallengeEntity } from './entities/user-challenge.entity';
import { UserChallengeController } from './user-challenge.controller';
import { UserChallengeService } from './user-challenge.service';
import { UserModule } from 'src/user/user.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([ChallengeEntity, UserChallengeEntity]),
    UserModule,
  ],
  controllers: [ChallengeController, UserChallengeController],
  providers: [ChallengeService, UserChallengeService],
})
export class ChallengeModule {}
