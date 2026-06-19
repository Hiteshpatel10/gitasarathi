import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChapterLanding extends StatefulWidget {
  const ChapterLanding({
    super.key,
    required this.title,
    required this.name,
    required this.subTitle,
  });

  final String title;
  final String name;
  final String subTitle;

  @override
  State<ChapterLanding> createState() => _ChapterLandingState();
}

class _ChapterLandingState extends State<ChapterLanding> {
  Float64List matrix4 = Matrix4.identity().storage;
  late Future<ui.Image> imgFuture;

  // New helper function
  Future<ui.Image> loadImageFromFile(String path) async {
    var fileData = Uint8List.sublistView(await rootBundle.load(path));
    return await decodeImageFromList(fileData);
  }

  @override
  void initState() {
    imgFuture = loadImageFromFile("assets/backgrounds/bg.jpeg");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: kToolbarHeight),
        Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
        Expanded(
          child: Center(
            child: FutureBuilder(
              future: imgFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  return Text(
                    widget.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(fontWeight: FontWeight.w700, fontSize: 36),
                  );
                }

                return Text(
                  widget.name,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 40,
                        foreground: Paint()
                          ..shader =
                              ImageShader(snapshot.data!, TileMode.clamp, TileMode.clamp, matrix4),
                      ),
                );
              },
            ),
          ),
        ),
        Text(widget.subTitle, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: kToolbarHeight),
      ],
    );
  }
}
