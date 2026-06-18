import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
  UpdateDateColumn,
} from 'typeorm';
import { ChallengeEntity } from './challenges.entity';
import { Expose } from 'class-transformer';

@Entity('user_challenges')
export class UserChallengeEntity {
  @PrimaryGeneratedColumn()
  @Expose({ name: 'id' })
  id: number;

  @Column({ name: 'user_id', type: 'int' })
  @Expose({ name: 'user_id' })
  userId: number;

  @Column({ name: 'challenge_id', type: 'int' })
  @Expose({ name: 'challenge_id' })
  challengeId: number;

  @Column({ name: 'days_completed', type: 'int', default: 0 })
  @Expose({ name: 'days_completed' })
  daysCompleted: number;

  @Column({ name: 'missed_days', type: 'int', default: 0 })
  @Expose({ name: 'missed_days' })
  missedDays: number;

  @Column({
    type: 'enum',
    enum: ['active', 'completed', 'failed', 'stopped'],
  })
  @Expose({ name: 'status' })
  status: 'active' | 'completed' | 'failed' | 'stopped';

  @Column({ name: 'start_date', type: 'timestamp' })
  @Expose({ name: 'start_date' })
  startDate: Date;

  @Column({ name: 'end_date', type: 'timestamp' })
  @Expose({ name: 'end_date' })
  endDate: Date;

  @Column({ name: 'completed_at', type: 'timestamp', nullable: true })
  @Expose({ name: 'completed_at' })
  completedAt: Date | null;

  @UpdateDateColumn({ name: 'updated_at' })
  @Expose({ name: 'updated_at' })
  updatedAt: Date;

  // Non-persistent fields
  @Expose({ name: 'is_task_done_now' })
  isTaskDoneNow?: boolean;

  @Expose({ name: 'timeline' })
  timeline?: Record<string, string>;

  // Relation to Challenge
  @ManyToOne(() => ChallengeEntity, (challenge) => challenge.userChallenges, {
    eager: true,
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'challenge_id', referencedColumnName: 'id' })
  @Expose({ name: 'challenge' })
  challenge: ChallengeEntity;
}
