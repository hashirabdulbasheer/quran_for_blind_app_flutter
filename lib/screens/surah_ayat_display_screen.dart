import 'package:flutter/material.dart';
import 'package:noble_quran/enums/translations.dart';
import 'package:noble_quran/models/surah.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/noble_quran.dart';

import '../models/quran_ayat_model.dart';
import '../utils/quran_utils.dart';

class QBSurahAyatDisplayScreen extends StatefulWidget {
  const QBSurahAyatDisplayScreen({Key? key, required this.selectedSurah})
      : super(key: key);

  final NQSurahTitle selectedSurah;

  @override
  State<QBSurahAyatDisplayScreen> createState() =>
      _QBSurahAyatDisplayScreenState();
}

class _QBSurahAyatDisplayScreenState extends State<QBSurahAyatDisplayScreen> {
  List<QuranAyat> _allAyats = [];
  int _currentAyat = 0;

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
        body: FutureBuilder<List<QuranAyat>>(
          future: _getAllAyats(),
          builder:
              (BuildContext context, AsyncSnapshot<List<QuranAyat>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                    child: Text(
                  'Loading....',
                  style: TextStyle(color: Colors.white),
                ));
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  _allAyats = snapshot.data ?? [];
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
                                          if (_currentAyat - 1 >= 0) {
                                            setState(() {
                                              _currentAyat--;
                                            });
                                            QuranUtils.announce(
                                                "${_allAyats[_currentAyat].ar}\n\n${_allAyats[_currentAyat].tr}");
                                          } else {
                                            QuranUtils.announce(
                                                "No more previous aayats");
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.white),
                                        child: Text(
                                          "Previous aayat",
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
                                        if (_currentAyat + 1 <
                                            _allAyats.length) {
                                          setState(() {
                                            _currentAyat++;
                                          });
                                          QuranUtils.announce(
                                              "${_allAyats[_currentAyat].ar}\n\n${_allAyats[_currentAyat].tr}");
                                        } else {
                                          QuranUtils.announce(
                                              "You are at the last aayat.");
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.white),
                                      child: Text(
                                        "Next aayat",
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
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SingleChildScrollView(
                                  child: Table(
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: [
                                      TableRow(children: [
                                        Text(
                                          _allAyats[_currentAyat].ar,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 60,
                                              color: Colors.white,
                                              fontFamily: "Alvi"),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Text(
                                            _allAyats[_currentAyat].tr,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 40,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
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

  // fetch and prepare the ayats for the selected surah
  Future<List<QuranAyat>> _getAllAyats() async {
    NQSurah arSurah =
        await NobleQuran.getSurahArabic(widget.selectedSurah.number - 1);

    NQSurah trSurah = await NobleQuran.getTranslationString(
        widget.selectedSurah.number - 1, NQTranslation.sahih);

    List<QuranAyat> allAyats = [];
    int currentAyat = 1;
    for (int index = 0; index < arSurah.aya.length; index++) {
      allAyats.add(QuranAyat(ar: "AAYAT", tr: "$currentAyat"));
      allAyats.add(
          QuranAyat(ar: arSurah.aya[index].text, tr: trSurah.aya[index].text));
      currentAyat++;
    }
    allAyats.add(QuranAyat(ar: "END", tr: "OF SURAH"));
    return allAyats;
  }
}
