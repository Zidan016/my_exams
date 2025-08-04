import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:my_exams/core/service/ApiService.dart';
import 'package:my_exams/features/attachment/data/models/MAttachment.dart';
import 'package:my_exams/features/student/data/models/participantItemAnswers.dart';
import 'package:my_exams/features/student/data/models/participantSectionItemAttempts.dart';

class ExamsSoal extends StatefulWidget {
  final String number;
  final String questionHtml;
  final String? subContent;
  final List<ParticipantItemAnswers> answers;
  final ParticipantSectionItemAttempts? attempts;
  final ValueChanged<int?> onChanged;
  final List<AttachmentModel>? attachments;
  final bool itemDuration;
  final VoidCallback? onAudioComplete;

  const ExamsSoal({
    Key? key,
    required this.number,
    required this.questionHtml,
    this.subContent,
    required this.answers,
    this.attempts,
    required this.onChanged,
    this.attachments,
    required this.itemDuration,
    this.onAudioComplete,
  }) : super(key: key);

  @override
  _ExamsSoalState createState() => _ExamsSoalState();
}

class _ExamsSoalState extends State<ExamsSoal> {
  late AudioPlayer _player;
  int duration = 12;
  Timer? timer;
  Future<void>? _audioFuture;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    final audioUrls = widget.attachments
            ?.where((att) => att.mime == 'audio/mpeg' || att.mime == 'audio/mp3')
            .map((att) => '${ApiService.mediaUrl}${att.path}')
            .toList() ??
        [];

    if (audioUrls.isNotEmpty) {
      _audioFuture = playAudioSequentially(audioUrls);
    } else if (widget.itemDuration) {
      setItemDuration();
    }

    print(widget.attachments?.map((e)=> e.toJson()).toList());
  }

  void setItemDuration() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timerItem) {
      if (duration == 0) {
        timerItem.cancel();
        if (widget.onAudioComplete != null) {
          widget.onAudioComplete!(); // Callback setelah waktu habis
        }
      } else {
        setState(() {
          duration--;
        });
      }
    });
  }

  void stopAudio() {
    _player.stop();
  }

  Future<void> playAudioSequentially(List<String> audioUrls) async {
    for (var url in audioUrls) {
      try {
        await _player.setSourceUrl(url);
        await _player.resume();
        await _player.onPlayerComplete.first;
      } catch (e) {
        print('Error playing $url: $e');
        stopAudio();
      }
    }

    if (widget.itemDuration) {
      setItemDuration();
    }
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int? selectedIndex = widget.attempts != null
        ? widget.answers.indexWhere((e) => e.content == widget.attempts?.answer)
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.number,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                Text('Durasi: ${widget.itemDuration ? duration : 0} detik')
              ],
            ),
            const SizedBox(height: 10),

            if (widget.attachments != null && widget.attachments!.isNotEmpty)
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.attachments!
                .where((attachment) =>
                  attachment.mime == 'image/jpeg' ||
                  attachment.mime == 'image/png' ||
                  attachment.mime == 'image/jpg')
                .map((attachment) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.network(
                    '${ApiService.mediaUrl}${attachment.path}',
                    fit: BoxFit.cover,
                    height: 150,
                    ),
                  ))
                .toList(),
              ),

            Html(data: widget.questionHtml),
            const SizedBox(height: 5),
            if (widget.subContent != null) Html(data: widget.subContent!),

            if (_audioFuture != null)
              FutureBuilder<void>(
                future: _audioFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),

            ...List.generate(widget.answers.length, (index) {
              return RadioListTile<int>(
                title: Text(widget.answers[index].content ?? ''),
                value: index,
                groupValue: selectedIndex,
                onChanged: widget.onChanged,
              );
            }),
          ],
        ),
      ),
    );
  }
}
