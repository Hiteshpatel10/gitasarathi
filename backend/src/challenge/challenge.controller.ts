import { Controller, Get, Param } from '@nestjs/common';
import { ChallengeService } from './challenge.service';

@Controller('challenges')
export class ChallengeController {
  constructor(private readonly challengeService: ChallengeService) {}

  @Get('/')
  async allChallenges() {
    const challenges = await this.challengeService.fetchChallenges();

    return {
      status: 1,
      message: 'success',
      challenges: challenges,
    };
  }

  @Get('/:id')
  async challengeById(@Param('id') id: string) {
    const challenge = await this.challengeService.getChallengeById(+id); // convert to number

    return {
      status: 1,
      message: 'success',
      challenge,
    };
  }
}
