import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserChallengeEntity } from './entities/user-challenge.entity';
import { ChallengeEntity } from './entities/challenges.entity';

@Injectable()
export class ChallengeService {
  constructor(
    @InjectRepository(ChallengeEntity)
    private readonly challengeRepository: Repository<ChallengeEntity>,


  ) {}

  async fetchChallenges(): Promise<ChallengeEntity[]> {
    try {
      return await this.challengeRepository.find();
    } catch (error) {
      throw new Error(`Failed to fetch challenges: ${error.message}`);
    }
  }

  // Equivalent of GetChallengeByID
  async getChallengeById(challengeId: number): Promise<ChallengeEntity> {
    try {
      const challenge = await this.challengeRepository.findOne({
        where: { id: challengeId },
      });

      if (!challenge) {
        throw new NotFoundException(
          `Challenge with ID ${challengeId} not found`,
        );
      }

      return challenge;
    } catch (error) {
      throw new Error(`Error fetching challenge: ${error.message}`);
    }
  }
}
