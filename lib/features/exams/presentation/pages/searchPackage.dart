import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/features/exams/presentation/controller/CExams.dart';
import 'package:my_exams/features/package/presentation/controller/CPackage.dart';
import 'package:my_exams/core/style/styles.dart';

class SearchPackage extends StatefulWidget {
  const SearchPackage({super.key});

  @override
  State<SearchPackage> createState() => _SearchPackageState();
}

class _SearchPackageState extends State<SearchPackage> {

  Cpackage cpackage = Get.find<Cpackage>();
  Cexams cexams = Get.find<Cexams>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cpackage.getMain();
      cpackage.scroll.value.addListener(() {
      if (cpackage.scroll.value.position.pixels >=
          cpackage.scroll.value.position.maxScrollExtent - 100) {
        cpackage.loadMore();
      }
    });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        title: Text('Cari Paket'),
      )),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MyStyles.textfield('Cari Paket', cpackage.fieldSearch.value, onChanged: (value) {
                cpackage.search(value);
              },),
              const SizedBox(height: 16.0),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await cpackage.getMain();
                  },
                  child: Obx(() {
                    var data = cpackage.listpaged;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return InkWell(
                          onTap: () {
                            cexams.packageName.value = item.title;
                            cexams.packageId.value = item.id.toString();
                            Get.back();
                          },
                          child: MyStyles.myCard(
                            item.title,
                            [item.description?? "Tidak ada deskripsi", item.createdAt.toString()], 
                            [],[]
                          ),
                        );
                      },
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}