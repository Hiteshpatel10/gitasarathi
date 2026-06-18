import { UserActivityEntity } from 'src/user/entities/user-activity.entity';
import { ChallengeEntity } from '../entities/challenges.entity';
import { UserChallengeEntity } from '../entities/user-challenge.entity';

export function updateChallengeProgress(
  userChallenge: UserChallengeEntity & { challenge: ChallengeEntity },
  userActivity: UserActivityEntity[],
): {
  updatedChallenge: UserChallengeEntity;
  timeline: Record<string, string>;
} {
  const activityMap: Record<string, boolean> = {};
  userActivity.forEach((entry) => {
    const dateStr = entry.createdAt.toLocaleDateString('en-CA'); // yyyy-MM-dd
    activityMap[dateStr] = true;
  });

  const challengeTimeline: Record<string, string> = {};
  const todayStr = new Date().toLocaleDateString('en-CA');

  let completed = 0;
  let missed = 0;

  let d = new Date(userChallenge.startDate);
  const end = new Date(userChallenge.endDate);

  while (d <= end) {
    const dateStr = d.toLocaleDateString('en-CA');

    if (dateStr === todayStr) {
      if (activityMap[dateStr]) {
        challengeTimeline[dateStr] = 'completed';
        completed++;
      } else {
        challengeTimeline[dateStr] = 'ongoing';
      }
    } else if (d > new Date(todayStr)) {
      challengeTimeline[dateStr] = 'upcoming';
    } else {
      if (activityMap[dateStr]) {
        challengeTimeline[dateStr] = 'completed';
        completed++;
      } else {
        challengeTimeline[dateStr] = 'missed';
        missed++;
      }
    }

    d.setDate(d.getDate() + 1);
  }

  // Update stats
  userChallenge.daysCompleted = completed;
  userChallenge.missedDays = missed;

  // Determine status
  let challengeStatus: 'active' | 'completed' | 'failed' | 'stopped' = 'active';

  if (missed > userChallenge.challenge.flexibleDays) {
    challengeStatus = 'failed';
  }

  if (new Date(todayStr) > end && completed < userChallenge.challenge.daysRequired) {
    challengeStatus = 'failed';
  }

  if (
    challengeStatus !== 'failed' &&
    completed >= userChallenge.challenge.daysRequired &&
    new Date(todayStr) <= end
  ) {
    challengeStatus = 'completed';
  }

  userChallenge.status = challengeStatus;

  return {
    updatedChallenge: userChallenge,
    timeline: challengeTimeline,
  };
}
