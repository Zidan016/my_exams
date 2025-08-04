import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/features/exams/presentation/controller/CExams.dart';
import 'package:my_exams/features/exams/presentation/pages/searchPackage.dart';
import 'package:my_exams/core/style/styles.dart';

class Editexam extends StatefulWidget {
  const Editexam({super.key});

  @override
  State<Editexam> createState() => _EditexamState();
}

class _EditexamState extends State<Editexam> {
  Cexams examsControl = Get.find<Cexams>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      examsControl.setUIEdit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          examsControl.addOrsave();
          Get.back();
      }, child: Icon(Icons.save),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyStyles.textfield('Nama', examsControl.nameField.value),
              const SizedBox(height: 16),

              Visibility(
                visible: false,
                child: MyStyles.textfield('Durasi', examsControl.durationField.value),
              ),
              
              const SizedBox(height: 16),
              MyStyles.textContentMedium("Paket:"),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: MyStyles.textContentLarge(
                        examsControl.packageName.value),
                  ),
                  const SizedBox(width: 8),
                  MyStyles.myButton('Pilih Paket', () {
                    Get.to(()=>SearchPackage());
                  }),
                ],
              ),
              const SizedBox(height: 16),
              Visibility(
                visible: false,
                child: Row(
                children: [
                  const Text('Multi attempt'),
                  const Spacer(),
                  Checkbox(
                    value: examsControl.multiAttempt.value == 1,
                    onChanged: (bool? value) {
                      examsControl.multiAttempt.value =
                          (value ?? false) ? 1 : 0;
                    },
                  ),
                ],
              ),
              ),
              
              const SizedBox(height: 16),
              Visibility(
                visible: false,
                child: Row(
                children: [
                  const Text('Mulai Otomatis'),
                  const Spacer(),
                  Checkbox(
                    value: examsControl.autoStart.value == 1,
                    onChanged: (bool? value) {
                      examsControl.autoStart.value =
                          (value ?? false) ? 1 : 0;
                    },
                  ),
                ],
              ),
              ),
              
              const SizedBox(height: 16),
              if (examsControl.autoStart.value == 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pilih Tanggal dan Waktu:'),
                    const SizedBox(height: 8),
                    MyStyles.dateTimePicker(
                      initialDate: examsControl.date.value,
                      onDateChanged: (newDate) {
                        setState(() {
                          examsControl.date.value = newDate;
                        });
                      },
                      initialTime: examsControl.time.value,
                      onTimeChanged: (newTime) {
                        setState(() {
                          examsControl.time.value = newTime;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                MyStyles.myButton('Publish Ujian', 
                (){
                  examsControl.showPopUp();
                })
            ],
          ),
        ),
      ),
    );
  }
}