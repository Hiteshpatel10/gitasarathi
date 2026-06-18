import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { AuthorEntity } from './author.entity';

@Entity({ name: 'languages' })
export class LanguageEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 255 })
  language: string;

  @OneToMany(() => AuthorEntity, (author) => author.language)
  authors: AuthorEntity[];
}
