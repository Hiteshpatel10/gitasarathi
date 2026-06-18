import {
  Body,
  Controller,
  Get,
  Post,
  Request,
  UseGuards,
} from '@nestjs/common';
import { UserChallengeService } from './user-challenge.service';
import { JwtAuthGuard } from 'src/auth/guards/jwt-auth.guard';
import { Claims } from 'src/auth/entity/claims.interface';
import { StopChallengeDto } from './dto/stop-challenge.dto';
import { StartChallengeDto } from './dto/start-challenge.dto';
import { ChallengeService } from './challenge.service';
import { updateChallengeProgress } from './util/challenge.util';
import { UserService } from 'src/user/user.service';

@Controller(['userChallenges', 'user-challenges'])
export class UserChallengeController {
  constructor(
    private readonly userChallengeService: UserChallengeService,
    private readonly challengeService: ChallengeService,
    private readonly userService: UserService,
  ) {}

  @UseGuards(JwtAuthGuard)
  @Get('/')
  async getUserChallenge(@Request() req: Request & { user: Claims }) {
    try {
      const userId = req.user.user_id;

      const challenge =
        await this.userChallengeService.getUserChallengesByStatus({
          userId,
          status: 'active',
        });

      return {
        status: 1,
        message: 'success',
        challenge: challenge,
      };
    } catch (error) {
      return {
        status: 0,
        message: 'failed',
        error: error.message,
      };
    }
  }

  @UseGuards(JwtAuthGuard)
  @Post('/start')
  async startChallenge(
    @Request() req: Request & { user: Claims },
    @Body() body: StartChallengeDto,
  ) {
    try {
      const userId = req.user.user_id;

      const challenge = await this.userChallengeService.startUserChallenge({
        userId,
        challengeId: body.challengeId,
      });

      return {
        status: 1,
        message: 'success',
        challenge: challenge,
      };
    } catch (error) {
      return {
        status: 0,
        message: 'failed',
        error: error.message,
      };
    }
  }

  @UseGuards(JwtAuthGuard)
  @Post('/stop')
  async stopChallenge(
    @Request() req: Request & { user: Claims },
    @Body() body: StopChallengeDto,
  ) {
    try {
      const userId = req.user.user_id;

      const challenge = await this.userChallengeService.updateChallengeStatus({
        userId,
        id: body.userChallengeId,
        newStatus: 'stopped',
      });

      return {
        status: 1,
        message: 'success',
        challenge: challenge,
      };
    } catch (error) {
      return {
        status: 0,
        message: 'failed',
        error: error.message,
      };
    }
  }

  @UseGuards(JwtAuthGuard)
  @Get('/combined')
  async userChallengesAndChallenges(
    @Request() req: Request & { user: Claims },
  ) {
    try {
      const userId = req.user.user_id;

      const challenges = await this.challengeService.fetchChallenges();
      const userChallenges =
        await this.userChallengeService.getUserChallengesByStatus({
          userId,
          status: 'active',
        });

      for (let i = 0; i < userChallenges.length; i++) {
        const userChallenge = userChallenges[i];

        try {
          const activity = await this.userService.userReadActivityByDateRange({
            userId,
            startDate: userChallenge.startDate,
            endDate: userChallenge.endDate,
          });

          const { updatedChallenge, timeline } = updateChallengeProgress(
            userChallenge,
            activity,
          );

          if (userChallenge.daysCompleted < updatedChallenge.daysCompleted) {
            updatedChallenge.isTaskDoneNow = true;
          }

          userChallenges[i] = updatedChallenge;
          userChallenges[i].timeline = timeline;
        } catch (err) {
          continue;
        }
      }
      const isEnrolledInChallenge = userChallenges.length > 0;

      return {
        status: 1,
        message: 'success',
        enrolled_in_challenge: isEnrolledInChallenge,
        challenges: challenges,
        user_challenges: userChallenges,
      };
    } catch (error) {
      return {
        status: 0,
        message: 'failed',
        error: error.message,
      };
    }
  }
}
