import 'package:flutter/material.dart';
import 'package:robot/store/app_store.dart';
import 'package:url_launcher/url_launcher.dart';

class GuidelinePage extends StatefulWidget {
  const GuidelinePage({super.key});

  @override
  State<GuidelinePage> createState() => _GuidelinePageState();
}

class _GuidelinePageState extends State<GuidelinePage> {
  @override
  void initState() {
    super.initState();
    getGuideline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'แนวข้อสอบ',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(124, 159, 127, 1),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 5, bottom: 10),
        child: ListenableBuilder(
            listenable: guidelinesChanged,
            builder: (context, child) {
              return ListView.builder(
                itemCount: guidelines.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: const Icon(
                      Icons.arrow_right,
                    ),
                    title: Text('${guidelines[index]['topic']}',
                        style: const TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Color.fromRGBO(41, 41, 41, 1),
                        )),
                    trailing: IconButton(
                      onPressed: () {
                        launchUrl(
                          Uri.parse('${guidelines[index]['link']}'),
                        );
                      },
                      icon: const Icon(
                        Icons.search,
                        size: 20,
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
