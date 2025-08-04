import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';
import 'package:my_exams/features/items/presentation/controller/Csoal.dart';
import 'package:my_exams/core/style/styles.dart';

class Editsoal extends StatefulWidget {
  const Editsoal({super.key});

  @override
  State<Editsoal> createState() => _EditsoalState();
}

class _EditsoalState extends State<Editsoal> {
  Csoal itemControl = Get.find<Csoal>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
        itemControl.initMain();
        itemControl.getAttachment();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Edit Soal'),
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () async{
        await itemControl.beforeExecute();
      },
      child: const Icon(Icons.save),
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
            const Text(
            'Pertanyaan:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
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
                child: 
                  quill.QuillSimpleToolbar(
                    controller: itemControl.quillControllerMain,
                    config: const quill.QuillSimpleToolbarConfig(
                      showAlignmentButtons: true,
                    ),
                  ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: quill.QuillEditor.basic(
                controller: itemControl.quillControllerMain,
                ),
              ),
              ],
            ),
            ),
            const SizedBox(height: 20),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
              'Jawaban:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            MyStyles.myButton('Lihat Jawaban', (){
                  itemControl.showAnswerPopupMulti();
            }),
            const SizedBox(height: 10),
            MyStyles.myButton('Lihat Attachment', (){
                  itemControl.popUpAttachment();
            }),

            const SizedBox(height: 10),
            MyStyles.textContentMedium(
              '${itemControl.listParent.length.toString()} Soal Lainnya'),
            const SizedBox(height: 10),
            Visibility(
              visible: itemControl.isEdit.value,
              child: MyStyles.myButton("Tambah Anak Soal", (){
                itemControl.gotoParent(null, [], false);
              })
            ),
            const SizedBox(height: 10),
            SizedBox(
            height: 300,
            child: ReorderableListView.builder(
              itemCount: itemControl.listParent.length,
              onReorder: (oldIndex, newIndex) async{
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }

                final movedItem = itemControl.listParent[oldIndex];
                final targetItem = itemControl.listParent[newIndex];
                await itemControl.updatedOrder(targetItem.itemModel, movedItem.itemModel);
              },
              itemBuilder: (context, index) {
              final data = itemControl.listParent[index];

              return InkWell(
                key: ValueKey(data.itemModel.id),
                onTap: () {
                  itemControl.gotoParent(data.itemModel, data.answers, true);
                },
                  child: MyStyles.soalCard(
                  data.itemModel.content,
                  data.answers,
                  (val){

                  },
                  data.attachments,
                  data.itemModel.order.toString(),
                  onDel: () {
                    itemControl.onDeleteItem(data.itemModel);
                  },
                  ),
              );
              },
            ),
            ),
          ],
          ),
        ),
        ),
      ) 
    );
  }
}