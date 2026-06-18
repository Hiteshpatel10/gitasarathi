import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { VerseEntity } from './verse.entity';
import { Expose, Transform } from 'class-transformer';
import { constants } from 'src/config/constants';

@Entity({ name: 'chapters' })
export class ChapterEntity {
  @PrimaryGeneratedColumn()
  @Expose({ name: 'id' })
  id: number;

  @Column({ name: 'chapter_number', type: 'int' })
  @Expose({ name: 'chapter_number' })
  chapterNumber: number;

  @Column({ name: 'chapter_summary', type: 'text' })
  @Expose({ name: 'chapter_summary' })
  chapterSummary: string;

  @Column({ name: 'chapter_summary_hindi', type: 'text' })
  @Expose({ name: 'chapter_summary_hindi' })
  chapterSummaryHindi: string;

  @Column({ name: 'image_name', type: 'varchar', length: 255 })
  @Expose({ name: 'image_name' })
  imageName: string;

  @Expose({ name: 'image_url' })
  @Transform(({ obj }) => `${constants.S3Url}assets/${obj.imageName}.png`)
  get imageUrl(): string {
    return `${constants.S3Url}assets/${this.imageName}.png`;
  }

  @Column({ type: 'varchar', length: 255 })
  @Expose({ name: 'name' })
  name: string;

  @Column({ name: 'name_meaning', type: 'varchar', length: 255 })
  @Expose({ name: 'name_meaning' })
  nameMeaning: string;

  @Column({ name: 'name_translation', type: 'varchar', length: 255 })
  @Expose({ name: 'name_translation' })
  nameTranslation: string;

  @Column({ name: 'name_transliterated', type: 'varchar', length: 255 })
  @Expose({ name: 'name_transliterated' })
  nameTransliterated: string;

  @Column({ name: 'verses_count', type: 'int' })
  @Expose({ name: 'verses_count' })
  versesCount: number;

  // Non-persistent fields
  @Expose({ name: 'progress' })
  progress?: number;

  @Expose({ name: 'listen_progress' })
  listenProgress?: number;

  @OneToMany(() => VerseEntity, (verse) => verse.chapter, { cascade: true })
  @Expose({ name: 'verses' })
  verses: VerseEntity[];
}
