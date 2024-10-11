import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_dropzone/flutter_dropzone.dart';

abstract class FileUploadDialogBloc {
  DropzoneViewController get dropzoneViewController;
  Stream<String?> get fileNameStream;
  Stream<bool?> get isDraggingStream;
  Stream<Uint8List?> get selectedPdfBytesStream;
  String? get fileName;
  void pickPdf(Uint8List? pdfBytes, String? pdfName);
  void draggingStream(bool isDragging);
  void dispose();
}

class FileUploadDialogBlocImpl extends FileUploadDialogBloc {
  late DropzoneViewController _dropzoneViewController;

  final _fileNameController = StreamController<String?>();
  final _isDraggingController = StreamController<bool?>();
  final _selectedPdfBytesController = StreamController<Uint8List?>();
  String? _fileName;

  @override
  DropzoneViewController get dropzoneViewController => _dropzoneViewController;

  @override
  Stream<String?> get fileNameStream => _fileNameController.stream;

  @override
  Stream<bool?> get isDraggingStream => _isDraggingController.stream;

  @override
  Stream<Uint8List?> get selectedPdfBytesStream =>
      _selectedPdfBytesController.stream;

  @override
  void pickPdf(Uint8List? pdfBytes, String? pdfName) {
    _selectedPdfBytesController.add(pdfBytes);
    _fileNameController.add(pdfName);
  }

  @override
  void draggingStream(bool isDragging) {
    _isDraggingController.add(isDragging);
  }

  set fileName(String? value) {
    _fileName = value;
  }

  set dropzoneViewController(DropzoneViewController controller) {
    _dropzoneViewController = controller;
  }

  @override
  void dispose() {
    _fileNameController.close();
    _isDraggingController.close();
    _selectedPdfBytesController.close();
  }

  @override
  String? get fileName => _fileName;
}
