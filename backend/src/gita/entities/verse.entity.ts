import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
  JoinColumn,
} from 'typeorm';
import { ChapterEntity } from './chapter.entity';
import { VerseCommentaryEntity } from './verse-commentary.entity';
import { VerseTranslationEntity } from './verse-translation.entity';
import { FavouriteEntity } from '../../favourite/entities/favourite.entity';
import { Expose } from 'class-transformer';

@Entity({ name: 'verses' })
export class VerseEntity {
  @PrimaryGeneratedColumn()
  @Expose({ name: 'id' })
  id: number;

  @Column({ name: 'chapter_id', type: 'int' })
  @Expose({ name: 'chapter_id' })
  chapterId: number;

  @Column({ name: 'chapter_number', type: 'int' })
  @Expose({ name: 'chapter_number' })
  chapterNumber: number;

  @Column({ name: 'external_id', type: 'int' })
  @Expose({ name: 'external_id' })
  externalId: number;

  @Column({ type: 'text' })
  @Expose({ name: 'text' })
  text: string;

  @Column({ type: 'varchar', length: 255 })
  @Expose({ name: 'title' })
  title: string;

  @Column({ name: 'verse_number', type: 'int' })
  @Expose({ name: 'verse_number' })
  verseNumber: number;

  @Column({ name: 'verse_order', type: 'int' })
  @Expose({ name: 'verse_order' })
  verseOrder: number;

  @Column({ type: 'text' })
  @Expose({ name: 'transliteration' })
  transliteration: string;

  @Column({ name: 'word_meanings', type: 'text' })
  @Expose({ name: 'word_meanings' })
  wordMeanings: string;

  // Non-persistent fields
  @Expose({ name: 'is_read' })
  isRead?: boolean;

  @Expose({ name: 'is_listen' })
  isListen?: boolean;

  // Relations
  @ManyToOne(() => ChapterEntity, (chapter) => chapter.verses)
  @JoinColumn({ name: 'chapter_id' })
  @Expose({ name: 'chapter' })
  chapter: ChapterEntity;

  @OneToMany(() => VerseTranslationEntity, (translation) => translation.verse)
  @Expose({ name: 'verse_translation' })
  translations: VerseTranslationEntity[];

  @OneToMany(() => VerseCommentaryEntity, (commentary) => commentary.verse)
  @Expose({ name: 'verse_commentary' })
  commentaries: VerseCommentaryEntity[];

  @OneToMany(() => FavouriteEntity, (favorite) => favorite.verse)
  @Expose({ name: 'favorites' })
  favorites: FavouriteEntity[];
}
