import { UserActivityEntity } from '../entities/user-activity.entity';

export interface ReadCalendarResult {
  readCalendar: Record<string, boolean>;
  currentStreak: number;
  maxStreak: number;
  verseRead: number;
}

export function calculateReadCalendar({
  activities,
  year,
  month,
}: {
  activities: UserActivityEntity[];
  year: number;
  month: number;
}): ReadCalendarResult {
  const now = new Date();

  // 1. Start & end of month
  const startOfMonth = new Date(Date.UTC(year, month - 1, 1));
  const endOfMonth = new Date(Date.UTC(year, month, 0, 23, 59, 59));
  const lastDay = now < endOfMonth ? now : endOfMonth;

  // 2. Initialize calendar
  const readCalendar: Record<string, boolean> = {};
  for (let d = new Date(startOfMonth); d <= lastDay; d.setUTCDate(d.getUTCDate() + 1)) {
    const key = d.toISOString().split('T')[0];
    readCalendar[key] = false;
  }

  // 3. Mark days with activity
  for (const activity of activities) {
    const key = activity.createdAt.toISOString().split('T')[0];
    if (readCalendar[key] !== undefined) {
      readCalendar[key] = true;
    }
  }

  // 4. Calculate streaks
  const { currentStreak, maxStreak } = calculateStreaks(readCalendar);

  // 5. Count total verse reads
  const verseRead = activities.length;

  return { readCalendar, currentStreak, maxStreak, verseRead };
}

// Helper function: calculate streaks from readCalendar
function calculateStreaks(readCalendar: Record<string, boolean>): {
  currentStreak: number;
  maxStreak: number;
} {
  const dates = Object.keys(readCalendar).sort(); // Ascending
  let currentStreak = 0;
  let maxStreak = 0;
  let lastReadDate: Date | null = null;

  for (const day of dates) {
    if (readCalendar[day]) {
      const date = new Date(day);
      if (lastReadDate) {
        const diffDays = (date.getTime() - lastReadDate.getTime()) / (1000 * 60 * 60 * 24);
        currentStreak = diffDays === 1 ? currentStreak + 1 : 1;
      } else {
        currentStreak = 1;
      }
      lastReadDate = date;
      maxStreak = Math.max(maxStreak, currentStreak);
    } else {
      currentStreak = 0;
      lastReadDate = null;
    }
  }

  return { currentStreak, maxStreak };
}
