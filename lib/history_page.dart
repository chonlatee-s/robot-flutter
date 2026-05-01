import 'package:flutter/material.dart';
import 'package:robot/store/app_store.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    // ดึงค่าระยะห่างจากขอบล่างของจอ (Safe Area Bottom)
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F8),
      appBar: AppBar(
        title: const Text('ประวัติการสอบ', style: TextStyle(fontFamily: 'Kanit')),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2D2F31),
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: historyChanged,
        builder: (context, child) {
          if (historyList.isEmpty) {
            return const Center(
              child: Text('ยังไม่มีประวัติการสอบ', style: TextStyle(fontFamily: 'Kanit'))
            );
          }
          return ListView.builder(
            // ปรับตรงนี้: เพิ่ม bottomPadding เข้าไปใน padding ของ ListView
            padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding + 20), 
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final item = historyList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade200)
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF6A806A).withOpacity(0.1),
                    child: const Icon(Icons.assignment_turned_in, color: Color(0xFF6A806A)),
                  ),
                  title: Text(
                    item['subject_name'] ?? 'ไม่ระบุวิชา', 
                    style: const TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)
                  ),
                  subtitle: Text(
                    'วันที่: ${formatThaiDate(item['created_at'])}', 
                    style: const TextStyle(
                      fontFamily: 'Kanit', 
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${item['score']}/${item['total_questions']}', 
                        style: const TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xFFB15731),
                          fontFamily: 'Kanit'
                        )
                      ),
                      Text(
                        formatDuration(item['time_spent']),
                        style: const TextStyle(
                          fontSize: 10, 
                          fontFamily: 'Kanit',
                          color: Colors.blueGrey
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}