import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/service/LocalService.dart';
import 'package:my_exams/core/helper/web_helper_stub.dart'
  if (dart.library.html) 'package:my_exams/core/helper/web_helper.dart';
import 'package:http/http.dart' as http;
import 'package:restart_app/restart_app.dart';

class ApiService {
  static String url = 'https://ap1.winsz.my.id/';
  static String mediaUrl = 'https://ap1.winsz.my.id/static/';
  static bool isActive = false;

  final _pref = Get.find<LocalService>();
  
  Future<bool> verify() async {
    try {
      var auth = await _pref.getAuth();

      if (auth.isEmpty) {
        print("Token auth tidak ditemukan!");
        return false;
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {"authorization": auth},
      );

      if (response.statusCode == 200) {
        print("Verifikasi sukses!");
        return true;
      } else if (response.statusCode == 401) {
        print("Token tidak valid, alihkan ke Login");
        if(kIsWeb){
          reloadPage();
        }else{
          Restart.restartApp(
            notificationTitle: 'Restarting App',
            notificationBody: 'Please tap here to open the app again.',);
        }
        return false;
      } else {
        print("Verifikasi gagal! Status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error di verify(): $e");
      return false;
    }
  }

  Future<dynamic> format(dynamic body, String uri) async {
    try {
      EasyLoading.show(status: 'Loading...');
      final getConnection = await verify();
      if (getConnection) {
        var auth = await _pref.getAuth();
        final response = await http.post(
          Uri.parse(url + uri),
          headers: {
            "authorization": auth,
            "Content-Type": "application/json"
          },
          body: jsonEncode(body),
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          print("Request berhasil");
          EasyLoading.showSuccess('Berhasil', duration: Duration(milliseconds: 500));
          return response.body;
        } else if (response.statusCode == 401) {
          print("Token tidak valid, alihkan ke Login");
          EasyLoading.showError('Token tidak valid');
          await Future.delayed(const Duration(seconds: 1));
          if(kIsWeb){
            reloadPage();
          }else{
            Restart.restartApp(
              notificationTitle: 'Restarting App',
              notificationBody: 'Please tap here to open the app again.',);
          }
          return null;
        } else {
          print("Request gagal! Status: ${response.statusCode}, Body: ${response.body}");
          // EasyLoading.showError('Gagal: ${response.statusCode}');
          return null;
        }
      } else {
        print("Koneksi gagal, alihkan ke Login");
        EasyLoading.showError('Tidak ada koneksi internet');
        return null;
      }
    } catch (e) {
      print("Error di format(): $e");
      EasyLoading.showError('Terjadi kesalahan: $e');
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }


  Future<dynamic> fileFormat(dynamic body, String uri, File file) async {
    try {
      EasyLoading.show(status: 'Loading...');
      final getConnect = await verify();
      if (getConnect){
        var auth = await _pref.getAuth();
        final request = http.MultipartRequest(
          'POST',
          Uri.parse(url + uri),
        );

        request.fields['data'] = jsonEncode(body);
        request.headers['authorization'] = auth;

        final multipartFile = await http.MultipartFile.fromPath(
          'file',
          file.path,
        );
        request.files.add(multipartFile);

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else {
          print("Request gagal! Status: ${response.body}");
          return null;
        }
      }else{
        print("Koneksi gagal, alihkan ke Login");
        EasyLoading.showError('Token tidak valid');
          await Future.delayed(const Duration(seconds: 1)); // beri jeda agar error terlihat
          if(kIsWeb){
            reloadPage();
          }else{
            Restart.restartApp(
              notificationTitle: 'Restarting App',
              notificationBody: 'Please tap here to open the app again.',);
          }
        return null;
      }

      
    } catch (e) {
      print("Error di fileFormat(): $e");
      EasyLoading.showError('Terjadi kesalahan: $e');
      return null;
    }finally{
      EasyLoading.dismiss();
    }
  }

}