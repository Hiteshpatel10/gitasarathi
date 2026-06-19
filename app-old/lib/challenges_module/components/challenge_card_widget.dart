import 'package:cached_network_image/cached_network_image.dart';
import 'package:chapter/challenges_module/model/user_challenge_and_challenges_model.dart';
import 'package:flutter/material.dart';

class ChallengeCardWidget extends StatelessWidget {
  const ChallengeCardWidget({
    super.key,
    required this.challenge,
    this.maxWidth,
    this.margin,
    required this.onTap,
  });

  final Challenge? challenge;
  final double? maxWidth;
  final EdgeInsets? margin;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? MediaQuery.of(context).size.width,
      ),
      margin: margin ?? const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                child: CachedNetworkImage(
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  imageUrl: challenge?.coverImage ?? '-',
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(54),
                  ),
                  child: CachedNetworkImage(
                    height: 36,
                    width: 36,
                    imageUrl: challenge?.icon ?? '-',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              challenge?.name ?? '-',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text("📅 ${challenge?.daysRequired} days    "),
                Text("➕ ${challenge?.flexibleDays} extra"),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onTap,
              child: const Text("Start"),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
