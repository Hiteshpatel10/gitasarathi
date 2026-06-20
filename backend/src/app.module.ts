import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './auth/auth.module';
import { UserModule } from './user/user.module';
import { GitaModule } from './gita/gita.module';
import { FavouriteModule } from './favourite/favourite.module';
import { ChallengeModule } from './challenge/challenge.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true, // makes .env accessible everywhere
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        type: 'mysql',
        host: process.env.DB_HOST,
        port: Number(process.env.DB_PORT),
        username: process.env.DB_USER,
        password: process.env.DB_PASS,
        database: process.env.DB_NAME,
        autoLoadEntities: true,
        bigNumberStrings: false,
        supportBigNumbers: true,
      }),
    }),
    AuthModule,
    UserModule,
    GitaModule,
    FavouriteModule,
    ChallengeModule,
  ],
})
export class AppModule { }
