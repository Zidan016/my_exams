import 'dart:convert';

import 'package:get/get.dart';
import 'package:my_exams/core/service/ApiService.dart';
import 'package:my_exams/core/service/SocketService.dart';
import 'package:my_exams/features/proctors/data/models/Mprt.prtlog.dart';
import 'package:my_exams/features/proctors/data/models/prtLogs.dart';
import 'package:my_exams/features/proctors/data/models/prtUsers.dart';
import 'package:my_exams/features/student/data/models/participantLogs.dart';

class RepSocket {
  final socket = Get.find<SocketService>();
  ApiService api = Get.find<ApiService>();

  Future getParticiapnt(String examId) async {
    final respone = await api.format(
      {
        'examId': examId,
      },
      'proctors/get-participant-exam',
    );
    List<dynamic> decodedData = respone != null ? jsonDecode(respone) : [];
    List<MParticipantUserLogs> data = decodedData
        .map((item) => MParticipantUserLogs.fromJson(item as Map<String, dynamic>))
        .toList();
    return data;
  }

  Future getPartLogs(String prtId) async {
    final respone = await api.format(
      {
        'prtId': prtId,
      },
      'proctors/get-logs',
    );
    List<dynamic> decodedData = respone != null ? jsonDecode(respone) : [];
    List<MParticipantLogs> data = decodedData
        .map((item) => MParticipantLogs.fromJson(item as Map<String, dynamic>))
        .toList();
    return data;
  }
  
  getExamParticipant(Function(List<MParticipantUserLogs>) onData, String examId) {
    socket.on('participant-exam-$examId', (data) {
      List<MParticipantUserLogs> participants = (data as List)
          .map<MParticipantUserLogs>((e) => MParticipantUserLogs.fromJson(e as Map<String, dynamic>))
          .toList();
      onData(participants);
    });
    print('Function executed');
  }

  getLogs(Function(List<MParticipantLogs>) onData, String prtId) {
    socket.on('logs-$prtId', (data) {
      List<MParticipantLogs> logs = (data as List)
          .map<MParticipantLogs>((e) => MParticipantLogs.fromJson(e as Map<String, dynamic>))
          .toList();
      onData(logs);
    });
  }

  disconnetExam(String examId) {
    socket.off('participant-exam-$examId');
  }

  disconnectLogs(String prtId) {
    socket.off('logs-$prtId');
  }

  disconnectStudent(){
    socket.off('section-data');
  }

  Future disOrQual(String prtId, String status) async {
    final respone = await api.format(
    {
      'prtId': prtId,
      'status': status,
    }, 
    'proctors/dis-or-qual');
    print(respone);
    return respone != null ? true : false;
  }

  Future updateLogs(ParticipantLogs logs, String examId)async{
    final respone = await api.format(
    {
      'logs': logs.toJson(),
      'examId': examId,
    }, 
    'proctors/set-logs');
    respone != null ? true : false;
  }

  Future endExam(String examId)async{
    final respone = await api.format(
    {
      'examId': examId,
    }, 
    'proctors/end-exams');
    return respone != null ? true : false;
  }

  Future getDashborad() async {
    final respone = await api.format({}, 'proctors/dahsboard');
    List<dynamic> decoded = respone != null ? jsonDecode(respone) : [];
    List<MExamsParticipants> data = decoded
        .map((it) => MExamsParticipants.fromJson(it as Map<String, dynamic>))
        .toList();
    return data;
  }

  socketDashboard(Function(List<MExamsParticipants>) onData) {
    socket.on('dashboard', (data) {
      if (data is List) {
        List<MExamsParticipants> result = data
            .map<MExamsParticipants>((it) => MExamsParticipants.fromJson(it as Map<String, dynamic>))
            .toList();
        onData(result);
      } else if (data is Map<String, dynamic>) {
        List<MExamsParticipants> result = [MExamsParticipants.fromJson(data)];
        onData(result);
      } else {
        print('Unexpected data type: ${data.runtimeType}');
      }
    });
  }
  
}