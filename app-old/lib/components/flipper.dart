import 'package:chapter/components/chapter_landing.dart';
import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart';

class Flipper extends StatefulWidget {
  const Flipper({super.key});

  @override
  State<Flipper> createState() => _FlipperState();
}

class _FlipperState extends State<Flipper> {
  final _controller = GlobalKey<PageFlipWidgetState>();
  final testData = '''
Orwal Ipsum

The clocks were striking thirteen, and the dark, brooding figure of Big Brother loomed over the city. In the face of a Ministry of Truth dedicated to altering history, Winston Smith contemplated the dismal, grey world that surrounded him. Freedom is slavery, ignorance is strength, and the Party's perpetual war ensured a state of constant vigilance.

Doublethink allowed the citizens of Oceania to hold contradictory beliefs simultaneously, a feat that kept them loyal and subservient. The telescreens watched every movement, every facial expression, ensuring that thoughtcrime was a constant threat. In Room 101, the worst thing in the world awaited those who dared to rebel.
Doublethink allowed the citizens of Oceania to hold contradictory beliefs simultaneously, a feat that kept them loyal and subservient. The telescreens watched every movement, every facial expression, ensuring that thoughtcrime was a constant threat. In Room 101, the worst thing in the world awaited those who dared to rebel.
Doublethink allowed the citizens of Oceania to hold contradictory beliefs simultaneously, a feat that kept them loyal and subservient. The telescreens watched every movement, every facial expression, ensuring that thoughtcrime was a constant threat. In Room 101, the worst thing in the world awaited those who dared to rebel.
Doublethink allowed the citizens of Oceania to hold contradictory beliefs simultaneously, a feat that kept them loyal and subservient. The telescreens watched every movement, every facial expression, ensuring that thoughtcrime was a constant threat. In Room 101, the worst thing in the world awaited those who dared to rebel.
Doublethink allowed the citizens of Oceania to hold contradictory beliefs simultaneously, a feat that kept them loyal and subservient. The telescreens watched every movement, every facial expression, ensuring that thoughtcrime was a constant threat. In Room 101, the worst thing in the world awaited those who dared to rebel.
Doublethink allowed the citizens of Oceania to hold contradictory beliefs simultaneously, a feat that kept them loyal and subservient. The telescreens watched every movement, every facial expression, ensuring that thoughtcrime was a constant threat. In Room 101, the worst thing in the world awaited those who dared to rebel.
Doublethink allowed the citizens of Oceania to hold contradictory beliefs simultaneously, a feat that kept them loyal and subservient. The telescreens watched every movement, every facial expression, ensuring that thoughtcrime was a constant threat. In Room 101, the worst thing in the world awaited those who dared to rebel.

Julia's whispered secrets and the forbidden diary provided fleeting moments of solace. Yet, the inevitability of betrayal hung over their clandestine meetings. O'Brien, with his piercing gaze and enigmatic smile, represented the Party's omnipotence and the futility of resistance.

In the Ministry of Love, Winston's spirit was broken, reprogrammed to accept the truth of two plus two equaling five. The past was erased, the erasure forgotten, and the lie became truth. The final, chilling acceptance of Big Brother's love marked the end of Winston's struggle and the triumph of totalitarian control.
''';

  List<String> pages = [];


  @override
  void didChangeDependencies() {
    _buildPagesList();

    super.didChangeDependencies();
  }

  List<String> _splitTextIntoPages() {
    List<String> pageList = [];

    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    TextStyle textStyle = const TextStyle(fontSize: 16);
    double pageWidth = MediaQuery.of(context).size.width - 32; // Horizontal padding
    double pageHeight = MediaQuery.of(context).size.height - 200; // Vertical padding

    // Split the text into pages
    String remainingText = testData;
    while (remainingText.isNotEmpty) {
      textPainter.text = TextSpan(text: remainingText, style: textStyle);
      textPainter.layout(maxWidth: pageWidth);

      int endIndex = textPainter.getPositionForOffset(Offset(pageWidth, pageHeight)).offset;
      if (endIndex == 0) {
        endIndex = remainingText.length;
      }

      pageList.add(remainingText.substring(0, endIndex).trim());
      remainingText = remainingText.substring(endIndex).trim();
    }

    return pageList;
  }

  final List<Widget> _pages = [];

  _buildPagesList() {
    _pages.clear();
    _pages.add(
      const ChapterLanding(title: "Chapter 1", name: "Hitesh patel", subTitle: "Lesson 1"),
    );

    final pageList = _splitTextIntoPages();

    for (var page in pageList) {
      _pages.add(
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              page,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildPagesList();
    return Scaffold(
      body: PageFlipWidget(
        key: _controller,
        backgroundColor: Colors.white,
        lastPage: Container(
          color: Colors.white,
          child: const Center(
            child: Text('Last Page!'),
          ),
        ),
        children: _pages,
      ),
    );
  }
}
