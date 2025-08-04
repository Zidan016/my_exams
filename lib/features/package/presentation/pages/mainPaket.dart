import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/features/package/presentation/controller/CFirstPackage.dart';
import 'package:my_exams/features/package/presentation/controller/CPackage.dart';
import 'package:my_exams/features/package/presentation/pages/FirstPackage.dart';
import 'package:my_exams/core/style/styles.dart';

class Mainpaket extends StatefulWidget {
  const Mainpaket({super.key});

  @override
  State<Mainpaket> createState() => _MainpaketState();
}

class _MainpaketState extends State<Mainpaket> with SingleTickerProviderStateMixin {
  Cpackage cpackage = Get.find<Cpackage>();
  Cfirstpackage cfirstpackage = Get.find<Cfirstpackage>();

  @override
  void initState() {
    super.initState();
    cpackage.getMain();
    cpackage.scroll.value.addListener(() {
      if (cpackage.scroll.value.position.pixels >=
          cpackage.scroll.value.position.maxScrollExtent - 100) {
        cpackage.loadMore();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          cfirstpackage.isEdit.value = false;
          Get.to(Firstpackage());
        }, child: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Obx(()=> Column(
          children: [
            MyStyles.textfield(
            'Cari Paket', 
            cpackage.fieldSearch.value,
             onChanged: (value) {
              cpackage.search(value);
            },),
            const SizedBox(height: 16.0),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await cpackage.onRefresh();
                },
                child: Obx(() {
                  var data = cpackage.listpaged;
                  return ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: cpackage.scroll.value,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return InkWell(
                        onLongPress: (){
                          cpackage.onDeleteItem(item);
                        },
                        onTap: () {
                          cpackage.itemAwal.value = item;
                          cfirstpackage.mPackage.value = item;
                          cfirstpackage.isEdit.value = true;
                          Get.to(Firstpackage());
                        },
                        child:MyStyles.myCard(
                          item.title,
                          [item.description?? "Tidak ada deskripsi", item.createdAt.toString()], 
                          [], 
                          []
                        )
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),)
      ),
    );
  }
}