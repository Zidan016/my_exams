import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/service/ApiService.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/attachment/presentation/controller/CAttachment.dart';

class Attachment extends StatefulWidget {
  const Attachment({super.key});

  @override
  State<Attachment> createState() => _AttachmentState();
}

class _AttachmentState extends State<Attachment> {
  final controller = Get.find<CAttachment>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAll();
      controller.scroll.value.addListener(() {
        if (controller.scroll.value.position.pixels >=
          controller.scroll.value.position.maxScrollExtent - 100) {
          controller.loadMore();
        }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.isEdit.value = false;
          controller.showEdit();
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Obx(
            () => Column(
              children: [
                MyStyles.textfield('Cari File', controller.fieldSearch.value, onChanged: (value) {
                  controller.search(value);
                },),
                const SizedBox(height: 10),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => controller.getAll(),
                    child: ListView.builder(
                      controller: controller.scroll.value,
                      itemCount: controller.listPaged.isEmpty
                          ? 1
                          : controller.listPaged.length,
                      itemBuilder: (context, index) {
                        if (controller.listPaged.isEmpty) {
                          return const Center(
                            child: Text("No attachments available"),
                          );
                        }
                        final data = controller.listPaged[index];
                        return InkWell(
                          onTap: () {
                            controller.isEdit.value = true;
                            controller.urlPath.value = '${ApiService.mediaUrl}${data.path}';
                            controller.mAttachment.value = data;
                            controller.showEdit();
                          },
                          onLongPress: () {
                            controller.beforeDel(data.id);
                          },
                          child: MyStyles.myCard(
                            data.title ?? "Tidak ada Judul",
                            ['type : ${data.mime}'],
                            [Icons.info_outline],
                            [
                              () {
                                controller.showContent(data.path, data.mime);
                              }
                            ],
                            iconColors: [
                              const Color.fromARGB(255, 229, 179, 0)
                            ]
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}