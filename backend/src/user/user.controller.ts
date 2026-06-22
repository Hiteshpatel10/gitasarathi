import {
  Body,
  Controller,
  Get,
  Post,
  Put,
  Request,
  UseGuards,
} from '@nestjs/common';
import { UserService } from './user.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { ChapterAndVerseDto } from './dto/chapter-and-verse.dto';
import { UserActivityDto } from './dto/user-activity.dto';
import { Claims } from 'src/auth/entity/claims.interface';
import { FcmTokenDto } from './dto/fcm-token.dto';
import { MonthlyUserReadDto } from './dto/monthly-user-read.dto';
import { calculateReadCalendar } from './util/user-activity.util';

@Controller()
export class UserController {
  constructor(private readonly userService: UserService) {}

  @UseGuards(JwtAuthGuard)
  @Get('user')
  async getUser(@Request() req: Request & { user: Claims }) {
    try {
      const userId = req.user.user_id;

      const user = await this.userService.getUserById(userId);
      return {
        result: user,
        status: 1,
      };
    } catch (error) {
      return {
        result: null,
        message: 'user not found',
        error: error.message,
        status: 0,
      };
    }
  }

  @UseGuards(JwtAuthGuard)
  @Get('progress')
  async getUserProgress(@Request() req: Request & { user: Claims }) {
    try {
      const userId = req.user.user_id;

      const [userReads, userListens] = await Promise.all([
        this.userService.userReads(userId),
        this.userService.userListens(userId),
      ]);

      return {
        result: {
          reads: userReads,
          listens: userListens,
        },
        status: 1,
        message: 'success',
      };
    } catch (error) {
      return {
        result: null,
        message: 'failed to get progress',
        error: error.message,
        status: 0,
      };
    }
  }

  @UseGuards(JwtAuthGuard)
  @Put('updateFcmToken')
  async updateFCMToken(
    @Request() req: Request & { user: Claims },
    @Body() fcmTokenDto: FcmTokenDto,
  ) {
    try {
      const userId = req.user.user_id;

      await this.userService.updateFCMToken({
        userId,
        fcmToken: fcmTokenDto.fcmToken,
      });

      return {
        status: 1,
      };
    } catch (error) {
      return {
        message: 'user not found',
        error: error.message,
        status: 0,
      };
    }
  }

  @UseGuards(JwtAuthGuard)
  @Post('insertUserActivity')
  async insertUserActivity(
    @Body() userActivityDto: UserActivityDto,
    @Request() req: Request & { user: Claims },
  ) {
    try {
      const userId = req.user.user_id;

      await this.userService.insertUserActivity({
        userId,
        chapterNo: userActivityDto.chapterNo,
        verseNo: userActivityDto.verseNo,
        activity: userActivityDto.activity,
        sessionId: userActivityDto.sessionId,
      });

      return {
        status: 1,
      };
    } catch (error) {
      return {
        error: error.message,
        status: 0,
      };
    }
  }

  @UseGuards(JwtAuthGuard)
  @Post('monthlyUserRead')
  async monthlyUserRead(
    @Body() monthlyUserReadDto: MonthlyUserReadDto,
    @Request() req: Request & { user: Claims },
  ) {
    try {
      const userId = req.user.user_id;

      const readActivities = await this.userService.monthlyUserReadActivity({
        userId,
        month: monthlyUserReadDto.month,
        year: monthlyUserReadDto.year,
      });

      const readCalendar = calculateReadCalendar({
        activities: readActivities,
        month: monthlyUserReadDto.month,
        year: monthlyUserReadDto.year,
      });

      return {
        streak: readCalendar.currentStreak,
        max_streak: readCalendar.maxStreak,
        verse_read: readActivities.length,
        read_calendar: readCalendar.readCalendar,
        user_activity: readActivities,
        status: 1,
      };
    } catch (error) {
      return {
        error: error.message,
        status: 0,
      };
    }
  }

  @UseGuards(JwtAuthGuard)
  @Post('insertUserRead')
  async updateUserRead(
    @Body() ChapterAndVerseDto: ChapterAndVerseDto,
    @Request() req: Request & { user: Claims },
  ) {
    try {
      const userId = req.user.user_id;

      await this.userService.insertUserRead(
        userId,
        ChapterAndVerseDto.chapterNo,
        ChapterAndVerseDto.verseNo,
      );

      return {
        status: 1,
      };
    } catch (error) {
      return {
        error: error.message,
        status: 0,
      };
    }
  }

  @UseGuards(JwtAuthGuard)
  @Post('insertUserListen')
  async insertUserListen(
    @Body() ChapterAndVerseDto: ChapterAndVerseDto,
    @Request() req: Request & { user: Claims},
  ) {
    try {
      const userId = req.user.user_id;

      await this.userService.insertUserListen(
        userId,
        ChapterAndVerseDto.chapterNo,
        ChapterAndVerseDto.verseNo,
      );

      return {
        status: 1,
      };
    } catch (error) {
      return {
        error: error.message,
        status: 0,
      };
    }
  }
}
