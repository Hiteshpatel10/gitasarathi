import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { Claims } from '../entity/claims.interface';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromExtractors([
        // 1️⃣ Standard Bearer token
        ExtractJwt.fromAuthHeaderAsBearerToken(),

        // 2️⃣ Fallback: raw token (old app)
        (req) => {
          const auth = req?.headers?.authorization;
          if (auth) {
            // If the token starts with "Bearer ", strip it, otherwise just return the token
            return auth.startsWith('Bearer ') ? auth.slice(7) : auth;
          }
          return null;
        },
      ]),
      secretOrKey: process.env.JWT_SECRET || '6c7f6dbff113bd78c7f0434950bac8cd390c97492a56fa1af8b502f7a33b80eb',
      ignoreExpiration: false,
    });
  }

  async validate(payload: Claims): Promise<Claims> {
    return payload;
  }
}
