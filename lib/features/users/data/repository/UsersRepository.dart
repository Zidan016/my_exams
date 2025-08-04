import 'dart:convert';

import 'package:get/get.dart';
import 'package:my_exams/core/service/ApiService.dart';
import 'package:my_exams/features/users/data/models/MUsersRoles.dart';

class UserRepository{
  ApiService api = Get.find<ApiService>();

  Future getAdmin()async{
    final respone = await api.format({'role_id': '1'}, 'users/getByRole');
    List<dynamic> decoded = jsonDecode(respone);
    List<MUsersRoles> data = decoded.map((e)=> MUsersRoles.fromJson(e as Map<String, dynamic>)).toList();
    return respone != null ? data : [];
  }

  Future nonAktif(String id)async{
    final respone = await api.format({"id": id}, 'users/non-aktif');
    return respone != null ? true : false;
  }

  Future getTeacher()async{
    final respone = await api.format({'role_id': '3'}, 'users/getByRole');
    List<dynamic> decoded = jsonDecode(respone);
    List<MUsersRoles> data = decoded.map((e)=> MUsersRoles.fromJson(e as Map<String, dynamic>)).toList();
    return respone != null ? data : [];
  }

  Future getProctor()async{
    final respone = await api.format({'role_id': '4'}, 'users/getByRole');
    List<dynamic> decoded = jsonDecode(respone);
    List<MUsersRoles> data = decoded.map((e)=> MUsersRoles.fromJson(e as Map<String, dynamic>)).toList();
    return respone != null ? data : [];
  }

  Future getStudent()async{
    final respone = await api.format({'role_id': '5'}, 'users/getByRole');
    List<dynamic> decoded = jsonDecode(respone);
    List<MUsersRoles> data = decoded.map((e)=> MUsersRoles.fromJson(e as Map<String, dynamic>)).toList();
    return respone != null ? data : [];
  }

  Future addStudent(user, role)async{
    final respone = await api.format(
      {
        'users': user,
        'role':role
      }, 'users/add');
    return respone != null ? true : false;
  }

  Future editStudent(user, role)async{
    final respone = await api.format(
      {
        'users': user,
        'role':role
      }, 'users/edit');
    return respone != null ? true : false;
  }
}