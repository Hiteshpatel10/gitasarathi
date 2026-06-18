import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
} from 'typeorm';
import { UserChallengeEntity } from './user-challenge.entity';
import { Expose } from 'class-transformer';

@Entity('challenges')
export class ChallengeEntity {
  @PrimaryGeneratedColumn()
  @Expose({ name: 'id' })
  id: number;

  @Column({ type: 'varchar', length: 255 })
  @Expose({ name: 'name' })
  name: string;

  @Column({ type: 'text', nullable: true })
  @Expose({ name: 'description' })
  description: string;

  @Column({ type: 'int', name: 'days_required' })
  @Expose({ name: 'days_required' })
  daysRequired: number;

  @Column({
    type: 'enum',
    enum: ['strict', 'flexible'],
  })
  @Expose({ name: 'type' })
  type: 'strict' | 'flexible';

  @Column({ type: 'int', name: 'flexible_days', default: 0 })
  @Expose({ name: 'flexible_days' })
  flexibleDays: number;

  @Column({ type: 'varchar', length: 255, nullable: true })
  @Expose({ name: 'icon' })
  icon: string;

  @Column({ type: 'varchar', length: 255, name: 'cover_image', nullable: true })
  @Expose({ name: 'cover_image' })
  coverImage: string;

  @CreateDateColumn({ name: 'created_at' })
  @Expose({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  @Expose({ name: 'updated_at' })
  updatedAt: Date;

  // Relation back to user challenges
  @OneToMany(() => UserChallengeEntity, (uc) => uc.challenge)
  @Expose({ name: 'user_challenges' })
  userChallenges: UserChallengeEntity[];
}
