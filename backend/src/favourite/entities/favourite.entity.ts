import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { VerseEntity } from '../../gita/entities/verse.entity';
import { Expose } from 'class-transformer';

@Entity({ name: 'favorites' })
export class FavouriteEntity {
  @PrimaryGeneratedColumn()
  @Expose({ name: 'id' })
  id: number;

  @Column({ name: 'user_id', type: 'int' })
  @Expose({ name: 'user_id' })
  userId: number;

  @Column({ name: 'verse_id', type: 'int' })
  @Expose({ name: 'verse_id' })
  verseId: number;

  @Column({ name: 'favorite_list_id', type: 'int', nullable: true })
  @Expose({ name: 'favorite_list_id' })
  favoriteListId?: number;

  @CreateDateColumn({ name: 'created_at' })
  @Expose({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  @Expose({ name: 'updated_at' })
  updatedAt: Date;

  // Relationships

  @ManyToOne(() => VerseEntity, (verse) => verse.favorites)
  @JoinColumn({ name: 'verse_id' })
  @Expose({ name: 'verse' })
  verse: VerseEntity;

  @ManyToOne(() => FavouriteEntity, (list) => list.favoriteList)
  @JoinColumn({ name: 'favorite_list_id' })
  @Expose({ name: 'favorite_list' })
  favoriteList?: FavouriteEntity;
}
