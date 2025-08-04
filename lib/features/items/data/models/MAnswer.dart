class AnswerModel {
  final String id;
  final String itemId;
  final int order;
  final int corretAnswer;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AnswerModel({
    required this.id,
    required this.itemId,
    required this.order,
    required this.corretAnswer,
    this.content,
    this.createdAt,
    this.updatedAt
  });

  factory AnswerModel.fromJson(Map<String, dynamic>json){
    return AnswerModel(
      id: json['id'],
      itemId: json['item_id'],
      order: json['order'],
      corretAnswer: json['correct_answer'],
      content: json['content'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_id': itemId,
      'order': order,
      'correct_answer': corretAnswer,
      'content': content,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
  
  AnswerModel copyWith({
    String? id,
    String? itemId,
    int? order,
    int? corretAnswer,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AnswerModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      order: order ?? this.order,
      corretAnswer: corretAnswer ?? this.corretAnswer,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}