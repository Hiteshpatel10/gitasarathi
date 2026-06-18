import { Module } from '@nestjs/common';
import { GitaService } from './gita.service';
import { GitaController } from './gita.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ChapterEntity } from './entities/chapter.entity';
import { VerseEntity } from './entities/verse.entity';
import { VerseCommentaryEntity } from './entities/verse-commentary.entity';
import { VerseTranslationEntity } from './entities/verse-translation.entity';
import { LanguageEntity } from './entities/language.entity';
import { AuthorEntity } from './entities/author.entity';
import { UserModule } from 'src/user/user.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      ChapterEntity,
      VerseEntity,
      VerseCommentaryEntity,
      VerseTranslationEntity,
      LanguageEntity,
      AuthorEntity,
    ]),
    UserModule,
  ],
  providers: [GitaService],
  controllers: [GitaController],
})
export class GitaModule {}
