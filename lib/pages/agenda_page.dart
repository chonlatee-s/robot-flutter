import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'เกณฑ์การสอบ',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(124, 159, 127, 1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'การสอบแบ่งออกเป็น 3 ส่วน',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(57, 59, 36, 1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Stepper(
                controlsBuilder: (BuildContext ctx, ControlsDetails dtl) {
                  return Row(
                    children: <Widget>[
                      TextButton(
                        onPressed: dtl.onStepContinue,
                        child: const Text('ถัดไป'),
                      ),
                      TextButton(
                        onPressed: dtl.onStepCancel,
                        child: const Text('ย้อนกลับ'),
                      ),
                    ],
                  );
                },
                steps: [
                  Step(
                    isActive: _currentStep == 0,
                    title: const Text('ภาค ก'),
                    content: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color.fromRGBO(131, 150, 133, 1),
                            Color.fromRGBO(103, 127, 86, 1),
                          ],
                        ),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'ก',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 60,
                              fontWeight: FontWeight.w300,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Text(
                              'ภาค ก คือความรู้ความสามารถทั่วไป ความสามารถในการคิดวิเคราะห์ ทักษะภาษาอังกฤษ ความรู้และลักษณะการเป็นข้าราชการที่ดี',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 14,
                                fontWeight: FontWeight.w200,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Step(
                    isActive: _currentStep == 1,
                    title: const Text('ภาค ข'),
                    content: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color.fromRGBO(131, 150, 133, 1),
                            Color.fromRGBO(103, 127, 86, 1),
                          ],
                        ),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'ข',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 60,
                              fontWeight: FontWeight.w300,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Text(
                              'ภาค ข คือมาตรฐานความรู้และประสบการณ์วิชาชีพ มาตรฐานความรู้ทั่วไปในการจัดการเรียนการสอน มาตรฐานความรอบรู้ในเนื้อหาวิชาที่สอน ความรอบรู้กฎหมายที่เกี่ยวข้องกับการปฏิบัติงาน',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 14,
                                fontWeight: FontWeight.w200,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Step(
                    isActive: _currentStep == 2,
                    title: const Text('ภาค ค'),
                    content: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color.fromRGBO(131, 150, 133, 1),
                            Color.fromRGBO(103, 127, 86, 1),
                          ],
                        ),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'ค',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 60,
                              fontWeight: FontWeight.w300,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Text(
                              'ภาค ค คือความเหมาะสมกับตำแหน่ง วิชาชีพ และการปฏิบัติงานในสถานศึกษา คุณลักษณะส่วนบุคคล การพัฒนาตนเองและวิชาชีพ',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 14,
                                fontWeight: FontWeight.w200,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                onStepTapped: (int newIndex) {
                  setState(() {
                    _currentStep = newIndex;
                  });
                },
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep != 2) {
                    setState(() {
                      _currentStep += 1;
                    });
                  }
                },
                onStepCancel: () {
                  if (_currentStep != 0) {
                    setState(() {
                      _currentStep -= 1;
                    });
                  }
                },
              ),
            ),
            InkWell(
              onTap: () => launchUrl(
                Uri.parse(
                    'https://drive.google.com/drive/folders/1B758nz2pnZILn43dxtFd6fpy3rpjdR2M?usp=sharing'),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 50),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color.fromRGBO(178, 200, 135, 1),
                        Color.fromRGBO(70, 112, 96, 1),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        size: 30,
                        Icons.category,
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      Text(
                        'อ่านเกณฑ์แบบละเอียด',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                      Icon(
                        size: 25,
                        Icons.arrow_forward,
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
