import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/helper.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/package/presentation/controller/CSecondPackage.dart';

class Secondpackage extends StatefulWidget {
  const Secondpackage({super.key});

  @override
  State<Secondpackage> createState() => _SecondpackageState();
}

class _SecondpackageState extends State<Secondpackage> {
  Csecondpackage cpackage = Get.find<Csecondpackage>();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await cpackage.setUI();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Paket'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          cpackage.beforeExecute();
      }, child: Icon(Icons.save),),

      body: Obx(() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyStyles.textfield('Judul', cpackage.title.value),
                  const SizedBox(height: 8),
                  MyStyles.textfield('Deskripsi', cpackage.description.value),
                  const SizedBox(height: 8),
                  MyStyles.textfield('Durasi sesi (detik)', cpackage.durationSub.value),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyStyles.textLightSmall('Durasi per soal'),
                      Checkbox(
                        value: cpackage.itemDuration.value,
                        onChanged: (bool? value) {
                          cpackage.itemDuration.value = value ?? false;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Visibility(
                    visible: !cpackage.btnMainItems.value && cpackage.isEdit.value,
                    child: MyStyles.myButton('Tambah Pelajaran', () {
                      cpackage.isEditSub.value = false;
                      cpackage.popUpSub();
                    }),
                  ),

                  Visibility(
                    visible: cpackage.btnMainItems.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyStyles.textLightSmall(
                            'Soal ini berada paket pertama anda yakni ${cpackage.mPackage.value?.title ?? ""}',
                          ),
                          const SizedBox(height: 8),
                          MyStyles.myButton('Ke soal', () {
                            if (cpackage.mPackage.value == null) {
                              MyStyles.information('Data paket bermasalah !');
                            } else {
                              cpackage.gotoItem(cpackage.mPackage.value!);
                            }
                          }),
                        ],
                      ),
                    ),
                  ),

                  // LIST PELAJARAN
                  Visibility(
                    visible: !cpackage.btnMainItems.value,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyStyles.textContentMedium('Pelajaran :'),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 300,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: cpackage.listPackage.length,
                              itemBuilder: (context, index) {
                                final data = cpackage.listPackage[index];
                                return InkWell(
                                  onTap: () {
                                    cpackage.gotoItem(data);
                                  },
                                  onLongPress: () {
                                    cpackage.onDeletePackage(data);
                                  },
                                  child: MyStyles.myCard(
                                    data.title,
                                    [
                                      '${data.description ?? ""}',
                                      'Acak Soal : ${data.randomItem == 1 ? "Ya" : "Tidak"}',
                                      'Item Durasi : ${data.itemDuration == 1 ? "Ya" : "Tidak"}',
                                      'Dibuat : ${Helper.toMySQLDateTime(data.createdAt)}'
                                    ],
                                    [
                                      Icons.edit,
                                    ],
                                    [
                                      () {
                                        cpackage.isEditSub.value = true;
                                        cpackage.mSubPackage.value = data;
                                        cpackage.popUpSub();
                                        print(data.toJson());
                                      },
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )),

    );
  }
}