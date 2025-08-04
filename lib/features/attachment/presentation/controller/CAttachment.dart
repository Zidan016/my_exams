import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:my_exams/core/helper/PaggingHelper.dart';
import 'package:my_exams/core/helper/helper.dart';
import 'package:my_exams/core/service/ApiService.dart';
import 'package:my_exams/core/service/LocalService.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/attachment/data/models/MAttachment.dart';
import 'package:my_exams/features/attachment/data/repository/RepAttachment.dart';

class CAttachment extends GetxController{
  var fieldSearch = TextEditingController().obs;
  final rep = Get.find<AttachmentRepository>();
  var listAttachment = <AttachmentModel>[].obs;
  var listPaged = <AttachmentModel>[].obs;
  var scroll = ScrollController().obs;
  var urlPath = "".obs;
  late PaginationHelper<AttachmentModel> paginator;
  final mAttachment = Rxn<AttachmentModel>();
  final isEdit = false.obs;
  final delBtn = false.obs;
  final fieldTitle = TextEditingController().obs;
  LocalService local = LocalService();
  File? selectedFile;
  var mimeType = "".obs;
  Helper helper = Helper();

  getAll()async{
    final response = await rep.getAttachment();
    listAttachment.value = response;

    paginator = PaginationHelper<AttachmentModel>(
      fullList: listAttachment,
      itemsPerPage: 10,
      filterFunc: (p0, p1) => p0.title?.toLowerCase().contains(p1.toLowerCase()) ?? false,
    );
    listPaged.value = paginator.loadMore();
  }

  void loadMore() {
      final moreData = paginator.loadMore();
      if (moreData.isNotEmpty) {
        listPaged.addAll(moreData);
      }
    }

  void search(String query) {
    paginator.search(query);
    listPaged.value = paginator.loadMore();
  }

  showContent(url, type){
    MyStyles.showFilePreview('${ApiService.mediaUrl}${url}', type);
  }

  Future pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg', 'jpeg', 'png', 'gif',
          'mp3', 'aac', 'wav', 'ogg', 'm4a'
        ],
      );


        if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final mime = lookupMimeType(filePath);

        print("MIME Type: $mime");

        if (mime != null &&
            (mime.startsWith('image/') || mime.startsWith('audio/'))) {
          selectedFile = File(filePath);
          mimeType.value = mime;
          print("File dipilih: ${selectedFile!.path}");
          urlPath.value = selectedFile!.path;
        } else {
          selectedFile = null;
          MyStyles.snackbar("File harus berupa gambar atau audio.");
        }
      }
    } catch (e) {
      print('Error picking file: $e');
      selectedFile = null;
    }
  }

  showEdit() {
    setUI();
    Get.defaultDialog(
      title: "Edit Attachment",
      content: Obx(
        ()=> Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: fieldTitle.value,
              decoration: InputDecoration(labelText: "Judul"),
            ),
            const SizedBox(height: 10),
            MyStyles.textLightSmall('File : ${urlPath.value}'),
            SizedBox(height: 3,),
            MyStyles.myButton('Pilih File', () async {
              await pickFile();
            }, color: const Color.fromARGB(255, 229, 179, 0)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () async {
                    var userId = await local.getId();
                    if (selectedFile == null) return;

                    if (isEdit.value == true) {
                      final data = AttachmentModel(
                        id: mAttachment.value?.id ?? "",
                        user_id: userId,
                        title: fieldTitle.value.text,
                        mime: mimeType.value,
                        path: 'path',
                        type: 'attachment',
                      );
                      print(data.toJson());
                      final response = await rep.updateAttachment(data, selectedFile!);
                      if (response == true) {
                        await getAll();
                        Get.back();
                      } else {
                        MyStyles.snackbar('Gagal update data');
                      }
                    } else {
                      final data = {
                        'title': fieldTitle.value.text,
                        'user_id': userId,
                        'type': 'attachment',
                        'description': null,
                        'options': null,
                        'mime_type': mimeType.value
                      };
                      await rep.addAttachment(data, selectedFile!);
                      await getAll();
                      Get.back();
                    }
                  },
                  child: Text("Simpan"),
                ),
                TextButton(
                  onPressed: (){
                    Get.back();
                  }, 
                  child: Text('Batal')
                )
              ],
            )
          ],
        ),
      )
    );
  }
  
  setUI(){
    if(isEdit.value){
      fieldTitle.value.text = mAttachment.value?.title ?? "Tidak ada Judul";
      delBtn.value = true;
    }else{
      fieldTitle.value.text = "";
      delBtn.value = false;
      urlPath.value = "Belum ada file";
    }
  }

  del(String id)async{
    MyStyles.showLoadingPopup();
    await rep.delete(id);
    await getAll();
    Get.back();
  }

  beforeDel(String id){
    MyStyles.information('Apakah anda yakin ingin menghapus data ?',title: 'Hapus Data', isCancel: true, onOk: () {
      del(id);
    },);
  }
}
