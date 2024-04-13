import 'package:flutter/material.dart';
import 'package:robot/store/app_store.dart';
import 'package:url_launcher/url_launcher.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  void initState() {
    super.initState();
    getJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'หางาน',
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
            listenable: jobsChanged,
            builder: (context, child) {
              return ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: const Icon(
                      Icons.arrow_right,
                    ),
                    title: Text('${jobs[index]['topic']}',
                        style: const TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Color.fromRGBO(41, 41, 41, 1),
                        )),
                    subtitle: convertDateTH(jobs[index]['date_end']),
                    trailing: IconButton(
                      onPressed: () {
                        launchUrl(
                          Uri.parse('${jobs[index]['link']}'),
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

  Widget convertDateTH(dateTime) {
    List<String> d = dateTime.split("-"); // แยกสตริงโดยใช้เครื่องหมาย ','
    return Text(
      'รับสมัครถึง ${d[2]}-${d[1]}-${int.parse(d[0]) + 543}',
      style: const TextStyle(
        fontFamily: 'Kanit',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color.fromRGBO(177, 87, 49, 1),
      ),
    );
  }
}
