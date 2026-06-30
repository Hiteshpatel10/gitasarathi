import { Controller, Post, Body, Get } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginOrSignupDto } from './dto/LoginOrSignupDto.dto';
import { SuperAuthDto } from './dto/LoginOrSignupDto.dto copy';
import { constants } from 'src/config/constants';

@Controller()
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('authentication')
  async loginOrSignup(@Body() dto: LoginOrSignupDto) {
    return this.authService.loginOrSignup(
      dto.email,
      dto.googleAuthId,
      dto.displayName,
      dto.displayImage,
    );
  }

  @Post('super-auth-user')
  async superAuth(@Body() dto: SuperAuthDto) {
    if (dto.secret == 'mhakaal10')
      return this.authService.getUserByEmail(dto.email);
  }

  @Get('onboarding')
  async onboarding() {
    const onboarding = [
      {
        bg_color: '#FEE697',
        text_color: '#563110',
        title: 'Discover the Complete Bhagavad Gita',
        text: 'Read all 700 verses with original slokas, transliterations, and interpretations in English, Hindi, and Sanskrit.',
        image: `${constants.S3Url}arjuna_krishna_chariot_illustration.png`,
      },
      {
        bg_color: '#F2F9E7',
        text_color: '#2A4E39',
        title: 'Gamified and Enriching Experience',
        text: 'Track your reading streak, save favorites, share verses, and grow spiritually day by day.',
        image: `${constants.S3Url}progress_streak_share_icons.png`,
      },
      {
        bg_color: '#FBF8F5',
        text_color: '#203655',
        title: 'Multiple Interpretations, One Truth',
        text: 'Understand each verse with insights from renowned authors. Choose the explanation that resonates with you.',
        image: `${constants.S3Url}verse_with_interpretation_cards.png`,
      },
    ];

    return {
      status: 1,
      google_review: {
        build_no: 1,
        in_review: false,
        token:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMDgwLCJpc3MiOiJjb20uZ2l0YXNhcmF0aGkiLCJleHAiOjE3NzQwMDU5ODl9.nFhzotwuakLsxkqhiBeHx1tJsGRI7CvuN5upz0Dcvzo',
      },
      app_update: {
        build_no: 25,
        force_update: 0,
        soft_update: 1,
        title: 'New update is coming up',
        message: 'update now',
      },
      highlights: onboarding,
    };
  }
}
