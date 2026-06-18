// src/favourite/entities/favorite-list.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, OneToMany, ManyToOne, JoinColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { FavouriteEntity } from './favourite.entity';
import { UserEntity } from 'src/user/entities/user.entity';

@Entity({ name: 'favorite_lists' })
export class FavoriteListEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'user_id', type: 'int' })
  userId: number;

  @Column({ type: 'varchar', length: 255 })
  name: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  // Relationships

 @ManyToOne(() => UserEntity)
  @JoinColumn({ name: 'user_id' })
  user: UserEntity;


  @OneToMany(() => FavouriteEntity, (favorite) => favorite.favoriteList)
  favorites: FavouriteEntity[];
}
