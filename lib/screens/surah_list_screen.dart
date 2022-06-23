import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/noble_quran.dart';
import 'package:quran_for_blind_app_flutter/utils/quran_utils.dart';
import '../enums/quran_reading_type_enum.dart';
import 'surah_ayat_display_screen.dart';
import 'surah_word_display_screen.dart';

// TODO: Update before release
const String appVersion = "1.0.0";

class QBSurahListScreen extends StatefulWidget {
  const QBSurahListScreen({Key? key}) : super(key: key);

  @override
  State<QBSurahListScreen> createState() => _QBSurahListScreenState();
}

class _QBSurahListScreenState extends State<QBSurahListScreen> {
  QuranReadingTypeEnum? _readingMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
          title: Text(
        "Quran For Blind",
        style: Theme.of(context).textTheme.titleLarge,
      )),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              label: "Select a reading mode from below",
              excludeSemantics: true,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Select a reading mode from below",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.white),
                          onPressed: () async {
                            QuranReadingTypeEnum? mode =
                                await _readingModeSelectionDialog(context);
                            if (mode != null) {
                              setState(() {
                                _readingMode = mode;
                              });
                            }
                          },
                          child: Text(
                            _readingMode?.rawValue ??
                                QuranReadingTypeEnum.wordByWord.rawValue,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 30),
                          )),
                    ),
                  ),
                )
              ],
            ),
            Semantics(
              label: "Select a surah from below",
              excludeSemantics: true,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Select a surah from below",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<NQSurahTitle>>(
                  future: NobleQuran.getSurahList(), // async work
                  builder: (BuildContext context,
                      AsyncSnapshot<List<NQSurahTitle>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text('Loading....');
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<NQSurahTitle> titles = snapshot.data ?? [];
                          return ListView.separated(
                              itemCount: titles.length,
                              separatorBuilder: (context, index) {
                                return const Divider(
                                    color: Colors.white, thickness: 1);
                              },
                              itemBuilder: (context, index) {
                                return Semantics(
                                  enabled: true,
                                  excludeSemantics: true,
                                  label: "${index + 1}. ${titles[index].name}",
                                  hint: "tap to display ${titles[index].name}",
                                  button: true,
                                  onTapHint:
                                      "tap to display ${titles[index].name}",
                                  child: ListTile(
                                    onTap: () {
                                      // default is word by word
                                      QuranReadingTypeEnum selectedReadingMode =
                                          _readingMode ??
                                              QuranReadingTypeEnum.wordByWord;
                                      if (selectedReadingMode ==
                                          QuranReadingTypeEnum.wordByWord) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  QBSurahWordDisplayScreen(
                                                      selectedSurah:
                                                          titles[index])),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  QBSurahAyatDisplayScreen(
                                                      selectedSurah:
                                                          titles[index])),
                                        );
                                      }
                                    },
                                    title: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        "${index + 1}  ${titles[index].name}",
                                        style: const TextStyle(
                                            fontFamily: "Alvi",
                                            fontSize: 60,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                    }
                  }),
            ),
            Semantics(
              enabled: false,
              excludeSemantics: true,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "v$appVersion uxQuran",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<QuranReadingTypeEnum?> _readingModeSelectionDialog(
      BuildContext context) async {
    // set up the buttons
    Widget wordButton = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.black),
      onPressed: () {
        Navigator.of(context).pop(QuranReadingTypeEnum.wordByWord);
      },
      child: const Text(
        "Word by word",
        style: TextStyle(color: Colors.white),
      ),
    );

    Widget ayatButton = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.black),
      child: const Text(
        "Entire Ayat",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.of(context).pop(QuranReadingTypeEnum.ayat);
      },
    );

    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.black),
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text(
        "Cancel",
        style: TextStyle(color: Colors.white),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Select a reading mode",
        style:
            TextStyle(color: Colors.black, fontSize: 25, fontFamily: "default"),
      ),
      content: const Text(
          "Do you want to read a word at a time with its translation or an entire aayt?"),
      actions: [
        wordButton,
        ayatButton,
        cancelButton,
      ],
    );

    // show the dialog
    return await showDialog<QuranReadingTypeEnum>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
