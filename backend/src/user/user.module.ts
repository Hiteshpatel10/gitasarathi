import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from './entities/user.entity';
import { UserReadsEntity } from './entities/user-reads.entity';
import { UserActivityEntity } from './entities/user-activity.entity';
import { UserListensEntity } from './entities/user-listen.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      UserEntity,
      UserReadsEntity,
      UserActivityEntity,
      UserListensEntity,
    ]),
  ],
  controllers: [UserController],
  providers: [UserService],
  exports:[UserService]
})
export class UserModule {}
