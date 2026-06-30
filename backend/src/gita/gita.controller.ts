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
import { JwtAuthGuard } from 'src/auth/guards/jwt-auth.guard';

@Controller()
export class GitaController {
  constructor(private readonly gitaService: GitaService) {}

  @Get('chapters')
  async getChapters() {
    const chapters = await this.gitaService.getChapters();
    return {
      status: 1,
      message: 'success',
      result: chapters,
    };
  }

  @Get('chapters-and-verses')
  async getChaptersAndVerses() {
    const chaptersAndVerse = await this.gitaService.getChapters({
      includeRelations: true,
    });

    return {
      status: 1,
      message: 'success',
      result: chaptersAndVerse,
    };
  }

  @UseGuards(JwtAuthGuard)
  @Post('verse-of-the-day')
  async getVerseOfTheDay(
    @Body() verseExplanationDto: VerseExplanationDto,
    @Request() req: Request & { user?: Claims },
  ) {
    const verse = await this.gitaService.getVerseOfTheDay({
      commentaryAuthorID: verseExplanationDto.commentaryAuthorId,
      translationAuthorID: verseExplanationDto.translationAuthorId,
      userID: req.user?.user_id,
      allAuthors: verseExplanationDto.allAuthors,
    });

    return {
      status: 1,
      message: 'success',
      result: verse,
    };
  }

  @UseGuards(JwtAuthGuard)
  @Post('verse-explanation')
  async verseExplanation(
    @Body() verseExplanationDto: VerseExplanationDto,
    @Request() req: Request & { user?: Claims },
  ) {
    const chaptersAndVerse = await this.gitaService.getVerseExplanation({
      commentaryAuthorID: verseExplanationDto.commentaryAuthorId,
      translationAuthorID: verseExplanationDto.translationAuthorId,
      verseId: verseExplanationDto.verseId,
      userID: req.user?.user_id,
      allAuthors: verseExplanationDto.allAuthors,
    });

    return {
      status: 1,
      message: 'success',
      result: chaptersAndVerse,
    };
  }

  @Get('language-and-authors')
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
