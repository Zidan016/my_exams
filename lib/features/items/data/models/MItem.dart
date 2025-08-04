class ItemModel {
  final String id;
  final String? parentId;
  final String type;
  final String? code;
  final String content;
  final int answerOrderRandom;
  final int duration;
  final int itemCount;
  final int order;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ItemModel({
    required this.id,
    this.parentId,
    required this.type,
    this.code,
    required this.content,
    required this.answerOrderRandom,
    required this.duration,
    required this.itemCount,
    required this.order,
    this.createdAt,
    this.updatedAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      parentId: json['parent_id'],
      type: json['type'],
      code: json['code'],
      content: json['content'],
      answerOrderRandom: json['answer_order_random'],
      duration: json['duration'],
      itemCount: json['item_count'],
      order: json['order'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'type': type,
      'code': code,
      'content': content,
      'answer_order_random': answerOrderRandom,
      'duration': duration,
      'item_count': itemCount,
      'order': order,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ItemModel copyWith({
    String? id,
    String? parentId,
    String? type,
    String? code,
    String? content,
    int? answerOrderRandom,
    int? duration,
    int? itemCount,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ItemModel(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      type: type ?? this.type,
      code: code ?? this.code,
      content: content ?? this.content,
      answerOrderRandom: answerOrderRandom ?? this.answerOrderRandom,
      duration: duration ?? this.duration,
      itemCount: itemCount ?? this.itemCount,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}