class ExportHistory {
  final int id;
  final int userId;
  final DateTime exportedAt;
  final String filePath;

  ExportHistory({
    required this.id,
    required this.userId,
    required this.exportedAt,
    required this.filePath,
  });

  factory ExportHistory.fromJson(Map<String, dynamic> json) {
    return ExportHistory(
      id: json['id'],
      userId: json['user_id'],
      exportedAt: DateTime.parse(json['exported_at']),
      filePath: json['file_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'exported_at': exportedAt.toIso8601String(),
      'file_path': filePath,
    };
  }
}
