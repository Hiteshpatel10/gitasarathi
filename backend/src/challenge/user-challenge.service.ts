import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ChallengeEntity } from './entities/challenges.entity';
import { Repository } from 'typeorm';
import { UserChallengeEntity } from './entities/user-challenge.entity';

@Injectable()
export class UserChallengeService {
  constructor(
    @InjectRepository(ChallengeEntity)
    private readonly challengeRepository: Repository<ChallengeEntity>,

    @InjectRepository(UserChallengeEntity)
    private readonly userChallengeRepository: Repository<UserChallengeEntity>,
  ) {}

  async startUserChallenge({
    userId,
    challengeId,
  }: {
    userId: number;
    challengeId: number;
  }): Promise<UserChallengeEntity> {
    // 1. Check if user already has an active challenge
    const existingChallenge = await this.userChallengeRepository.findOne({
      where: { userId, status: 'active' },
    });

    if (existingChallenge) {
      throw new BadRequestException('User already has an active challenge');
    }

    // 2. Find the challenge
    const challenge = await this.challengeRepository.findOne({
      where: { id: challengeId },
    });

    if (!challenge) {
      throw new NotFoundException(`Challenge with ID ${challengeId} not found`);
    }

    // 3. Calculate start and end dates
    const startDate = new Date();
    const endDate = new Date();

    const daysRequired = Number(challenge.daysRequired); 
    const flexibleDays = Number(challenge.flexibleDays);
    endDate.setDate(
      startDate.getDate() + daysRequired + flexibleDays - 1,
    );

    // 4. Create new UserChallengeEntity
    const userChallenge = this.userChallengeRepository.create({
      userId,
      challengeId: challenge.id,
      startDate,
      endDate,
      status: 'active',
    });

    // 5. Save it
    return await this.userChallengeRepository.save(userChallenge);
  }

  async updateChallengeStatus({
    userId,
    id,
    newStatus,
  }: {
    userId: number;
    id: number;
    newStatus: 'active' | 'completed' | 'failed' | 'stopped';
  }): Promise<UserChallengeEntity> {
    // ✅ 1. Validate status
    const validStatuses = ['active', 'completed', 'failed', 'stopped'];
    if (!validStatuses.includes(newStatus)) {
      throw new BadRequestException(`Invalid status: ${newStatus}`);
    }

    // ✅ 2. Find the challenge for this user
    const userChallenge = await this.userChallengeRepository.findOne({
      where: { userId, id },
    });

    if (!userChallenge) {
      throw new NotFoundException(
        `Challenge with ID ${id} not found for user ${userId}`,
      );
    }

    // ✅ 3. Validate business logic
    if (userChallenge.status !== 'active' && newStatus === 'stopped') {
      throw new BadRequestException('Only active challenges can be stopped');
    }

    if (userChallenge.status === newStatus) {
      return userChallenge; // no update needed
    }

    // ✅ 4. Update status
    userChallenge.status = newStatus;
    return await this.userChallengeRepository.save(userChallenge);
  }

  async getUserChallengesByStatus({
    userId,
    status,
  }: {
    userId?: number;
    status?: 'active' | 'completed' | 'failed' | 'stopped';
  }): Promise<UserChallengeEntity[]> {
    const query = this.userChallengeRepository
      .createQueryBuilder('userChallenge')
      .leftJoinAndSelect('userChallenge.challenge', 'challenge');

    if (userId) {
      query.andWhere('userChallenge.userId = :userId', { userId });
    }

    if (status) {
      const validStatuses = ['active', 'completed', 'failed', 'stopped'];
      if (!validStatuses.includes(status)) {
        throw new BadRequestException(`Invalid status: ${status}`);
      }
      query.andWhere('userChallenge.status = :status', { status });
    }

    return await query.getMany();
  }

  async updateChallengeDetails(
    userId: number,
    id: number,
    daysCompleted: number,
    missedDays: number,
    status: 'active' | 'completed' | 'failed' | 'stopped',
  ): Promise<UserChallengeEntity> {
    // ✅ 1. Validate status
    const validStatuses = ['active', 'completed', 'failed', 'stopped'];
    if (!validStatuses.includes(status)) {
      throw new BadRequestException(`Invalid status: ${status}`);
    }

    // ✅ 2. Find the user challenge
    const userChallenge = await this.userChallengeRepository.findOne({
      where: { userId, id },
    });

    if (!userChallenge) {
      throw new NotFoundException(
        `Challenge with ID ${id} not found for user ${userId}`,
      );
    }

    // ✅ 3. Update fields
    userChallenge.daysCompleted = daysCompleted;
    userChallenge.missedDays = missedDays;
    userChallenge.status = status;

    if (status === 'completed') {
      userChallenge.completedAt = new Date();
    }

    // ✅ 4. Save
    return await this.userChallengeRepository.save(userChallenge);
  }
}
