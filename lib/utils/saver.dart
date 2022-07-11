// ignore_for_file: avoid_print

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Saver {
  final Dio dio = Dio();
  late Directory directory;

  Future<String> getDirectory() async {
    if (Platform.isAndroid) {
      if (await requestPermission(Permission.storage)) {
        directory = (await getExternalStorageDirectory())!;
        String newPath = "";
        List<String> folders = directory.path.split("/");
        for (int x = 1; x < folders.length; x++) {
          String folder = folders[x];
          if (folder != 'Android') {
            newPath += '/$folder';
          } else {
            break;
          }
        }
        newPath = "$newPath/Wox";
        return newPath;
      } else {
        return "false";
      }
    } else {
      if (await requestPermission(Permission.photos)) {
        directory = await getTemporaryDirectory();
      } else {
        return "false";
      }
    }
    return "false";
  }

  Future<String> saveFile(String url, String id) async {
    try {
      String dirPath = await getDirectory();
      // ignore: unrelated_type_equality_checks
      if (dirPath != "false") {
        directory = Directory(dirPath);
      } else {
        return "false";
      }

      // Checking if directory present otherwise create it
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Saving file
      if (await directory.exists()) {
        String filename = '$id.jpg';
        File saveFile = File("${directory.path}/$filename");
        if (await saveFile.exists()) {
          return "false";
        }
        await dio.download(url, saveFile.path,
            onReceiveProgress: (downloaded, totalSize) {});

        return "${directory.path}/$filename";
      }
    } catch (e) {
      print(e);
    }
    return "false";
  }

  // Checking Permissions
  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}
