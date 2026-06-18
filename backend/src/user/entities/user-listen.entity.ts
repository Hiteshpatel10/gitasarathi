import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';
import { Expose } from 'class-transformer';

@Entity('user_listens')
export class UserListensEntity {
  @PrimaryGeneratedColumn()
  @Expose({ name: 'id' })
  id: number;

  @Index()
  @Column({ name: 'user_id', type: 'int', nullable: false })
  @Expose({ name: 'user_id' })
  userId: number;

  @Column({ type: 'int', nullable: false })
  @Expose({ name: 'chapter' })
  chapter: number;

  @Column({ type: 'text', nullable: true })
  @Expose({ name: 'verses' })
  verses: string;

  @Column({ type: 'float', nullable: false })
  @Expose({ name: 'progress' })
  progress: number;

  @CreateDateColumn({ name: 'created_at' })
  @Expose({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  @Expose({ name: 'updated_at' })
  updatedAt: Date;
}
