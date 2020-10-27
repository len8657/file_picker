

import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'web_picker.dart';
import 'file_picker.dart';


void registerWith(Registrar registrar) {
  final channel = MethodChannel(
      'file_picker', const StandardMethodCodec(), registrar.messenger);
  final instance = WebPicker();
  channel.setMethodCallHandler((call) async {
    switch (call.method) {
      case 'pickImage':
        return await instance.pickImage();
      case 'pickVideo':
        return await instance.pickVideo();
      case 'pickExcel':
        return await instance.pickExcel();
      default:
        throw MissingPluginException();
    }
  });
}

const MethodChannel _methodChannel = const MethodChannel('file_picker');

Future<html.File> _pickFile(String type) async {
  final html.FileUploadInputElement input = html.FileUploadInputElement();
  input..accept = '$type/*';
  input.click();
  await input.onChange.first;
  if (input.files.isEmpty) return null;
  return input.files[0];
}

Future<dynamic> getImage({@required ImageType outputType}) async {
  if (!(outputType is ImageType)) {
    throw ArgumentError(
        'outputType has to be from Type: ImageType if you call getImage()');
  }
  switch (outputType) {
    case ImageType.file:
      return await _pickFile('image');
      break;
    case ImageType.bytes:
      final data =
          await _methodChannel.invokeMapMethod<String, dynamic>('pickImage');
      final imageData = base64.decode(data['data']);
      return imageData;
      break;
    case ImageType.widget:
      final data =
          await _methodChannel.invokeMapMethod<String, dynamic>('pickImage');
      final imageName = data['name'];
      final imageData = base64.decode(data['data']);
      return Image.memory(imageData, semanticLabel: imageName);
      break;
    default:
      return null;
      break;
  }
}

Future<MediaInfo> get getImageInfo async {
  final data =
      await _methodChannel.invokeMapMethod<String, dynamic>('pickImage');
  MediaInfo _webImageInfo = MediaInfo();
  _webImageInfo.fileName = data['name'];
  _webImageInfo.base64 = data['data'];
  _webImageInfo.base64WithScheme = data['data_scheme'];
  _webImageInfo.data = base64.decode(data['data']);
  return _webImageInfo;
}

Future<dynamic> getVideo({@required VideoType outputType}) async {
  if (!(outputType is VideoType)) {
    throw ArgumentError(
        'outputType has to be from Type: VideoType if you call getVideo()');
  }
  switch (outputType) {
    case VideoType.file:
      return await _pickFile('video');
      break;
    case VideoType.bytes:
      final data =
          await _methodChannel.invokeMapMethod<String, dynamic>('pickVideo');
      final imageData = base64.decode(data['data']);
      return imageData;
      break;
    default:
      return null;
      break;
  }
}

Future<MediaInfo> get getVideoInfo async {
  final data =
      await _methodChannel.invokeMapMethod<String, dynamic>('pickVideo');
  MediaInfo _webVideoInfo = MediaInfo();
  _webVideoInfo.fileName = data['name'];
  _webVideoInfo.base64 = data['data'];
  _webVideoInfo.base64WithScheme = data['data_scheme'];
  _webVideoInfo.data = base64.decode(data['data']);
  return _webVideoInfo;
}

Future<dynamic> getExcel({@required ExcelType outputType}) async {
  if (!(outputType is ExcelType)) {
    throw ArgumentError(
        'outputType has to be from Type: ExcelType if you call getExcel()');
  }
  switch (outputType) {
    case ExcelType.file:
      return await _pickFile('.xlsx,.xls');
      break;
    case ExcelType.bytes:
      // final data =
          // await _methodChannel.invokeMapMethod<String, dynamic>('pickExcel');
        final data = await WebPicker().pickExcel();
        final excelData = base64.decode(data['data']);
        return excelData;
      break;
    default:
      return null;
      break;
  }
}

Future<bool> inputFile({@required var data, @required name}) async {
  try {
    final blob = html.Blob([data]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = name;
    html.document.body.children.add(anchor);
    anchor.click();
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
    return true;
  } catch (error) {
    return false;
  }
}

Future<MediaInfo> get getExcelInfo async {
  final data =
      await _methodChannel.invokeMapMethod<String, dynamic>('pickExcel');
  MediaInfo _webImageInfo = MediaInfo();
  _webImageInfo.fileName = data['name'];
  _webImageInfo.base64 = data['data'];
  _webImageInfo.base64WithScheme = data['data_scheme'];
  _webImageInfo.data = base64.decode(data['data']);
  return _webImageInfo;
}
// }
