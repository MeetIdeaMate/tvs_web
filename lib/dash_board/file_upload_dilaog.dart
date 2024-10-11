import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/dash_board/file_upload_dialog_bloc.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';

class FileUploadDialog extends StatefulWidget {
  const FileUploadDialog({super.key});

  @override
  State<FileUploadDialog> createState() => _FileUploadDialogState();
}

class _FileUploadDialogState extends State<FileUploadDialog> {
  final _appColors = AppColors();
  final _fileUploadDialogBloc = FileUploadDialogBlocImpl();

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.bytes != null) {
      _fileUploadDialogBloc.fileName = result.files.single.name;
      _fileUploadDialogBloc.draggingStream(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _appColors.whiteColor,
      surfaceTintColor: _appColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(10),
      title: AppWidgetUtils.buildDialogFormTitle(
          context, AppConstants.uploadStatement),
      actions: [
        CustomActionButtons(
            onPressed: () {
              print(_fileUploadDialogBloc.fileName);
            },
            buttonText: AppConstants.confirm)
      ],
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.3,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 150,
                    child: DropzoneView(
                      onCreated: (controller) => _fileUploadDialogBloc
                          .dropzoneViewController = controller,
                      onDrop: (file) {
                        _fileUploadDialogBloc.draggingStream(true);
                      },
                      onHover: () {
                        _fileUploadDialogBloc.draggingStream(true);
                      },
                      onLeave: () {
                        _fileUploadDialogBloc.draggingStream(false);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickPdf,
                    child: StreamBuilder<bool?>(
                      stream: _fileUploadDialogBloc.isDraggingStream,
                      builder: (context, snapshot) {
                        final isDragging = snapshot.data ?? false;
                        return DottedBorder(
                          color: isDragging ? Colors.blue : Colors.grey,
                          strokeWidth: 2,
                          dashPattern: [8, 4],
                          child: Container(
                              width: double.infinity,
                              height: 150,
                              alignment: Alignment.center,
                              child: _fileUploadDialogBloc.fileName != null
                                  ? Text(_fileUploadDialogBloc.fileName ?? '',
                                      textAlign: TextAlign.center)
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.picture_as_pdf,
                                            size: 40, color: Colors.grey),
                                        const SizedBox(height: 10),
                                        const Text(AppConstants.dragAndDropHere,
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        const Text(AppConstants.or,
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        TextButton(
                                          onPressed: _pickPdf,
                                          child: const Text(
                                            AppConstants.chooseFile,
                                          ),
                                        ),
                                      ],
                                    )),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fileUploadDialogBloc.dispose();
    super.dispose();
  }
}
