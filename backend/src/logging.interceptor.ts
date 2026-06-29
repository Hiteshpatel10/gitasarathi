import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable, tap } from 'rxjs';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const req = context.switchToHttp().getRequest();
    const now = Date.now();

    console.log(`Incoming: ${req.method} ${req.url}`);

    return next.handle().pipe(
      tap(() =>
        console.log(
          `Completed: ${req.method} ${req.url} - ${Date.now() - now}ms`,
        ),
      ),
    );
  }
}
