import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/models/word.dart';
import 'package:noble_quran/noble_quran.dart';

import '../utils/quran_utils.dart';

class QBSurahWordDisplayScreen extends StatefulWidget {
  const QBSurahWordDisplayScreen({Key? key, required this.selectedSurah})
      : super(key: key);

  final NQSurahTitle selectedSurah;

  @override
  State<QBSurahWordDisplayScreen> createState() =>
      _QBSurahWordDisplayScreenState();
}

class _QBSurahWordDisplayScreenState extends State<QBSurahWordDisplayScreen> {
  List<NQWord> _allWords = [];
  int _currentWord = 0;

  @override
  void initState() {
    super.initState();
    // announce the surah name when screen opens
    Future.delayed(const Duration(seconds: 1), () {
      QuranUtils.announce("${widget.selectedSurah.name} AAYAT 1");
    });
  }

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
            title: Text("Surah  Screen",
                semanticsLabel: "Surah  Screen",
                style: Theme.of(context).textTheme.titleLarge)),
        body: FutureBuilder<List<NQWord>>(
          future: _getAllWords(),
          builder:
              (BuildContext context, AsyncSnapshot<List<NQWord>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                    child: Text(
                  'Loading....',
                  style: TextStyle(color: Colors.white),
                ));
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}',
                                   style: const TextStyle(color: Colors.white)
                  ));
                } else {
                  _allWords = snapshot.data ?? [];
                  return SingleChildScrollView(
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // title
                          Flexible(
                            child: Text(
                              widget.selectedSurah.name,
                              semanticsLabel: widget.selectedSurah.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: "Alvi"),
                            ),
                          ),

                          const SizedBox(height: 10),

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
                                            QuranUtils.announce(
                                                "${_allWords[_currentWord].ar}\n\n${_allWords[_currentWord].tr}");
                                          } else {
                                            QuranUtils.announce(
                                                "No more previous words");
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
                                          QuranUtils.announce(
                                              "${_allWords[_currentWord].ar}\n\n${_allWords[_currentWord].tr}");
                                        } else {
                                          QuranUtils.announce(
                                              "You are at the last word.");
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
                          SizedBox(
                            height: 400,
                            child: Center(
                              child: Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(children: [
                                    Text(
                                      _allWords[_currentWord].ar,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 80,
                                          color: Colors.white,
                                          fontFamily: "Alvi"),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Text(
                                        _allWords[_currentWord].tr,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 60, color: Colors.white),
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
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
          ar: "AAYAT"));
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
}
