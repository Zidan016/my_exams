class PackageModel {
  final String id;
  final String? parentId;
  final String title;
  final String? code;
  final String? config;
  final int depth;
  final String? description;
  final int? level;
  final int duration;
  final int maxScore;
  final int randomItem;
  final int itemDuration;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int isEncrypted;
  final String? distributionOptions;
  final int? isToefl;

  const PackageModel({
    required this.id,
    this.parentId,
    required this.title,
    this.code,
    this.config,
    required this.depth,
    this.description,
    required this.duration,
    required this.maxScore,
    required this.randomItem,
    required this.itemDuration,
    this.note,
    this.createdAt,
    this.updatedAt,
    required this.isEncrypted,
    this.level,
    this.distributionOptions,
    this.isToefl
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      parentId: json['parent_id'],
      title: json['title'],
      code: json['code'],
      config: json['config'],
      depth: json['depth'],
      description: json['description'],
      level: json['level'],
      duration: json['duration'],
      maxScore: json['max_score'],
      randomItem: json['random_item'],
      itemDuration: json['item_duration'],
      note: json['note'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      isEncrypted: json['is_encrypted'],
      distributionOptions: json['distribution_options'],
      isToefl: json['is_toefl']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'title': title,
      'code': code,
      'config': config,
      'depth': depth,
      'description': description,
      'level': level,
      'duration': duration,
      'max_score': maxScore,
      'random_item': randomItem,
      'item_duration': itemDuration,
      'note': note,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_encrypted': isEncrypted,
      'distribution_options': distributionOptions,
      'is_toefl': isToefl
    };
  }

  PackageModel copyWith({
    String? id,
    String? parentId,
    String? title,
    String? code,
    String? config,
    int? depth,
    String? description,
    int? level,
    int? duration,
    int? maxScore,
    int? randomItem,
    int? itemDuration,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isEncrypted,
    String? distributionOptions,
    int? isToefl,
  }) {
    return PackageModel(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      code: code ?? this.code,
      config: config ?? this.config,
      depth: depth ?? this.depth,
      description: description ?? this.description,
      level: level ?? this.level,
      duration: duration ?? this.duration,
      maxScore: maxScore ?? this.maxScore,
      randomItem: randomItem ?? this.randomItem,
      itemDuration: itemDuration ?? this.itemDuration,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      distributionOptions: distributionOptions ?? this.distributionOptions,
      isToefl: isToefl ?? this.isToefl,
    );
  }
}