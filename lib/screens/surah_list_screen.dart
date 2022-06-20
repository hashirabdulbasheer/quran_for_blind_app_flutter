import 'package:flutter/material.dart';
import 'package:noble_quran/models/surah_title.dart';
import 'package:noble_quran/noble_quran.dart';
import 'surah_display_screen.dart';

class QBSurahListScreen extends StatelessWidget {
  const QBSurahListScreen({Key? key}) : super(key: key);

  // TODO: Update before release
  final String appVersion = "1.0.0";

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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                QBSurahDisplayScreen(
                                                    selectedSurah:
                                                        titles[index])),
                                      );
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "v$appVersion uxQuran",
                    style: const TextStyle(color: Colors.white),
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
