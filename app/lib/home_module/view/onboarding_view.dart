import 'package:cached_network_image/cached_network_image.dart';
import 'package:chapter/components/app_error_widget.dart';
import 'package:chapter/home_module/cubit/onboarding_cubit.dart';
import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/utility/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  Color? bgColor;
  double _progressValue = 0;
  bool initCalled = false;
  late final PageController _pageController;

  void initOnboarding(OnboardingSuccessState state) {
    final highlights = state.onboarding.highlights;
    final len = highlights?.length ?? 0;

    if (len > 0) {
      _progressValue = 1 / len;
      final firstColor = hexToColor(highlights?[0].bgColor ?? '#FFFFFF');
      bgColor = firstColor;
    } else {
      _progressValue = 0.0;
      bgColor = Colors.white;
    }
  }

  @override
  void initState() {
    _pageController = PageController();
    BlocProvider.of<OnboardingCubit>(context).getOnboarding(checkUpdate: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          if (state is OnboardingSuccessState) {
            if (initCalled == false) {
              initCalled = true;
              initOnboarding(state);
            }
            return AnimatedContainer(
              duration: Durations.medium4,
              color: bgColor,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        GoRouter.of(context).pushReplacementNamed(AppRoutes.signIn.name);
                      },
                      child: const Text("SKIP"),
                    ),
                  ),
                  Flexible(
                    child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      itemCount: state.onboarding.highlights?.length ?? 0,
                      onPageChanged: (value) {
                        final highlights = state.onboarding.highlights;
                        final len = highlights?.length ?? 0;

                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                          final color = hexToColor(highlights?[value].bgColor ?? 'FFFFFF');

                          if (bgColor != color) {
                            if (len > 0) {
                              setState(() {
                                _progressValue = (value + 1) / len;
                                bgColor = hexToColor(highlights?[value].bgColor ?? '#FFFFFF');
                              });
                            } else {
                              setState(() {
                                _progressValue = 0.0;
                                bgColor = Colors.white;
                              });
                            }
                          }
                        });
                      },
                      itemBuilder: (context, index) {
                        final item = state.onboarding.highlights?[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const Spacer(),
                              CachedNetworkImage(
                                imageUrl: item?.image ?? '',
                                height: MediaQuery.of(context).size.height * 0.4,
                                fit: BoxFit.fitHeight,
                                errorWidget: (context, url, error) {
                                  return Image.asset("assets/rasters/logo.png",
                                      height: 200, width: 200);
                                },
                                placeholder: (context, url) {
                                  return Image.asset("assets/rasters/logo.png",
                                      height: 200, width: 200);
                                },
                              ),
                              const Spacer(),
                              Text(
                                item?.title ?? '-',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: hexToColor(item?.textColor ?? 'FFFFFF'),
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item?.text ?? '-',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: hexToColor(item?.textColor ?? 'FFFFFF')),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: _progressValue),
                        duration: const Duration(milliseconds: 400),
                        builder: (context, value, child) {
                          return SizedBox(
                            width: 58,
                            height: 58,
                            child: CircularProgressIndicator(
                              value: value,
                              strokeWidth: 6,
                              backgroundColor: CoreColors.earlyDawn,
                              valueColor: const AlwaysStoppedAnimation<Color>(CoreColors.brown),
                            ),
                          );
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(52, 52),
                          shape: const CircleBorder(),
                          elevation: 4,
                        ),
                        onPressed: () {
                          final len = state.onboarding.highlights?.length ?? 0;
                          if (len == (_pageController.page?.toInt() ?? 0) + 1) {
                            GoRouter.of(context).pushReplacementNamed(AppRoutes.signIn.name);
                            return;
                          }

                          _pageController.nextPage(
                            duration: Durations.short2,
                            curve: Curves.easeIn,
                          );
                        },
                        child: const Icon(Icons.arrow_forward, color: CoreColors.brown),
                      ),
                    ],
                  ),
                  const SizedBox(height: kBottomNavigationBarHeight),
                ],
              ),
            );
          }

          if (state is OnboardingErrorState) {
            GoRouter.of(context).pushReplacementNamed(AppRoutes.signIn.name);
            return const AppErrorWidget(errorCode: AppErrorCode.serverError);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Color hexToColor(String hex) {
    try {
      final buffer = StringBuffer();
      if (hex.length == 7) buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      debugPrint("Invalid hex color: $hex — $e");
      return Colors.grey;
    }
  }
}
