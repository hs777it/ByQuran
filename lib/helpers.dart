import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Helper {

  static Future getStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted)
          return true;
        else
          return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<String> getFilePath(fileName) async {
    String path = '';
    Directory dir = (await getApplicationDocumentsDirectory());
    path = '${dir.path}/$fileName';
    return path;
  }

   static String stripHtml(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }
  
}
