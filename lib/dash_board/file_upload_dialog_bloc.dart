import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';

abstract class FileUploadDialogBloc {
  DropzoneViewController get dropzoneViewController;
  Stream<bool?> get isDraggingStream;
  Stream<bool> get isLoadingStream;
  String? get fileName;
  Uint8List? get pdfBytes;
  Future<String> statementUpload();
  void dispose();
}

class FileUploadDialogBlocImpl extends FileUploadDialogBloc {
  final _apiService = AppServiceUtilImpl();
  late DropzoneViewController _dropzoneViewController;

  final _fileNameController = StreamController<String?>();
  final _isDraggingController = StreamController<bool?>();
  final _selectedPdfBytesController = StreamController<Uint8List?>();
  final _isLoadingController = StreamController<bool>();
  String? _fileName;
  Uint8List? _selectedPdfBytes;

  @override
  DropzoneViewController get dropzoneViewController => _dropzoneViewController;

  @override
  Stream<bool?> get isDraggingStream => _isDraggingController.stream;

  draggingStream(bool isDragging) {
    _isDraggingController.add(isDragging);
  }

  set fileName(String? value) {
    _fileName = value;
  }

  set dropzoneViewController(DropzoneViewController controller) {
    _dropzoneViewController = controller;
  }

  @override
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  isLoadingStreamUpdate(bool isLoading) {
    _isLoadingController.add(isLoading);
  }

  set pdfBytes(Uint8List? pdfBytes) {
    _selectedPdfBytes = pdfBytes;
  }

  @override
  void dispose() {
    _fileNameController.close();
    _isDraggingController.close();
    _selectedPdfBytesController.close();
  }

  @override
  String? get fileName => _fileName;

  @override
  Uint8List? get pdfBytes => _selectedPdfBytes;

  @override
  Future<String> statementUpload() {
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(pdfBytes!, filename: fileName),
    });
    return _apiService.statementUpload(formData);
  }
}
