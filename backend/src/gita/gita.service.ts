import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm/dist/common';
import { ChapterEntity } from './entities/chapter.entity';
import { Repository, SelectQueryBuilder } from 'typeorm';
import { constants } from 'src/config/constants';
import { VerseEntity } from './entities/verse.entity';
import { LanguageEntity } from './entities/language.entity';

@Injectable()
export class GitaService {
  constructor(
    @InjectRepository(ChapterEntity)
    private readonly chapterRepository: Repository<ChapterEntity>,
    @InjectRepository(VerseEntity)
    private readonly verseRepository: Repository<VerseEntity>,
    @InjectRepository(LanguageEntity)
    private readonly languageRepository: Repository<LanguageEntity>,
  ) {}

  async getChapters(options?: {
    includeRelations?: boolean;
  }): Promise<ChapterEntity[]> {
    const chapters = await this.chapterRepository.find({
      order: { id: 'ASC' },
      relations: options?.includeRelations ? ['verses'] : [],
    });

    return chapters;

    
  }

  async getVerseExplanation({
    verseId,
    commentaryAuthorID,
    translationAuthorID,
    userID,
  }: {
    verseId: number;
    commentaryAuthorID: number;
    translationAuthorID: number;
    userID?: number;
  }): Promise<VerseEntity | null> {
    // Build the base query with relations
    const queryBuilder = this.verseRepository
      .createQueryBuilder('verse')
      .leftJoinAndSelect('verse.commentaries', 'commentary')
      .leftJoinAndSelect('verse.translations', 'translation')
      .where('verse.id = :verseId', { verseId });

    // Add favorites relation only if userID is provided
    if (userID) {
      queryBuilder.leftJoinAndSelect(
        'verse.favorites',
        'favorite',
        'favorite.userId = :userID',
        { userID },
      );
    }

    const verse = await queryBuilder.getOne();

    if (!verse) {
      return null;
    }

    // Filter to get the preferred commentary
    if (verse.commentaries?.length > 0) {
      const preferredCommentary =
        verse.commentaries.find(
          (commentary) => commentary.authorId === commentaryAuthorID,
        ) || verse.commentaries[0];

      verse.commentaries = [preferredCommentary];
    }

    // Filter to get the preferred translation
    if (verse.translations?.length > 0) {
      const preferredTranslation =
        verse.translations.find(
          (translation) => translation.authorId === translationAuthorID,
        ) || verse.translations[0];

      verse.translations = [preferredTranslation];
    }

    return verse;
  }

  async getLanguageAndAuthors(options?: {
    includeRelations?: boolean;
  }): Promise<LanguageEntity[]> {
    const languageAndAuthors = await this.languageRepository.find({
      order: { id: 'ASC' },
      relations: options?.includeRelations ? ['authors'] : [],
    });

    return languageAndAuthors;
  }
}
