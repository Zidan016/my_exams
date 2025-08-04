class Attachable {
  final String id;
  final String attachmentId;
  final String attachableType;
  final String? attachableUUID;
  final int? attachableId;
  final int order;

  Attachable({
    required this.id,
    required this.attachmentId,
    required this.attachableType,
    this.attachableUUID,
    this.attachableId,
    required this.order,
  });

  factory Attachable.fromJson(Map<String, dynamic> json) {
    return Attachable(
      id: json['id'] as String,
      attachmentId: json['attachment_id'] as String,
      attachableType: json['attachable_type'] as String,
      attachableUUID: json['attachable_uuid'] as String?,
      attachableId: json['attachable_id'] as int?,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attachment_id': attachmentId,
      'attachable_type': attachableType,
      'attachable_uuid': attachableUUID,
      'attachable_id': attachableId,
      'order': order,
    };
  }

  Attachable copyWith({
    String? id,
    String? attachmentId,
    String? attachableType,
    String? attachableUUID,
    int? attachableId,
    int? order,
  }) {
    return Attachable(
      id: id ?? this.id,
      attachmentId: attachmentId ?? this.attachmentId,
      attachableType: attachableType ?? this.attachableType,
      attachableUUID: attachableUUID ?? this.attachableUUID,
      attachableId: attachableId ?? this.attachableId,
      order: order ?? this.order,
    );
  }
}