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
    getHistory(); // ดึงข้อมูลทันทีที่เข้าหน้า
  }

  @override
  Widget build(BuildContext context) {
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
            return const Center(child: Text('ยังไม่มีประวัติการสอบ', style: TextStyle(fontFamily: 'Kanit')));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final item = historyList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF6A806A).withOpacity(0.1),
                    child: const Icon(Icons.assignment_turned_in, color: Color(0xFF6A806A)),
                  ),
                  title: Text(item['subject_name'], style: const TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)),
                  // ในไฟล์ history_page.dart ตรงส่วน subtitle
                  subtitle: Text(
                    'วันที่: ${formatThaiDate(item['created_at'])}', 
                    style: const TextStyle(
                      fontFamily: 'Kanit', 
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  // ค้นหาบรรทัดนี้ใน history_page.dart แล้วเปลี่ยนเป็นโค้ดด้านล่างครับ
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
                        style: const TextStyle(fontSize: 10, fontFamily: 'Kanit'),
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