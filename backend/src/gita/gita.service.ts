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

    if (options?.includeRelations) {
      chapters.forEach(chapter => {
        if (chapter.verses) {
          chapter.verses.forEach(verse => this.attachAudioLinks(verse));
        }
      });
    }

    return chapters;

    
  }

  async getVerseExplanation({
    verseId,
    commentaryAuthorID,
    translationAuthorID,
    userID,
    allAuthors = false,
  }: {
    verseId: number;
    commentaryAuthorID?: number;
    translationAuthorID?: number;
    userID?: number;
    allAuthors?: boolean;
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

    // When allAuthors is true, return everything — client will filter locally
    if (!allAuthors) {
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

      }
    }

    this.attachAudioLinks(verse);

    return verse;
  }

  async getVerseOfTheDay({
    commentaryAuthorID,
    translationAuthorID,
    userID,
    allAuthors = false,
  }: {
    commentaryAuthorID?: number;
    translationAuthorID?: number;
    userID?: number;
    allAuthors?: boolean;
  }): Promise<{ verse: VerseEntity | null; verseVersion: number }> {
    const totalVerses = await this.verseRepository.count();

    const now = new Date();
    const epoch = new Date(1970, 0, 1);
    const daysSinceEpoch = Math.floor(
      (now.getTime() - epoch.getTime()) / (1000 * 60 * 60 * 24),
    );

    if (totalVerses === 0) return { verse: null, verseVersion: daysSinceEpoch };

    const offset = daysSinceEpoch % totalVerses;

    const verseIdObjs = await this.verseRepository.find({
      select: ['id'],
      order: { id: 'ASC' },
      skip: offset,
      take: 1,
    });

    if (verseIdObjs.length === 0) return { verse: null, verseVersion: daysSinceEpoch };
    const verseIdObj = verseIdObjs[0];

    const verse = await this.getVerseExplanation({
      verseId: verseIdObj.id,
      commentaryAuthorID,
      translationAuthorID,
      userID,
      allAuthors,
    });

    return { verse, verseVersion: daysSinceEpoch };
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

  private attachAudioLinks(verse: VerseEntity) {
    if (!verse || !verse.chapterNumber || !verse.verseNumber) return;

    const paddedChapter = String(verse.chapterNumber).padStart(2, '0');
    const paddedVerse = String(verse.verseNumber).padStart(2, '0');
    
    const baseUrl = `${constants.S3Url}slokas/chapter_${paddedChapter}/verse_${paddedVerse}`;

    verse.audioLinks = {
      mool_female: `${baseUrl}/mool_female.mp3`,
      mool_male: `${baseUrl}/mool_male.mp3`,
      english_female_translation: `${baseUrl}/english_female_translation.mp3`,
      hindi_female_translation: `${baseUrl}/hindi_female_translation.mp3`,
    };
  }
}
