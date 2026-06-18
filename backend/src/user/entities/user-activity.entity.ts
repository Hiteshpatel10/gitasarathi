import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';
import { Expose } from 'class-transformer';

@Entity('user_activity')
export class UserActivityEntity {
  @PrimaryGeneratedColumn()
  @Expose({ name: 'id' })
  id: number;

  @Index()
  @Column({ name: 'user_id', type: 'int', nullable: false })
  @Expose({ name: 'user_id' })
  userId: number;

  @Index()
  @Column({ name: 'session_id', type: 'varchar', length: 255, nullable: true })
  @Expose({ name: 'session_id' })
  sessionId?: string | null;

  @Column({ type: 'varchar', length: 50, nullable: false })
  @Expose({ name: 'activity' })
  activity: string;

  @Index()
  @Column({ name: 'chapter_id', type: 'int', nullable: true })
  @Expose({ name: 'chapter_id' })
  chapterId?: number | null;

  @Index()
  @Column({ name: 'verse_id', type: 'int', nullable: true })
  @Expose({ name: 'verse_id' })
  verseId?: number | null;

  @CreateDateColumn({
    name: 'created_at',
    type: 'datetime',
    precision: 3,
  })
  @Expose({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({
    name: 'updated_at',
    type: 'datetime',
    precision: 3,
  })
  @Expose({ name: 'updated_at' })
  updatedAt: Date;
}
