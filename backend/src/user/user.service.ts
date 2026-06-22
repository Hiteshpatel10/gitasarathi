import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserEntity } from './entities/user.entity';
import { UserReadsEntity } from './entities/user-reads.entity';
import { UserActivityEntity } from './entities/user-activity.entity';
import { calculateProgress, processVerses } from './util/progress.utils';
import { UserListensEntity } from './entities/user-listen.entity';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
    @InjectRepository(UserReadsEntity)
    private readonly userReadsRepository: Repository<UserReadsEntity>,
    @InjectRepository(UserListensEntity)
    private readonly userListensRepository: Repository<UserListensEntity>,
    @InjectRepository(UserActivityEntity)
    private readonly userActivityRepository: Repository<UserActivityEntity>,
  ) {}

  async getUserById(id: number): Promise<UserEntity> {
    const user = await this.userRepository.findOne({ where: { id } });

    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    return user;
  }

  async updateFCMToken({
    userId,
    fcmToken,
  }: {
    userId: number;
    fcmToken: string;
  }): Promise<UserEntity> {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException(`User with ID ${userId} not found`);
    }

    user.fcmToken = fcmToken;
    return await this.userRepository.save(user);
  }

  async insertUserActivity({
    userId,
    chapterNo,
    verseNo,
    activity,
    sessionId,
  }: {
    userId: number;
    chapterNo?: number;
    verseNo?: number;
    activity: string;
    sessionId?: string | null;
  }): Promise<UserActivityEntity> {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new BadRequestException(`User with ID ${userId} not found`);
    }

    const activityEntity = this.userActivityRepository.create({
      userId,
      chapterId: chapterNo ?? null,
      verseId: verseNo ?? null,
      activity,
      sessionId: sessionId ?? null,
    });

    return this.userActivityRepository.save(activityEntity);
  }

  async monthlyUserReadActivity({
    userId,
    month,
    year,
  }: {
    userId: number;
    month: number;
    year: number;
  }) {
    const userActivity = await this.userActivityRepository
      .createQueryBuilder('activity')
      .where('activity.user_id = :userId', { userId: userId })
      .andWhere('YEAR(activity.created_at) = :year', { year })
      .andWhere('MONTH(activity.created_at) = :month', { month })
      .andWhere('activity.activity = :activityType', {
        activityType: 'Verse Read',
      })
      .getMany();

    return userActivity;
  }

  async userReadActivityByDateRange({
    userId,
    startDate,
    endDate,
  }: {
    userId: number;
    startDate: Date;
    endDate: Date;
  }) {
    const userActivity = await this.userActivityRepository
      .createQueryBuilder('activity')
      .where('activity.user_id = :userId', { userId })
      .andWhere('activity.created_at BETWEEN :startDate AND :endDate', {
        startDate,
        endDate,
      })
      .andWhere('activity.activity = :activityType', {
        activityType: 'Verse Read',
      })
      .getMany();

    return userActivity;
  }

  async getUserLastActivity(userId: number): Promise<UserActivityEntity | null> {
    const lastActivity = await this.userActivityRepository.findOne({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
    return lastActivity;
  }

  async getUserStreakSummary(userId: number) {
    const activities = await this.userActivityRepository
      .createQueryBuilder('activity')
      .where('activity.user_id = :userId', { userId })
      .andWhere('activity.activity = :activityType', {
        activityType: 'Verse Read',
      })
      .orderBy('activity.created_at', 'ASC')
      .getMany();

    const readDays = new Set<string>();
    for (const a of activities) {
      readDays.add(a.createdAt.toISOString().split('T')[0]);
    }
    const dates = Array.from(readDays).sort();

    let currentStreak = 0;
    let lastReadDate: Date | null = null;
    const now = new Date();
    const todayStr = now.toISOString().split('T')[0];
    const yesterdayStr = new Date(now.getTime() - 24 * 60 * 60 * 1000)
      .toISOString()
      .split('T')[0];

    for (const day of dates) {
      const date = new Date(day);
      if (lastReadDate) {
        const diffDays = Math.round(
          (date.getTime() - lastReadDate.getTime()) / (1000 * 60 * 60 * 24),
        );
        if (diffDays === 1) {
          currentStreak += 1;
        } else if (diffDays > 1) {
          currentStreak = 1;
        }
      } else {
        currentStreak = 1;
      }
      lastReadDate = date;
    }

    if (!readDays.has(todayStr) && !readDays.has(yesterdayStr)) {
      currentStreak = 0;
    }

    const last7Days: Array<{ day: string; date: string; read: boolean }> = [];
    for (let i = 6; i >= 0; i--) {
      const d = new Date(now.getTime() - i * 24 * 60 * 60 * 1000);
      const dayStr = d.toISOString().split('T')[0];
      const dayOfWeek = ['S', 'M', 'T', 'W', 'T', 'F', 'S'][d.getUTCDay()];
      last7Days.push({
        day: dayOfWeek,
        date: dayStr,
        read: readDays.has(dayStr),
      });
    }

    return {
      currentStreak,
      last7Days,
    };
  }

  async insertUserRead(userId: number, chapterNo: number, verseNo: number) {
    const existing = await this.userReadsRepository.findOne({
      where: { userId, chapter: chapterNo },
    });

    if (!existing) {
      const progress = calculateProgress(1, chapterNo);
      const newRecord = this.userReadsRepository.create({
        userId,
        chapter: chapterNo,
        verses: `${verseNo}`,
        progress,
      });

      return this.userReadsRepository.save(newRecord);
    }

    const { verses, progress, isNewVerse } = processVerses(
      existing.verses,
      verseNo,
      chapterNo,
    );

    if (!isNewVerse) return existing;

    const updatedRecord = this.userReadsRepository.create({
      id: existing.id, // Important: include the ID for updates
      userId: existing.userId, // Explicitly set userId
      chapter: chapterNo,
      verses,
      progress,
      createdAt: existing.createdAt, // Preserve timestamps
    });

    return this.userReadsRepository.save(updatedRecord);
  }

  async insertUserListen(userId: number, chapterNo: number, verseNo: number) {
    const existing = await this.userListensRepository.findOne({
      where: { userId, chapter: chapterNo },
    });

    if (!existing) {
      const progress = calculateProgress(1, chapterNo);
      const newRecord = this.userListensRepository.create({
        userId,
        chapter: chapterNo,
        verses: `${verseNo}`,
        progress,
      });
      return this.userListensRepository.save(newRecord);
    }

    const { verses, progress, isNewVerse } = processVerses(
      existing.verses,
      verseNo,
      chapterNo,
    );

    if (!isNewVerse) return existing;

    const updatedRecord = this.userListensRepository.create({
      ...existing,
      verses,
      progress,
    });

    return this.userListensRepository.save(updatedRecord);
  }

  async userReads(userId: number): Promise<UserReadsEntity[]> {
    const userReads = await this.userReadsRepository.find({
      where: { userId: userId },
    });

    return userReads;
  }

  async userListens(userId: number): Promise<UserListensEntity[]> {
    const userListens = await this.userListensRepository.find({
      where: { userId: userId },
    });

    return userListens;
  }
}
