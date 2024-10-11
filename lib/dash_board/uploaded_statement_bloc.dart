import 'package:flutter_dropzone/flutter_dropzone.dart';

abstract class UploadedStatementBloc {
  DropzoneViewController get dropzoneViewController;
}

class UploadedStatementBlocImpl extends UploadedStatementBloc {
  late DropzoneViewController _dropzoneViewController;

  @override
  DropzoneViewController get dropzoneViewController => _dropzoneViewController;
}
