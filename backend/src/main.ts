import { NestFactory, Reflector } from '@nestjs/core';
import { AppModule } from './app.module';
import { CallHandler, ClassSerializerInterceptor, ExecutionContext, Injectable, NestInterceptor, ValidationPipe } from '@nestjs/common';
import { map, Observable } from 'rxjs';
import snakecaseKeys from 'snakecase-keys';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.useGlobalInterceptors(new ClassSerializerInterceptor(app.get(Reflector)));
  // app.useGlobalInterceptors(new SnakeCaseInterceptor());
  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
      whitelist: false,
      forbidNonWhitelisted: false,
    }),
  );
  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();


// interceptors/snake-case.interceptor.ts
// import {
//   Injectable,
//   NestInterceptor,
//   ExecutionContext,
//   CallHandler,
// } from '@nestjs/common';
// import { Observable } from 'rxjs';
// import { map } from 'rxjs/operators';
// import snakecaseKeys from 'snakecase-keys';

@Injectable()
export class SnakeCaseInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(
      map((data) => snakecaseKeys(data, { deep: true })),
    );
  }
}
