import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/features/items/presentation/controller/Citem.dart';
import 'package:my_exams/features/items/presentation/controller/Csoal.dart';
import 'package:my_exams/features/items/presentation/pages/editSoal.dart';
import 'package:my_exams/core/style/styles.dart';

class Itemstandart extends StatefulWidget {
  const Itemstandart({super.key});

  @override
  State<Itemstandart> createState() => _ItemstandartState();
}

class _ItemstandartState extends State<Itemstandart> {
  Citem itemControl = Get.find<Citem>();
  Csoal soalControl = Get.find<Csoal>();

  @override
  void initState() {
    super.initState();
    itemControl.firstInit();
    itemControl.scroll.value.addListener((){
      if (itemControl.scroll.value.position.pixels >=
          itemControl.scroll.value.position.maxScrollExtent - 100) {
        itemControl.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soal'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        soalControl.isEdit.value = false;
        soalControl.isParent.value = false;
        soalControl.mPackage.value = itemControl.mPackage.value;
        print("Dari item list : \n ${itemControl.mPackage.value?.toJson()}");
        Get.to(() => Editsoal())?.then((_) {
          itemControl.getItemAnswer();
        });
      }, child: Icon(Icons.add),),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Obx(() => Column(
            children: [
              // MyStyles.textfield('Cari Soal', itemControl.cari.value),
              const SizedBox(height: 10,),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    itemControl.getItemAnswer();
                  },
                  child: ReorderableListView.builder(
                    scrollController: itemControl.scroll.value,
                    itemCount: itemControl.listpaged.length,
                    onReorder: (oldIndex, newIndex) async {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }

                      final movedItem = itemControl.listpaged[oldIndex];
                      final targetItem = itemControl.listpaged[newIndex];
                      await itemControl.updatedOrder(targetItem.itemModel, movedItem.itemModel);
                    },
                    itemBuilder: (context, index) {
                      final data = itemControl.listpaged[index];

                      int correctIndex = data.answers.indexWhere((e) => e.corretAnswer == 1);

                      itemControl.selectedAnswers[index] = correctIndex;
                      return InkWell(
                        key: ValueKey(data.itemModel.id),
                        onLongPress: () {
                        },
                        onTap: () {
                          soalControl.isEdit.value = true;
                          soalControl.isParent.value = false;
                          soalControl.mItem.value = data.itemModel;
                          soalControl.listAnswer.value = data.answers;
                          soalControl.mPackage.value = itemControl.mPackage.value;
                          soalControl.order.value = index + 1;
                          Get.to(() => Editsoal())?.then((_) {
                            itemControl.getItemAnswer();
                          });
                        },
                        child: MyStyles.soalCard(
                          data.itemModel.content,
                          data.answers,
                          (val){
                            
                          },
                          data.attachments,
                          data.itemModel.order.toString(),
                          onDel: (){
                            if(index != 0){
                              itemControl.onDeleteItem(data.itemModel);
                            }
                          }
                        ),
                      );
                    },
                  ),
                ),
              )

            ],
          ),)
        ),
      ),
    );
  }
}