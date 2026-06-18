import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { VerseEntity } from './verse.entity';
import { Expose } from 'class-transformer';

@Entity({ name: 'verse_commentary' })
export class VerseCommentaryEntity {
  @PrimaryGeneratedColumn()
  @Expose({ name: 'id' })
  id: number;

  @Column({ name: 'author_name', type: 'varchar', length: 255 })
  @Expose({ name: 'author_name' })
  authorName: string;

  @Column({ name: 'author_id', type: 'int' })
  @Expose({ name: 'author_id' })
  authorId: number;

  @Column({ type: 'text' })
  @Expose({ name: 'description' })
  description: string;

  @Column({ type: 'varchar', length: 50 })
  @Expose({ name: 'lang' })
  lang: string;

  @Column({ name: 'language_id', type: 'int' })
  @Expose({ name: 'language_id' })
  languageId: number;

  @Column({ name: 'verse_number', type: 'int' })
  @Expose({ name: 'verse_number' })
  verseNumber: number;

  @Column({ name: 'verse_id', type: 'int' })
  @Expose({ name: 'verse_id' })
  verseId: number;

  @ManyToOne(() => VerseEntity, (verse) => verse.commentaries)
  @JoinColumn({ name: 'verse_id' })
  @Expose({ name: 'verse' })
  verse: VerseEntity;
}
