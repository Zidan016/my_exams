import 'dart:convert';

import 'package:get/get.dart';
import 'package:my_exams/features/attachment/data/models/MAttachable.dart';
import 'package:my_exams/features/attachment/data/models/MAttachment.dart';
import 'package:my_exams/features/items/data/models/ItemAnswer.dart';
import 'package:my_exams/core/service/ApiService.dart';
import 'package:my_exams/features/items/data/models/MAnswer.dart';
import 'package:my_exams/features/items/data/models/MItem.dart';

class Iarepository {

  ApiService api = Get.find<ApiService>();

  Future firstInit(id)async{
    final respone = await api.format({
      "package_id": id
    }, 'package/add-first-intro');
    return respone != null ? true : false;
  }

  Future getItemAnswer(String packageId) async {
    final response = await api.format(
      {'id': packageId},
      'items/byPackage',
    );
    print(response);
    List<dynamic> decodedData = response != null ? jsonDecode(response) : [];
    print(decodedData);
    List<ItemAnswer> data = decodedData
        .map((item) => ItemAnswer.fromJson(item as Map<String, dynamic>))
        .toList();
    return data;
  }

  Future getParent(String itemId) async {
    final response = await api.format(
      {'id': itemId},
      'items/by-parent',
    );
    List<dynamic> decodedData = response != null ? jsonDecode(response) : [];
    List<ItemAnswer> data = decodedData
        .map((item) => ItemAnswer.fromJson(item as Map<String, dynamic>))
        .toList();
    return data;
  } 

  setMainItem(List<ItemAnswer> data){
    List<ItemAnswer> mainItems = data.where((item) => item.itemModel.parentId == null).toList();
    return mainItems;
  }

  setParentItem(parentId, List<ItemAnswer> data){
    List<ItemAnswer> getParent = data.where((item)=> item.itemModel.parentId == parentId).toList();
    return getParent;
  }

  Future add(ItemModel model, List<AnswerModel> answer, packageId, status, List<AttachmentModel> attachment)async{
    final respone = await api.format({
        "item": model.toJson(),
        "answer": answer.map((e) =>e.toJson()).toList(),
        "package_id": packageId,
        "status": status,
        "attachment": attachment.map((e)=> e.toJson()).toList()
    }, 'items/add');
    return respone != null ? true : false;
  }

Future update(ItemModel model, itemId, List<AnswerModel> answer, packageId, List<AttachmentModel> attachment)async{
    final respone = await api.format({
        "item_id":itemId,
        "item": model.toJson(),
        "answers": answer.map((e)=> e.toJson()).toList(),
        "package_id": packageId,
        "attachment": attachment.map((e)=> e.toJson()).toList()
    }, 'items/edit');
    return respone != null ? true : false;
  }

  Future getAttachment(String itemId) async {
    final response = await api.format(
      {'id': itemId},
      'attachment/get-by-id',
    );
    List<dynamic> decodedData = response != null ? jsonDecode(response) : [];
    List<AttachmentModel> data = decodedData
        .map((item) => AttachmentModel.fromJson(item as Map<String, dynamic>))
        .toList();
    return data;
  }

  Future getAllAttachment() async {
    final response = await api.format(
      {},
      'attachment/all',
    );
    List<dynamic> decodedData = response != null ? jsonDecode(response) : [];
    List<AttachmentModel> data = decodedData
        .map((item) => AttachmentModel.fromJson(item as Map<String, dynamic>))
        .toList();
    return data;
  }

  Future addAttachable(List<Attachable> model)async{
    final respone = await api.format({
      "data": model.map((e) => e.toJson()).toList()
    }, 'attachment/add-attachable');
    return respone != null ? true : false;
  }

  Future delete(String itemId)async{
    final respone = await api.format(({
      "id": itemId
    }), 'items/delete');
    return respone != null ? true : false;
  }

  Future updatedOrder(ItemModel modelTarget, ItemModel modelMoved, String packageId)async{
    final respone = await api.format(
      ({
        "model_target": modelTarget.toJson(),
        "model_moved": modelMoved.toJson(),
        "package_id": packageId
      }), 
      'items/updated-order');

    return respone != null ? true : false;
  }
} 