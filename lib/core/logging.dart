import 'dart:io';

class AppLogger {
  static File? _logFile;

  /// ระบุ path ใน project (แก้เป็น path ของคุณเอง)
  static Future<void> init() async {
    // สมมุติว่า project อยู่ที่ /Users/pluem/Desktop/Code/routin_flutter
    final logPath = "logging.log";

    _logFile = File(logPath);
    print("Log file: $logPath");
    if (!await _logFile!.exists()) {
      await _logFile!.create(recursive: true);
    }
  }

  static Future<void> log(String message) async {
    final timestamp = DateTime.now().toIso8601String();
    final line = '[$timestamp] $message\n';
    await _logFile?.writeAsString(line, mode: FileMode.append);
    // duplicate to console
    // ignore: avoid_print
    print(line);
  }
}
