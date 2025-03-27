class Document {
  final String id;
  final String? typeId;
  final String? typeName;
  final String? requisitionId;
  final String fileUrl;
  final String fileName;
  final int fileSize;
  final String fileType;
  final bool isVerified;
  final DateTime createdAt;

  Document({
    required this.id,
    this.typeId,
    this.typeName,
    this.requisitionId,
    required this.fileUrl,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
    required this.isVerified,
    required this.createdAt,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      typeId: json['type_id'] as String?,
      typeName: json['type'] != null ? (json['type'] as Map)['name'] as String? : null,
      requisitionId: json['requisition_id'] as String?,
      fileUrl: json['file_url'] as String,
      fileName: json['file_name'] as String,
      fileSize: json['file_size'] as int,
      fileType: json['file_type'] as String,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}