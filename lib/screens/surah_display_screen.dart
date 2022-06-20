import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/models/word.dart';
import 'package:noble_quran/noble_quran.dart';

class QBSurahDisplayScreen extends StatefulWidget {
  const QBSurahDisplayScreen({Key? key, required this.selectedSurah})
      : super(key: key);

  final NQSurahTitle selectedSurah;

  @override
  State<QBSurahDisplayScreen> createState() => _QBSurahDisplayScreenState();
}

class _QBSurahDisplayScreenState extends State<QBSurahDisplayScreen> {
  List<NQWord> _allWords = [];
  int _currentWord = 0;

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  // UI for the page
  Widget _body(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
            title: Text(widget.selectedSurah.name,
                style: Theme.of(context).textTheme.titleLarge)),
        body: FutureBuilder<List<NQWord>>(
          future: _getAllWords(),
          builder:
              (BuildContext context, AsyncSnapshot<List<NQWord>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: Text('Loading....'));
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  _allWords = snapshot.data ?? [];
                  return Column(
                    children: [
                      // controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 100,
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (_currentWord - 1 >= 0) {
                                        setState(() {
                                          _currentWord--;
                                        });
                                        announce(
                                            "${_allWords[_currentWord].ar}\n\n${_allWords[_currentWord].tr}",
                                            TextDirection.ltr);
                                      } else {
                                        announce("No more previous words",
                                            TextDirection.ltr);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white),
                                    child: Text(
                                      "Previous word",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge,
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 100,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_currentWord + 1 <
                                        _allWords.length) {
                                      setState(() {
                                        _currentWord++;
                                      });
                                      announce(
                                          "${_allWords[_currentWord].ar}\n\n${_allWords[_currentWord].tr}",
                                          TextDirection.ltr);
                                    } else {
                                      announce("You are at the last word.",
                                          TextDirection.ltr);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white),
                                  child: Text(
                                    "Next word",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // content
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                _allWords[_currentWord].ar,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 80,
                                    color: Colors.white,
                                    fontFamily: "Alvi"),
                              ),
                              const SizedBox(height: 10,),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  _allWords[_currentWord].tr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }

  // fetch and prepare the words for the selected surah
  Future<List<NQWord>> _getAllWords() async {
    List<List<NQWord>> surah =
        await NobleQuran.getSurahWordByWord(widget.selectedSurah.number - 1);
    List<NQWord> allWords = [];
    int currentAyat = 1;
    for (List<NQWord> ayat in surah) {
      allWords.add(NQWord(
          word: 1,
          tr: "$currentAyat",
          aya: currentAyat,
          sura: widget.selectedSurah.number,
          ar: "AYAT"));
      for (NQWord word in ayat) {
        allWords.add(word);
      }
      currentAyat++;
    }
    allWords.add(NQWord(
        word: 1,
        tr: "OF SURAH",
        aya: currentAyat,
        sura: widget.selectedSurah.number,
        ar: "END"));
    return allWords;
  }

  // read aloud
  static Future<void> announce(
      String message, TextDirection textDirection) async {
    final AnnounceSemanticsEvent event =
        AnnounceSemanticsEvent(message, textDirection);
    await SystemChannels.accessibility.send(event.toMap());
  }
}
