import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/service/ApiService.dart';
import 'package:my_exams/features/attachment/data/models/MAttachment.dart';
import 'package:my_exams/features/items/data/models/MAnswer.dart';
import 'package:my_exams/features/login/presentation/pages/login.dart';
import 'package:my_exams/features/student/data/models/sectionItemAnswers.dart';

class MyStyles {
  static Widget textContentSmall(String text){
    return Text(text, style: TextStyle(fontSize: 14, fontFamily: 'Poppins', color: Colors.black));
  }

  static Widget textContentMedium(String text){
    return Text(text, style: TextStyle(fontSize: 18, fontFamily: 'Poppins', color: Colors.black));
  }

  static Widget overlayLoading({required bool isLoading, required Widget child}) {
    return Stack(
      children: [
        child,
        if (isLoading)
          IgnorePointer(
            ignoring: false,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  static Widget textContentLarge(String text){
    return Text(text, style: TextStyle(fontSize: 22, fontFamily: 'Poppins', color: Colors.black));
  }

  static Widget textHeadlineSmall(String text){
    return Text(text, style: TextStyle(fontSize: 14, fontFamily: 'Poppins', color: Colors.black, fontWeight: FontWeight.bold));
  }

  static Widget textHeadlineMedium(String text){
    return Text(text, style: TextStyle(fontSize: 18, fontFamily: 'Poppins', color: Colors.black, fontWeight: FontWeight.bold));
  }

  static Widget textHeadlineLarge(String text){
    return Text(text, style: TextStyle(fontSize: 22, fontFamily: 'Poppins', color: Colors.black, fontWeight: FontWeight.bold));
  }

  static Widget textLightSmall(String text){
    return Text(text, style: TextStyle(fontSize: 14, fontFamily: 'Poppins', color: const Color.fromARGB(255, 86, 86, 86), fontWeight: FontWeight.w300));
  }

  static Widget textLightMedium(String text){
    return Text(text, style: TextStyle(fontSize: 18, fontFamily: 'Poppins', color: const Color.fromARGB(255, 86, 86, 86), fontWeight: FontWeight.w300));
  }

  static Widget textLightLarge(String text){
    return Text(text, style: TextStyle(fontSize: 22, fontFamily: 'Poppins', color: const Color.fromARGB(255, 86, 86, 86), fontWeight: FontWeight.w300));
  }

  static Widget myButton(String text, VoidCallback onPressed, {Color? color}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text, style:Theme.of(Get.context!).textTheme.bodySmall ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color ?? Colors.indigo),
      ),
    );
  }

  static Widget myCard(
    String title,
    List<String> contents,
    List<IconData> icons,
    List<VoidCallback> onIconPressed, {
    List<Color>? iconColors,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ...contents.map((content) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(content),
                  )).toList(),
                ],
              ),
            ),
            Row(
              children: List.generate(icons.length, (index) => IconButton(
                icon: Icon(
                  icons[index],
                  color: iconColors != null && iconColors.length > index
                      ? iconColors[index]
                      : null,
                ),
                onPressed: onIconPressed[index],
              )),
            ),
          ],
        ),
      ),
    );
  }

  static Widget showLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static Widget hideLoading() {
    return const SizedBox.shrink();
  }

  static Widget soalCard(
    String questionHtml,
    List<AnswerModel> answers,
    ValueChanged<int?> onChanged,
    List<AttachmentModel>? attachments,
    String order,
    {VoidCallback? onDel}
  ) {
    int groupValue = answers.indexWhere((e) => e.corretAnswer == 1);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textLightSmall(order),
            SizedBox(height: 5,),
            if (attachments != null && attachments.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    attachments.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: myButton(
                        '${attachments[index].mime == 'audio/mpeg' ? 'lihat audio-${index}' : 'lihat gambar-${index}'}',
                        () {
                          showFilePreview(
                            '${ApiService.mediaUrl}${attachments[index].path}',
                            attachments[index].mime,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              )
            else
              SizedBox.shrink(),

            Html(data: questionHtml),
            const SizedBox(height: 5),
            ...List.generate(answers.length, (index) => RadioListTile<int>(
              title: Text(answers[index].content ?? ''),
              value: index,
              groupValue: groupValue,
              onChanged: onChanged,
            )),
            SizedBox(height: 5,),
            IconButton(
              onPressed: onDel, 
              icon: Icon(Icons.delete, color: Colors.red,)
            )
          ],
        ),
      ),
    );
  }

  static Widget previewCard(
    Sectionitemanswers answers,
    ValueChanged<int?> onChanged,
  ) {
    int? groupValue;
    if (answers.participantSectionItemAttempts?.answer != null) {
      final index = answers.participantItemAnswers.indexWhere(
        (it) => it.content == answers.participantSectionItemAttempts?.answer,
      );
      groupValue = index >= 0 ? index : null;
    }


    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Row(
              children: [
                if (answers.participantSectionItemAttempts != null) ...[
                answers.participantSectionItemAttempts!.isCorrect == 1
                    ? const Icon(Icons.check_outlined, color: Colors.green)
                    : const Icon(Icons.clear, color: Colors.red),
                const SizedBox(width: 5),
                textContentSmall('${answers.particiapantSectionItems.label}'),
              ],
              ],
            ),
            SizedBox(height: 5,),
            if (answers.attachment.isNotEmpty)
              Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                answers.attachment.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: myButton(
                  '${answers.attachment[index].mime == 'audio/mpeg' ? 'lihat audio-${index}' : 'lihat gambar-${index}'}',
                  () {
                    showFilePreview(
                    '${ApiService.mediaUrl}${answers.attachment[index].path}',
                    answers.attachment[index].mime,
                    );
                  },
                  ),
                ),
                ),
              ),
              )
            else
              SizedBox.shrink(),
            
            Html(data: answers.particiapantSectionItems.content),
            if (answers.particiapantSectionItems.subContent != null)
              Html(data: answers.particiapantSectionItems.subContent!),
            const SizedBox(height: 5),
            ...List.generate(
              answers.participantItemAnswers.length,
              (index) => RadioListTile<int>(
                title: Text(
                  '${answers.participantItemAnswers[index].content}'
                  // '${answers.participantItemAnswers[index].correctAnswer == 1 ? " (Benar)" : ""}',
                ),
                selected: answers.participantItemAnswers[index].correctAnswer == 1,
                selectedTileColor: answers.participantItemAnswers[index].correctAnswer == 1 ? const Color.fromARGB(255, 219, 255, 220) : null,
                value: index,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget textfield(String hintText, TextEditingController controller, {ValueChanged<String>? onChanged}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: hintText,
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }

  static Widget obscureText(String hintText, TextEditingController controller, bool isObsecure) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: hintText,
        border: OutlineInputBorder(),
      ),
      obscureText: isObsecure ? false : true,
    );
  }

  static snackbar(String message) {
    Get.snackbar(
      'Informasi',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: EdgeInsets.all(16),
      duration: Duration(seconds: 1),
    );
  }

  static void showLoadingPopup() {
    if (!(Get.isDialogOpen ?? false)) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (_) => const Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }
  }

  static void hideLoadingPopup() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  static void safeNavigateToLogin() {
    if (Get.isDialogOpen ?? false) {
      Get.back(); // Tutup dialog jika terbuka
    }
    Get.offAll(() => Login());
  }




  static Widget checkbox(String title, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  static information( String text, {String? title, bool isCancel = false, VoidCallback? onOk, VoidCallback? onCancel}) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: textHeadlineMedium('${title ?? 'Infromasi'}'),
          content: textContentSmall(text),
          actions: [
            if (isCancel)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onCancel != null) onCancel();
                },
                child: Text('Batal'),
              ),
            TextButton(
              onPressed: () {
                if (onOk != null) onOk();
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  static Widget dateTimePicker({
    required DateTime initialDate,
    required ValueChanged<DateTime> onDateChanged,
    required TimeOfDay initialTime,
    required ValueChanged<TimeOfDay> onTimeChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: Get.context!,
              initialDate: initialDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              onDateChanged(pickedDate);
            }
          },
          child: Text(
            'Select Date: ${initialDate.toLocal()}'.split(' ')[0],
            style: TextStyle(fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: Get.context!,
              initialTime: initialTime,
            );
            if (pickedTime != null) {
              onTimeChanged(pickedTime);
            }
          },
          child: Text(
            'Select Time: ${initialTime.format(Get.context!)}',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  static Widget cardWithCheckbox(String title, bool value, ValueChanged<bool?> onChanged) {
    return Card(
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Checkbox(
                value: value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget filePreviewCard(String fileName, String mime, VoidCallback onPreview) {
    return Card(
      child: ListTile(
        leading: Icon(
          mime == 'image/jpeg'
              ? Icons.image
              : mime == 'audio/mpeg'
                  ? Icons.audiotrack
                  : Icons.insert_drive_file,
        ),
        title: Text(fileName),
        trailing: IconButton(
          icon: Icon(Icons.preview),
          onPressed: onPreview,
        ),
      ),
    );
  }

  static void showFilePreview(String filePath, String fileType) {
    final player = AudioPlayer();
    Duration? totalDuration;
    Duration? currentPosition;

    if (fileType == 'audio/mpeg') {
      player.setSourceUrl(filePath).catchError((error) {
        print('Error setting audio source: $error');
      });
    }

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            if (fileType == 'audio/mpeg') {
              player.onDurationChanged.listen((duration) {
                setState(() {
                  totalDuration = duration;
                });
              });

              player.onPositionChanged.listen((position) {
                setState(() {
                  currentPosition = position;
                });
              });
            }

            return AlertDialog(
              content: fileType == 'image/jpeg' || fileType == 'image/png' || fileType == 'image/jpg' 
                  ? Image.network(filePath, fit: BoxFit.cover)
                  : fileType == 'audio/mpeg'
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.audiotrack, size: 50),
                            SizedBox(height: 10),
                            Text('Jika durasi atau foto tidak terlihat maka data tidak ada di dalam server'),
                            SizedBox(height: 10),
                            if (totalDuration != null && currentPosition != null)
                              Text(
                                '${currentPosition!.inMinutes}:${(currentPosition!.inSeconds % 60).toString().padLeft(2, '0')} / ${totalDuration!.inMinutes}:${(totalDuration!.inSeconds % 60).toString().padLeft(2, '0')}',
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    player.pause();
                                  },
                                  child: Text('Pause'),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    player.resume();
                                  },
                                  child: Text('Play'),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Text('Unsupported file type'),
              actions: [
                TextButton(
                  onPressed: () {
                    if (fileType == 'audio/mpeg') {
                      player.stop();
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static void showQuestionPopup(List<Sectionitemanswers> question, void Function(int) onload, VoidCallback endexam) {
    Get.dialog(
      AlertDialog(
        title: Text('Daftar Soal'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: question.length,
            itemBuilder: (context, index) {
              final q = question[index];
              final isAttempted = q.participantSectionItemAttempts != null ? true : false;
              return GestureDetector(
                onTap: () {
                  Get.back();
                  onload(index);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isAttempted ? Colors.blue : Colors.yellow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Soal ${index + 1}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              endexam();
            },
            child: Text('Akhiri Sesi'),
          ),
        ],
      ),
    );
  }
}