import {
  Controller,
  Get,
  UseGuards,
  Request,
  Body,
  Delete,
  Post,
} from '@nestjs/common';
import { FavouriteService } from './favourite.service';
import { JwtAuthGuard } from 'src/auth/guards/jwt-auth.guard';
import { Claims } from 'src/auth/entity/claims.interface';
import { FavouriteRemoveDto } from './dto/favourite-remove.dto';
import { FavouriteAddDto } from './dto/favourite-add.dto';

@Controller('favorite')
export class FavouriteController {
  constructor(private readonly favouriteService: FavouriteService) {}

  @UseGuards(JwtAuthGuard)
  @Get('list')
  async languageAndAuthors(@Request() req: Request & { user: Claims }) {
    const userId = req.user.user_id;

    const favorites = await this.favouriteService.getFavorites({ userId });

    return {
      status: 1,
      message: 'success',
      favorites: favorites,
    };
  }

  @UseGuards(JwtAuthGuard)
  @Post('add')
  async favouriteAdd(
    @Request() req: Request & { user: Claims },
    @Body() favouriteAddRemoveDto: FavouriteAddDto,
  ) {
    try {
      const userId = req.user.user_id;

      const addFavorite = await this.favouriteService.addFavorite({
        userId,
        verseId: favouriteAddRemoveDto.verseId,
        listId: favouriteAddRemoveDto.listId,
      });

      return {
        status: 1,
        message: 'success',
        result: addFavorite,
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
  @Delete('remove')
  async favouriteremove(
    @Request() req: Request & { user: Claims },
    @Body() body: FavouriteAddDto,
  ) {
    try {
      const userId = req.user.user_id;

      const removeFavorite = await this.favouriteService.removeFavorite({
        userId,
        verseId: body.verseId,
        listId: body.listId,
      });

      return {
        status: 1,
        message: 'success',
        result: removeFavorite,
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
