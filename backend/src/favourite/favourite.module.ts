import { Module } from '@nestjs/common';
import { FavouriteService } from './favourite.service';
import { FavouriteController } from './favourite.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FavouriteEntity } from './entities/favourite.entity';
import { FavoriteListEntity } from './entities/favourite-list.entity';

@Module({
  imports: [TypeOrmModule.forFeature([FavouriteEntity, FavoriteListEntity])],
  controllers: [FavouriteController],
  providers: [FavouriteService],
})
export class FavouriteModule {}
