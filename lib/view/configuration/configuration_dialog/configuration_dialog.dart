import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/configuration/configuration_dialog/configuration_dialog_bloc.dart';
import 'package:tlbilling/view/configuration/configuration_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:toastification/toastification.dart';

class ConfigurationDialog extends StatefulWidget {
  final String? configId;

  const ConfigurationDialog({super.key, this.configId});

  @override
  State<ConfigurationDialog> createState() => _ConfigurationDialogState();
}

class _ConfigurationDialogState extends State<ConfigurationDialog> {
  final _appColors = AppColors();
  final _configurationDialogBloc = ConfigurationDialogBlocImpl();
  final _configurationViewBloc = ConfigurationBlocImpl();

  @override
  void initState() {
    super.initState();
    _configurationDialogBloc.getConfigById(widget.configId ?? '').then((value) {
      var configData = value;
      _configurationDialogBloc.defaultValueTextController.text =
          configData?.defaultValue ?? '';
      _configurationDialogBloc.configValues = configData?.configuration ?? [];
      _configurationDialogBloc.configIdTextController.text =
          configData?.configId ?? '';
      _configurationDialogBloc.addChipStreamController(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
        inAsyncCall: _configurationDialogBloc.isAsyncCall,
        progressIndicator: AppWidgetUtils.buildLoading(),
        child: AlertDialog(
            surfaceTintColor: _appColors.whiteColor,
            content: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.3,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                _buildHeaderOfTheDialogAndClose(),
                const Divider(),
                AppWidgetUtils.buildSizedBox(custHeight: 8),
                _buildConfigIdAndAddConfigFields(),
                AppWidgetUtils.buildSizedBox(custHeight: 8),
                _buildConfigValesField(),
                AppWidgetUtils.buildSizedBox(custHeight: 8),
                _buildDefaultValueField(),
                AppWidgetUtils.buildSizedBox(custHeight: 16),
                _buildActionButtons(),
              ]),
            )));
  }

  Widget _buildHeaderOfTheDialogAndClose() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTextWidget('Create Config',
            color: _appColors.primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold),
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close))
      ],
    );
  }

  Widget _buildConfigIdAndAddConfigFields() {
    return Row(
      children: [
        _buildConfigIdField(),
        AppWidgetUtils.buildSizedBox(custWidth: 32),
        _buildAddConfigField(),
      ],
    );
  }

  Widget _buildConfigIdField() {
    return Expanded(
      child: TldsInputFormField(
        enabled: false,
        height: 40,
        controller: _configurationDialogBloc.configIdTextController,
        hintText: 'Config Id',
        requiredLabelText: _buildTextWidget('Config Id'),
      ),
    );
  }

  Widget _buildAddConfigField() {
    return Expanded(
      child: TldsInputFormField(
        height: 40,
        controller: _configurationDialogBloc.addConfigTextController,
        requiredLabelText: _buildTextWidget('Add Config'),
        hintText: 'Add Config',
        onSubmit: (String configValue) {
          if (_configurationDialogBloc.configValues.contains(configValue)) {
          } else {
            _configurationDialogBloc.configValues.add(configValue);
            _configurationDialogBloc.addConfigTextController.clear();
            _configurationDialogBloc.addChipStreamController(true);
          }
        },
      ),
    );
  }

  _buildConfigValesField() {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 120,
      width: MediaQuery.sizeOf(context).width * 0.3,
      decoration: BoxDecoration(
          border: Border.all(color: _appColors.borderColor),
          borderRadius: BorderRadius.circular(5)),
      child: StreamBuilder(
        stream: _configurationDialogBloc.addChipStream,
        builder: (context, snapshot) => _buildConfigValuesData(),
      ),
    );
  }

  Widget _buildConfigValuesData() {
    return SingleChildScrollView(
        child: Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(
        _configurationDialogBloc.configValues.length,
        (index) {
          final List<String> config = _configurationDialogBloc.configValues;
          return Chip(
            side: BorderSide.none,
            /*deleteIcon:
                Icon(Icons.close, color: _appColors.whiteColor, size: 16),
            deleteIconColor: _appColors.whiteColor,
            onDeleted: () {
              _configurationDialogBloc.configValues.removeAt(index);
              _configurationDialogBloc.addChipStreamController(true);
            },*/
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            backgroundColor: _appColors.primaryColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            label: Text(config.elementAt(index),
                style: GoogleFonts.nunitoSans(color: _appColors.whiteColor)),
          );
        },
      ),
    ));
  }

  Widget _buildDefaultValueField() {
    return Row(
      children: [
        Expanded(
          child: TldsInputFormField(
            height: 40,
            controller: _configurationDialogBloc.defaultValueTextController,
            hintText: 'Default Value',
            requiredLabelText: _buildTextWidget('Default Value'),
          ),
        )
      ],
    );
  }

  Widget _buildActionButtons() {
    return CustomActionButtons(
        onPressed: () {
          if (widget.configId != null) {
            _isLoadingState(true);
            _configurationDialogBloc.updateConfigValues(
              (statusCode) {
                if (statusCode == 200 || statusCode == 201) {
                  Navigator.pop(context);
                  AppWidgetUtils.buildToast(
                      context,
                      ToastificationType.success,
                      'Configuration Update',
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: _appColors.successColor,
                      ),
                      'Configuration Updated Successfully',
                      _appColors.successLightColor);
                }
              },
            );
          } else {
            _configurationDialogBloc.createConfig(
              (statusCode) {
                _isLoadingState(true);
                if (statusCode == 200 || statusCode == 201) {
                  Navigator.pop(context);
                  AppWidgetUtils.buildToast(
                      context,
                      ToastificationType.success,
                      'Configuration Created',
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: _appColors.successColor,
                      ),
                      'Configuration Created Successfully',
                      _appColors.successLightColor);
                } else {
                  AppWidgetUtils.buildToast(
                      context,
                      ToastificationType.error,
                      'Configuration Create Error',
                      Icon(
                        Icons.error_outline,
                        color: _appColors.errorColor,
                      ),
                      'Configuration Not Created Successfully',
                      _appColors.errorLightColor);
                }
              },
            );
          }
        },
        buttonText: 'save');
  }

  ///for loading the whole screen
  /*Future<void> _buildLoader() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            color: _appColors.primaryColor,
          ),
        );
      },
    );
    await Future.delayed(const Duration(seconds: 3));
    print('**************after 3 seconds******');
    Navigator.pop(context);
  }*/

  Widget _buildTextWidget(String text,
      {Color? color, double? fontSize, FontWeight? fontWeight}) {
    return Text(
      text,
      style: GoogleFonts.nunitoSans(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  _isLoadingState(bool state) {
    setState(() {
      _configurationDialogBloc.isAsyncCall = state;
    });
  }
}
