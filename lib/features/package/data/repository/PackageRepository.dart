import 'dart:convert';

import 'package:get/get.dart';
import 'package:my_exams/features/package/data/models/MPackage.dart';
import 'package:my_exams/core/service/ApiService.dart';

class Packagerepository {
  final api = Get.find<ApiService>();

  Future main()async{
    final respone = await api.format({}, 'package/getMain');
    final List<dynamic> data = respone != null ? jsonDecode(respone) : [];
    List<PackageModel> main = data.map((e) => PackageModel.fromJson(e as Map<String, dynamic>)).toList();
    return main;
  }

  Future update(PackageModel model)async{
    final respone = await api.format(model, 'package/edit');
    return respone != null ? true : false;
  }

  Future add(PackageModel model)async{
    final respone = await api.format({
      "packages": model.toJson(),
      }, 'package/add');
    return respone != null ? true : false;
  }

  Future byParent(id)async{
    final response = await api.format({"parent_id": id}, 'package/byParent');
    final List<dynamic> data = response != null ? jsonDecode(response) : [];
    List<PackageModel> main = data.map((e) => PackageModel.fromJson(e as Map<String, dynamic>)).toList();
    return main;
  }

  Future delete(String id)async{
    final respone = await api.format({"id": id}, 'package/delete');
    return respone != null ? true : false;
  }

  Future checkPackage(String id)async{
    final respone = await api.format({"id": id}, 'items/byPackage');
    final List<dynamic> data = respone != null ? jsonDecode(respone) : [];
    return data.isNotEmpty ? true : false;
  }
}