import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_delta_from_html/parser/html_to_delta.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/service/ApiService.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/attachment/data/models/MAttachment.dart';
import 'package:my_exams/features/items/data/models/ItemAnswer.dart';
import 'package:my_exams/features/items/data/models/MAnswer.dart';
import 'package:my_exams/features/items/data/models/MItem.dart';
import 'package:my_exams/features/items/data/repository/IARepository.dart';
import 'package:my_exams/features/items/presentation/pages/editParent.dart';
import 'package:my_exams/features/package/data/models/MPackage.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class Csoal extends GetxController{
  Iarepository rep = Get.find<Iarepository>();

  var mItem = Rxn<ItemModel>();
  var listAnswer = <AnswerModel>[].obs;
  var listParent = <ItemAnswer>[].obs;
  var mPackage = Rxn<PackageModel>();
  var mItemParent = Rxn<ItemModel>();
  var listAnswerParent = <AnswerModel>[].obs;
  var listAttachment = <AttachmentModel>[].obs;
  var listAllAttachment = <AttachmentModel>[].obs;
  var listNewAttachment = <AttachmentModel>[].obs;
  var randomAnswer = 0.obs;
  var answerSelected = 0.obs;
  var order = 0.obs;
  var orderController = TextEditingController().obs;

  var searchAttachment = TextEditingController().obs;
  var listSearchAttachment = <AttachmentModel>[].obs;
  var backupListAttc = <AttachmentModel>[].obs;

  final quill.QuillController quillControllerMain = quill.QuillController.basic();
  final quill.QuillController quillControllerParent = quill.QuillController.basic();

  var isParent = false.obs;
  var isEdit = false.obs;
  var isIntro = 0.obs;

  getParent()async{
    final data = await rep.getParent(mItem.value?.id ?? "");
    listParent.value = data;
  }

  initMain()async{
    if(isEdit.value == true){
      await getParent();
      await getAttachment();
      orderController.value.text = mItem.value?.order.toString() ?? "0";
      var toDelta = HtmlToDelta().convert(mItem.value?.content ?? "");
      quillControllerMain.document = quill.Document.fromJson(toDelta.toJson());
    }else{
      listParent.clear();
      quillControllerMain.document = quill.Document();
      randomAnswer.value = 0;
      orderController.value.text = order.value.toString();
      listAnswer.clear();
    }
  }

  initParent()async{
    if(isEdit.value == true){
      var toDelta = HtmlToDelta().convert(mItemParent.value?.content ?? "");
      quillControllerParent.document = quill.Document.fromJson(toDelta.toJson());
      orderController.value.text = mItemParent.value?.order.toString() ?? "0";
    }else{
      quillControllerParent.document = quill.Document();
      randomAnswer.value = 0;
      listAnswerParent.clear();
      orderController.value.text = "0";
    }
  }

  gotoParent(ItemModel? newItem, List<AnswerModel> newAns, bool statusEdit) async {
    quillControllerParent.document = quill.Document();
    listAttachment.clear();
    mItemParent.value = newItem;
    listAnswerParent.assignAll(newAns);
    isEdit.value = statusEdit;
    isParent.value = true;
    await getAttachment();
    await Get.to(() => Editparent());
    quillControllerParent.document = quill.Document();
    isParent.value = false;
    isEdit.value = true;
    await initMain();
  }

  setItems(){
    final idItem = isParent.value == true ? mItemParent.value?.id ?? "" : mItem.value?.id ?? "";
    var deltaFormat = isParent.value == true
        ? quillControllerParent.document.toDelta()
        : quillControllerMain.document.toDelta();
    final type = isParent.value == true ? "simple" : listParent.length > 0 ? "bundle" : listAnswer.length > 0 ? "bundle" : "multi_choice_single";
    String toHtml = QuillDeltaToHtmlConverter(deltaFormat.toJson()).convert();    
    final itemCount = isParent.value == true ? 1 : (listParent.isNotEmpty ? listParent.length + 1 : 1);

    ItemModel model = ItemModel(
      id: isEdit.value == true ? idItem : "", 
      type: type,
      parentId: isParent.value == true ? mItem.value?.id ?? null : null, 
      content: toHtml, 
      answerOrderRandom: randomAnswer.value, 
      duration: mPackage.value?.itemDuration == 1 ? 12 : 0, 
      itemCount: itemCount, 
      order: int.parse(orderController.value.text)
    );
    return model;
  }

  beforeExecute() async {
    final controller = isParent.value ? quillControllerParent : quillControllerMain;
    if (controller.plainTextEditingValue.text == "") {
      MyStyles.snackbar('Soal Tidak Boleh Kosong !');
    } else {
      await addOrUpdate();
    }
  }

  addOrUpdate() async {
    ItemModel model = setItems();
    List<AnswerModel> newsAns = isParent.value == true ? listAnswerParent : listAnswer;
    debugPrint(newsAns.toString());
    debugPrint(model.toJson().toString());
    debugPrint(listAttachment.map((e) => e.toJson()).toList().toString());
    if (isEdit.value == false) {
      final status = isParent.value == false ? "main" : "parent";
      await rep.add(model, newsAns, mPackage.value?.id ?? "", status, listAttachment);
      // respone == true ? MyStyles.snackbar('Berhasil add data') : MyStyles.snackbar('Gagal add data');
    } else {
      await rep.update(model, model.id, newsAns, mPackage.value?.id ?? "", listAttachment);
      // respone == true ? MyStyles.snackbar('Berhasil edit data') : MyStyles.snackbar('Gagal edit data');
    }
    Get.back();
  }

  void showAnswerPopupMulti() {
    List<AnswerModel> listNewAnsw = isParent.value == false ? listAnswer : listAnswerParent; 
    final RxList<TextEditingController> answerControllers =
        listNewAnsw.map((e) => TextEditingController(text: e.content ?? '')).toList().obs;

    final RxInt correctAnswerIndex = (listNewAnsw.indexWhere((e) => e.corretAnswer == 1)).obs;

    Get.defaultDialog(
      title: 'Edit Jawaban',
      content: Obx(() => SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: answerControllers.length,
                itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Radio<int>(
                      value: index,
                      groupValue: correctAnswerIndex.value,
                      onChanged: (val) {
                        if (val != null) {
                          correctAnswerIndex.value = val;
                        }
                      },
                    )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextField(
                          controller: answerControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Jawaban ${String.fromCharCode(65 + index)}',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.clear, color: Colors.red),
                      onPressed: () {
                        answerControllers.removeAt(index);
                        
                        if (correctAnswerIndex.value == index) {
                          correctAnswerIndex.value = -1;
                        } else if (correctAnswerIndex.value > index) {
                          correctAnswerIndex.value--;
                        }

                      },
                    ),
                  ],
                );
              }

              ),
            ),
            const SizedBox(height: 10),
            MyStyles.myButton('Tambah Jawaban', () {
              answerControllers.add(TextEditingController());
            }),
          ],
        ),
      )),
      textConfirm: 'Simpan',
      textCancel: 'Batal',
      onConfirm: () {
        final List<AnswerModel> newAnswers = [];

        for (int i = 0; i < answerControllers.length; i++) {
          newAnswers.add(
            AnswerModel(
              id: '',
              itemId: mItem.value?.id ?? "",
              content: answerControllers[i].text,
              order: i,
              corretAnswer: i == correctAnswerIndex.value ? 1 : 0,
            ),
          );
        }
        if(isParent.value == true){
          listAnswerParent.value = newAnswers;
        }else{
          listAnswer.value = newAnswers;
        }
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      },
    );
  }

  getAttachment()async{
    if(isEdit.value == true && isParent.value == false){
      final data = await rep.getAttachment(mItem.value?.id ?? "");
      listAttachment.value = data;
      print("INI MAIN EDIT");
    }else if(isParent.value == true && isEdit.value == true){
      final data = await rep.getAttachment(mItemParent.value?.id ?? "");
      listAttachment.value = data;
      print("INI PARENT EDIT");
    }else{
      print("INI PARENT / MAIN ??");
      listAttachment.clear();
    }
  }

  getAllAttachment() async {
    final data = await rep.getAllAttachment();
    listAllAttachment.value = data;
    listSearchAttachment.value = data;
    backupListAttc.assignAll(data);
  }

  searchQuery(String query) {
    if (query.trim().isNotEmpty) {
      final results = listAllAttachment.where((attachment) =>
        attachment.title?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
      listSearchAttachment.assignAll(results);
    } else {
      listSearchAttachment.assignAll(backupListAttc);
    }
  }

  popUpAttachment() async {
    Get.defaultDialog(
      title: 'Attachment',
      content: Obx(() => SizedBox(
            width: 300,
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: listAttachment.length,
                    itemBuilder: (context, index) {
                      final data = listAttachment[index];
                      return MyStyles.myCard(
                        "${data.title}",
                        ['Type : ${data.mime}'],
                        [Icons.info_outline],
                        [() {
                          MyStyles.showFilePreview('${ApiService.mediaUrl}${data.path}', '${data.mime}');
                        }],
                        iconColors: [Colors.amber]
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                MyStyles.myButton('Edit Attachment', () async {
                  listNewAttachment.assignAll(listAttachment);
                  await getAllAttachment(); 
                  if (Get.isDialogOpen ?? false) {
                    Get.back();
                  }
                  await Future.delayed(Duration(milliseconds: 100));
                  popUpSearchAttachment(); 
                }),

              ],
            ),
          )),
      onConfirm: () {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      },
    );
  }

  popUpSearchAttachment() {
    Get.defaultDialog(
      title: 'Cari Attachment',
      content: Obx(() => SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                const SizedBox(height: 5),
                MyStyles.textfield(
                  'Cari',
                  searchAttachment.value,
                  onChanged: (value) {
                    searchQuery(value);
                  },
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                    itemCount: listSearchAttachment.length,
                    itemBuilder: (context, index) {
                      final data = listSearchAttachment[index];
                      return Obx(() => CheckboxListTile(
                            title: Text(data.title ?? ""),
                            value: listNewAttachment
                                .any((attachment) => attachment.id == data.id),
                            onChanged: (bool? value) {
                              if (value == true) {
                                if (!listNewAttachment.any(
                                    (attachment) => attachment.id == data.id)) {
                                  listNewAttachment.add(data);
                                }
                              } else {
                                listNewAttachment.removeWhere(
                                    (attachment) => attachment.id == data.id);
                              }
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            secondary: IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed: () {
                                MyStyles.showFilePreview('${ApiService.mediaUrl}${data.path}', data.mime);
                              },
                            ),
                          ));
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          )),
      onConfirm: () {
        listAttachment.clear();
        listAttachment.assignAll(listNewAttachment);
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      },
    );
  }

  onDeleteItem(ItemModel item)async{
    Get.defaultDialog(
      title: "Hapus Item",
      middleText: "Semua data didalam item ini akan terhapus, Apakah anda yakin ingin melanjutkan ?",
      textCancel: "Batal",
      textConfirm: "Hapus",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await rep.delete(item.id);

        // if (response != false) {
        //   MyStyles.snackbar('Berhasil Menghapus Data');
        await getParent();
        // } else {
        //   MyStyles.snackbar('Gagal Menghapus Data');
        // }
        // Future.delayed(Duration(seconds: 1));
        Get.back();
      },
    );
  }
  
  updatedOrder(ItemModel modelTarget, ItemModel modelMoved)async{
    final respone = await rep.updatedOrder(modelTarget, modelMoved, mPackage.value?.id ?? "");
    if(respone == true){
      await getParent();
    }
  }
}