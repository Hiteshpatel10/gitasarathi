import {
  Body,
  Controller,
  Get,
  Post,
  Request,
  UseGuards,
} from '@nestjs/common';
import { GitaService } from './gita.service';
import { VerseExplanationDto } from './dto/verse-explanation.dto';
import { Claims } from 'src/auth/entity/claims.interface';
import { UserService } from 'src/user/user.service';
import {
  applyUserListenProgress,
  applyUserReadProgress,
} from 'src/user/util/read-progress';
import { JwtAuthGuard } from 'src/auth/guards/jwt-auth.guard';

@Controller()
export class GitaController {
  constructor(
    private readonly gitaService: GitaService,
    private readonly userService: UserService,
  ) {}

  @Get('chapters')
  async getChapters() {
    const chapters = await this.gitaService.getChapters();
    return {
      status: 1,
      message: 'success',
      result: chapters,
    };
  }

  @UseGuards(JwtAuthGuard)
  @Get('chaptersAndVerses')
  async getChaptersAndVerses(@Request() req: Request & { user?: Claims }) {
    const chaptersAndVerse = await this.gitaService.getChapters({
      includeRelations: true,
    });

    const userId = req.user?.user_id;

    if (userId == null) {
      return {
        userId: userId ?? '--',
        status: 1,
        message: 'success',
        result: chaptersAndVerse,
      };
    }
    // Fetch both userReads and userListens in parallel
    const [userReads, userListens] = await Promise.all([
      this.userService.userReads(userId),
      this.userService.userListens(userId),
    ]);

    applyUserReadProgress(chaptersAndVerse, userReads);
    applyUserListenProgress(chaptersAndVerse, userListens);

    return {
      status: 1,
      message: 'skfhksfks',
      result: chaptersAndVerse,
      listen: userListens,
    };
  }

  @UseGuards(JwtAuthGuard)
  @Post('verseExplanation')
  async verseExplanation(
    @Body() verseExplanationDto: VerseExplanationDto,
    @Request() req: Request & { user?: Claims },
  ) {
    const chaptersAndVerse = await this.gitaService.getVerseExplanation({
      commentaryAuthorID: verseExplanationDto.commentaryAuthorId,
      translationAuthorID: verseExplanationDto.translationAuthorId,
      verseId: verseExplanationDto.verseId,
      userID: req.user?.user_id,
    });

    return {
      status: 1,
      message: 'success',
      result: chaptersAndVerse,
    };
  }

  @Get('languageAndAuthors')
  async languageAndAuthors() {
    const langAndAuth = await this.gitaService.getLanguageAndAuthors({
      includeRelations: true,
    });

    return {
      status: 1,
      message: 'success',
      result: langAndAuth,
    };
  }
}
