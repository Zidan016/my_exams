import 'package:get/get.dart';
import 'package:my_exams/core/service/SocketService.dart';
import 'package:my_exams/features/attachment/data/repository/RepAttachment.dart';
import 'package:my_exams/features/attachment/presentation/controller/CAttachment.dart';
import 'package:my_exams/features/exams/presentation/controller/CExams.dart';
import 'package:my_exams/features/home/Chome.dart';
import 'package:my_exams/features/package/presentation/controller/CFirstPackage.dart';
import 'package:my_exams/features/package/presentation/controller/CSecondPackage.dart';
import 'package:my_exams/features/participants/presentation/controller/Cpreview.dart';
import 'package:my_exams/features/proctors/data/repository/socketRep.dart';
import 'package:my_exams/features/proctors/presentation/controller/CProctor.dart';
import 'package:my_exams/features/student/data/repository/RepStudent.dart';
import 'package:my_exams/features/student/presentation/controller/CSection.dart';
import 'package:my_exams/features/student/presentation/controller/CStudent.dart';
import 'package:my_exams/features/student/presentation/controller/Cuexmas.dart';
import 'package:my_exams/features/items/presentation/controller/Csoal.dart';
import 'package:my_exams/features/package/presentation/controller/CPackage.dart';
import 'package:my_exams/features/participants/presentation/controller/CParticipant.dart';
import 'package:my_exams/features/items/presentation/controller/Citem.dart';
import 'package:my_exams/features/exams/data/repository/ExamsRepository.dart';
import 'package:my_exams/features/items/data/repository/IARepository.dart';
import 'package:my_exams/features/package/data/repository/PackageRepository.dart';
import 'package:my_exams/features/participants/data/repository/ParticipantRepo.dart';
import 'package:my_exams/core/service/ApiService.dart';
import 'package:my_exams/features/users/data/repository/UsersRepository.dart';
import 'package:my_exams/features/users/presentation/controller/UserController.dart';

class Mainbinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ApiService(), fenix: true);
    Get.lazyPut(()=> Packagerepository(), fenix: true);
    Get.lazyPut(()=> Cpackage(), fenix: true);
    Get.lazyPut(()=> Citem(), fenix: true);
    Get.lazyPut(()=> Iarepository(), fenix: true);
    Get.lazyPut(()=> Cexams(), fenix: true);
    Get.lazyPut(()=> Examsrepository(), fenix: true);
    Get.lazyPut(()=> Participantrepo(), fenix: true);
    Get.lazyPut(()=> Cparticipant(), fenix: true);
    Get.lazyPut(()=> CAttachment(), fenix: true);
    Get.lazyPut(()=> AttachmentRepository(), fenix: true);
    Get.lazyPut(()=> Csoal(), fenix: true);
    Get.lazyPut(()=> Cuexmas(), fenix: true);
    Get.lazyPut(()=> UserRepository(), fenix: true);
    Get.lazyPut(()=> UserController(), fenix: true);
    Get.lazyPut(()=> Repstudent(), fenix: true);
    Get.lazyPut(()=> Csection(), fenix: true);
    Get.lazyPut(()=> Cstudent(), fenix: true);
    Get.lazyPut<SocketService>(() {
        final service = SocketService();
        service.init();
        return service;
     }, fenix: true);    
    Get.lazyPut(()=> RepSocket(), fenix: true);
    Get.lazyPut(()=> Cproctor(), fenix: true);
    Get.lazyPut(()=> Chome(), fenix: true);
    Get.lazyPut(()=> Cfirstpackage(), fenix: true);
    Get.lazyPut(()=> Csecondpackage(), fenix: true);
    Get.lazyPut(()=> Cpreview(), fenix: true);
  }
}