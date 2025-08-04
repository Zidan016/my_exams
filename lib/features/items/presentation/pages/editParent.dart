import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/items/presentation/controller/Csoal.dart';

class Editparent extends StatefulWidget {
  const Editparent({super.key});

  @override
  State<Editparent> createState() => _EditparentState();
}

class _EditparentState extends State<Editparent> {
  Csoal itemControl = Get.find<Csoal>();

  @override
  void initState() {
    super.initState();
    itemControl.initParent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Soal'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          await itemControl.beforeExecute();
        },
        child: Icon(Icons.save),
      ),
      body: Obx(()=> Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5,),
              Container(
                width: 75,
                child: MyStyles.textfield('Number', itemControl.orderController.value),
              ),
              SizedBox(height: 5,),
              Text(
                'Pertanyaan:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: quill.QuillSimpleToolbar(
                        controller: itemControl.quillControllerParent,
                        config: const quill.QuillSimpleToolbarConfig(
                          showAlignmentButtons: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: quill.QuillEditor.basic(
                        controller: itemControl.quillControllerParent,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Jawaban:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                const Text('Acak Jawaban'),
                                Checkbox(
                                      value: itemControl.randomAnswer.value == 1,
                                      onChanged: (bool? value) {
                                        itemControl.randomAnswer.value =
                                            (value ?? false) ? 1 : 0;
                                      },
                                    ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        MyStyles.myButton('Lihat Jawaban', () {
                          itemControl.showAnswerPopupMulti();
                        }),
                        const SizedBox(height: 10),
                        MyStyles.myButton('Lihat Attachment', () {
                          itemControl.popUpAttachment();
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),)
    );
  }
}