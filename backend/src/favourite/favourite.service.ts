import { Injectable } from '@nestjs/common';
import { FavouriteEntity } from './entities/favourite.entity';
import { IsNull, Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';

@Injectable()
export class FavouriteService {
  constructor(
    @InjectRepository(FavouriteEntity)
    private readonly favRepository: Repository<FavouriteEntity>,
  ) {}

  async getFavorites({
    userId,
  }: {
    userId: number;
  }): Promise<FavouriteEntity[]> {
    try {
      const favorites = await this.favRepository.find({
        where: { userId },
        relations: ['verse', 'verse.translations'],
      });

      return favorites;
    } catch (error) {
      throw new Error(`Failed to fetch favorites: ${error.message}`);
    }
  }

  async addFavorite({
    userId,
    verseId,
    listId,
  }: {
    userId: number;
    verseId: number;
    listId?: number;
  }): Promise<FavouriteEntity> {
    const existing = await this.favRepository.findOne({
      where: {
        userId,
        verseId,
        favoriteListId: listId !== undefined ? listId : IsNull(),
      },
    });

    if (existing) {
      throw new Error('Favorite already exists');
    }

    const favorite = this.favRepository.create({
      userId,
      verseId,
      favoriteListId: listId ?? undefined,
    });

    return await this.favRepository.save(favorite);
  }

  async removeFavorite({
    userId,
    verseId,
    listId,
  }: {
    userId: number;
    verseId: number;
    listId?: number;
  }): Promise<FavouriteEntity> {
    // Find the favorite record
    const existing = await this.favRepository.findOne({
      where: {
        userId,
        verseId,
        favoriteListId: listId !== undefined ? listId : IsNull(),
      },
    });

    if (!existing) {
      throw new Error('Favorite not found');
    }

    // Remove the record
    await this.favRepository.remove(existing);

    // Return the removed entity
    return existing;
  }

  // async removeFavorite({
  //   userId,
  //   favouriteId,
  //   listId,
  // }: {
  //   userId: number;
  //   favouriteId: number;
  //   listId?: number;
  // }): Promise<void> {
  //   const where: any = {
  //     userId,
  //     id: favouriteId,
  //   };

  //   if (listId !== undefined) {
  //     where.favoriteListId = listId;
  //   }

  //   const result = await this.favRepository.delete(where);

  //   if (result.affected === 0) {
  //     throw new Error('Favorite record not found');
  //   }
  // }
}
