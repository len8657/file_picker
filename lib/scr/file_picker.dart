library file_picker;

import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'file_picker_stub.dart'
// ignore: uri_does_not_exist
    if (dart.library.html) 'file_picker_web.dart';
// //ignore: uri_does_not_exist
//     if (dart.library.io) 'file_picker_io.dart'

class FilePicker {

  factory FilePicker() => _getInstance();
  static FilePicker get instance => _getInstance();
  static FilePicker _instance;
  FilePicker._internal() {
    // 初始化
  }
  static FilePicker _getInstance() {
    if (_instance == null) {
      _instance = new FilePicker._internal();
    }
    return _instance;
  }

  void registerFileWith(var registrar) {
    return registerWith(registrar);
  }

  Future<dynamic> getImageFile({@required ImageType outputType}) async {
    return getImage(outputType: outputType);
  }

  Future<MediaInfo> get imageFileInfo async {
    // return getImageInfo;
    return getImageInfo;
  }

  Future<dynamic> getVideoFile({@required VideoType outputType}) async {
    return getVideo(outputType: outputType);
  }

  Future<MediaInfo> get getVideoFileInfo async {
    return getVideoInfo;
  }

  Future<dynamic> getExcelFile({@required ExcelType outputType}) async {
    return getExcel(outputType: outputType);
  }

  Future<MediaInfo> get getExcelFileInfo async {
    return getExcelInfo;
  }

  Future<bool> saveFile({@required var data, @required name}) async {
    return inputFile(data: data, name: name);
  }
}

/// Supported file types
enum FileTypeCross { image, video, audio, any, custom }

class MediaInfo {
  String fileName;
  String base64;
  String base64WithScheme;
  Uint8List data;
}

enum ImageType { file, bytes, widget }

enum VideoType { file, bytes }

enum ExcelType { file, bytes }
