import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_exams/features/package/presentation/controller/CFirstPackage.dart';
import 'package:my_exams/core/style/styles.dart';

class Firstpackage extends StatefulWidget {
  const Firstpackage({super.key});

  @override
  State<Firstpackage> createState() => _FirstpackageState();
}

class _FirstpackageState extends State<Firstpackage> {
  Cfirstpackage cpackage = Get.put(Cfirstpackage());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cpackage.setUI();
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
          Get.back();
      }, child: Icon(Icons.save),),
      body: Padding(padding: EdgeInsets.all(16.0),
        child: Obx(() => 
        Center(
          child: (
            Column(
              children: [
                Visibility(
                  visible: true,
                  child: MyStyles.textfield('Judul', cpackage.title.value)
                ),
                const SizedBox(height: 5,),

                Visibility(
                  visible: true,
                  child: MyStyles.textfield('Deskripsi', cpackage.description.value)
                ),
                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('Format toefl'),
                  Obx(() => Checkbox(
                      value: cpackage.isToefl.value,
                      onChanged: (bool? value) {
                      cpackage.isToefl.value = value ?? false;
                      },
                    )),
                  ],
                ),
                const SizedBox(height: 5,),
                Visibility(
                  visible: cpackage.isEdit.value,
                  child: MyStyles.myButton('Tambah Sesi', (){
                    cpackage.toSecondPackage(false, null);
                  })
                ),
                SizedBox(height: 5,),
                Visibility(
                  visible: cpackage.isEdit.value,
                  child: MyStyles.textContentMedium('Sesi :')),
                const SizedBox(height: 5,),
                Expanded(
                  child: ListView.builder(
                    itemCount: cpackage.listPackage.length,
                    itemBuilder: (context, index){
                      final data = cpackage.listPackage[index];
                      return InkWell(
                        onTap: (){
                          cpackage.toSecondPackage(true, data);
                        },
                        onLongPress: () {
                          cpackage.onDeletePackage(data);
                        },
                        child: MyStyles.myCard(
                          data.title,
                          ['${data.description ?? ""}'], 
                          [], 
                          []
                        ),
                      );
                    }
                  )
                )
              ],
            )
          ),
        ),
        )
      )
    );
  }
}