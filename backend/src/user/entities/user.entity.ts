import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Expose } from 'class-transformer';

@Entity('users')
export class UserEntity {
  @PrimaryGeneratedColumn()
  @Expose({ name: 'id' })
  id: number;

  @Column({ unique: true, nullable: false })
  @Expose({ name: 'email' })
  email: string;

  @Column({ name: 'google_auth_id', unique: true, nullable: true })
  @Expose({ name: 'google_auth_id' })
  googleAuthId: string;

  @CreateDateColumn({ name: 'created_at' })
  @Expose({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  @Expose({ name: 'updated_at' })
  updatedAt: Date;

  @Column({ name: 'display_name', nullable: false })
  @Expose({ name: 'display_name' })
  displayName: string;

  @Column({ name: 'display_image', type: 'text', nullable: true })
  @Expose({ name: 'display_image' })
  displayImage?: string;

  @Column({ name: 'fcm_token', type: 'text', nullable: true })
  @Expose({ name: 'fcm_token' })
  fcmToken?: string;

  @Column({ type: 'text', nullable: true })
  @Expose({ name: 'location' })
  location?: string;

  @Column({ name: 'is_fcm_valid', default: false })
  @Expose({ name: 'is_fcm_valid' })
  isFcmValid: boolean;

  @Column({ name: 'build_no', type: 'int', nullable: true })
  @Expose({ name: 'build_no' })
  buildNo?: number;

  // Transient property (not stored in DB)
  @Expose({ name: 'last_verse_read' })
  lastVerseRead?: any;

  // Uncomment when adding relations
  // @OneToMany(() => UserReads, (userReads) => userReads.user)
  // @Expose({ name: 'user_reads' })
  // userReads: UserReads[];
}
