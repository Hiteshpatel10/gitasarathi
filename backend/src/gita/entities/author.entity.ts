import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { LanguageEntity } from './language.entity';

import { Expose } from 'class-transformer';

@Entity({ name: 'authors' })
export class AuthorEntity {
  @PrimaryGeneratedColumn()
  @Expose({ name: 'id' })
  id: number;

  @Column({ type: 'varchar', length: 255 })
  @Expose({ name: 'name' })
  name: string;

  @Column({ type: 'text', name: 'author_description', nullable: true })
  @Expose({ name: 'author_description' })
  authorDescription?: string;

  @Column({ type: 'int' })
  @Expose({ name: 'comment' })
  comment: number;

  @Column({ type: 'int' })
  @Expose({ name: 'translation' })
  translation: number;

  @Column({ name: 'language_id', type: 'int' })
  @Expose({ name: 'language_id' })
  languageId: number;

  @ManyToOne(() => LanguageEntity, (language) => language.authors)
  @JoinColumn({ name: 'language_id' })
  @Expose({ name: 'language' })
  language: LanguageEntity;
}

