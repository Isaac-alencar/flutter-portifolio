import 'dart:io';
import "dart:convert";
import "dart:async";

import "package:path_provider/path_provider.dart";

class FileSystemManagement {
  Future<File> getFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future saveData(List<dynamic> list) async {
    String data = json.encode(list);
    final File file = await getFile();
    return file.writeAsString(data);
  }

  Future readData() async {
    try {
      final File file = await getFile();
      return file.readAsString();
    } catch (error) {
      print(error);
      return;
    }
  }
}
