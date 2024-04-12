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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: false,
            floating: true,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'แนวข้อสอบ',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 21,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(252, 252, 252, 1),
                ),
              ),
              background: Image.asset(
                'assets/img/guideline.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListenableBuilder(
              listenable: guidelinesChanged,
              builder: (context, child) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
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
                    childCount: guidelines.length,
                  ),
                );
              }),
        ],
      ),
    );
  }
}
