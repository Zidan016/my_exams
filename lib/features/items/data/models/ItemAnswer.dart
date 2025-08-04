import 'package:my_exams/features/attachment/data/models/MAttachment.dart';
import 'package:my_exams/features/items/data/models/MAnswer.dart';
import 'package:my_exams/features/items/data/models/MItem.dart';

class ItemAnswer {
  final ItemModel itemModel;
  final List<AnswerModel> answers;
  final List<AttachmentModel>? attachments;

  const ItemAnswer({
    required this.itemModel,
    required this.answers,
    this.attachments,
  });

  factory ItemAnswer.fromJson(Map<String, dynamic> json) {
    return ItemAnswer(
      itemModel: ItemModel.fromJson(json['item_model']),
      answers: (json['answers'] as List<dynamic>)
          .map((e) => AnswerModel.fromJson(e))
          .toList(),
      attachments: (json['attachments'] as List<dynamic>?)
        ?.map((e) => AttachmentModel.fromJson(e))
        .toList() ?? [],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_model': itemModel.toJson(),
      'answers': answers.map((e) => e.toJson()).toList(),
    };
  }
}