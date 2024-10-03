import 'package:flutter/material.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/product/product_configuration_bloc.dart';
import 'package:tlbilling/view/product/product_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';
import 'package:toastification/toastification.dart';

class ProductConfigurationView extends StatefulWidget {
  final String? itemId;
  final Map<String, double>? addOns;
  final ProductViewBloc productViewBloc;
  const ProductConfigurationView(
    this.itemId, {
    super.key,
    this.addOns,
    required this.productViewBloc,
  });

  @override
  State<ProductConfigurationView> createState() =>
      _ProductConfigurationViewState();
}

class _ProductConfigurationViewState extends State<ProductConfigurationView> {
  final _appColors = AppColors();

  final _productConfigurationBloc = ProductConfigurationBlocImpl();

  @override
  void initState() {
    super.initState();
    if (widget.addOns != null) {
      _productConfigurationBloc.configNameAndAmount = widget.addOns ?? {};
      _productConfigurationBloc.selectedConfig.addAll(widget.addOns!.keys);
      _productConfigurationBloc.selectConfigStreamController(true);
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
          context,
          widget.addOns != null
              ? AppConstants.productConfigView
              : AppConstants.productConfig),
      actions: [
        _buildSaveButton(context),
      ],
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.35,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: _buildProductConfigForm(context),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _productConfigurationBloc.isButtonDisabled,
      builder: (context, value, child) {
        return CustomActionButtons(
            buttonText: value
                ? AppConstants.loading
                : widget.addOns != null
                    ? AppConstants.edit
                    : AppConstants.save,
            onPressed: value
                ? () {}
                : () async {
                    if (_productConfigurationBloc.configNameAndAmount.isEmpty) {
                      AppWidgetUtils.buildToast(
                          context,
                          ToastificationType.error,
                          AppConstants.productConfig,
                          Icon(
                            Icons.error_outline,
                            color: _appColors.successColor,
                          ),
                          AppConstants.configNameAndAmountRequired,
                          _appColors.errorLightColor);
                      return;
                    }
                    _productConfigurationBloc.isButtonDisabled.value = true;
                    bool success =
                        await _productConfigurationBloc.updateProductConfig(
                      _productConfigurationBloc.configNameAndAmount,
                      widget.itemId ?? '',
                    );
                    if (success) {
                      AppWidgetUtils.buildToast(
                          context,
                          ToastificationType.success,
                          AppConstants.productConfig,
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: _appColors.successColor,
                          ),
                          widget.addOns != null
                              ? AppConstants.productConfigUpdated
                              : AppConstants.productConfigCreated,
                          _appColors.successLightColor);
                      Navigator.pop(context);
                    } else {
                      _productConfigurationBloc.isButtonDisabled.value = false;
                    }
                  });
      },
    );
  }

  Widget _buildProductConfigForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        if (_productConfigurationBloc.configNameAndAmount.isEmpty)
          _buildProductConfigname(),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        _buildSelectedConfigName(context),
      ],
    );
  }

  FutureBuilder<List<String>> _buildProductConfigname() {
    return FutureBuilder(
      future: _productConfigurationBloc.getConfigById(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(AppConstants.loading);
        } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return const Text(AppConstants.noData);
        }

        final List<String> productConfig = snapshot.data as List<String>;

        return StreamBuilder(
            stream: _productConfigurationBloc.selectedConfigStream,
            builder: (context, snapshot) {
              return Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: productConfig
                    .where((config) => !_productConfigurationBloc.selectedConfig
                        .contains(config))
                    .map((config) {
                  return Container(
                    decoration: _boxdecoration(),
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(config),
                        AppWidgetUtils.buildSizedBox(custWidth: 10),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            _productConfigurationBloc.selectedConfig
                                .add(config);
                            _productConfigurationBloc
                                .selectConfigStreamController(true);
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            });
      },
    );
  }

  BoxDecoration _boxdecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    );
  }

  Widget _buildSelectedConfigName(BuildContext context) {
    return StreamBuilder(
      stream: _productConfigurationBloc.selectedConfigStream,
      builder: (context, snapshot) {
        final selectedConfigs = _productConfigurationBloc.selectedConfig;

        return Column(
          children: selectedConfigs.map((config) {
            return _buildConfigNameAndAmt(config, context);
          }).toList(),
        );
      },
    );
  }

  Widget _buildConfigNameAndAmt(String configName, BuildContext context) {
    TextEditingController amtTextController = TextEditingController(
      text: _productConfigurationBloc.configNameAndAmount[configName]
              ?.toString() ??
          '',
    );
    return Container(
      decoration: _boxdecoration(),
      padding: const EdgeInsets.only(right: 10, left: 10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(configName),
          Row(
            children: [
              TldsInputFormField(
                hintText: AppConstants.rupeeHint,
                inputFormatters: TldsInputFormatters.onlyAllowDecimalNumbers,
                width: MediaQuery.sizeOf(context).width * 0.06,
                height: 35,
                controller: amtTextController,
                onChanged: (value) {
                  double amount = double.tryParse(value) ?? 0.0;
                  _productConfigurationBloc.configNameAndAmount[configName] =
                      amount;
                },
              ),
              AppWidgetUtils.buildSizedBox(custWidth: 6),
              if (widget.addOns == null)
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    _productConfigurationBloc.selectedConfig.remove(configName);
                    _productConfigurationBloc.configNameAndAmount
                        .remove(configName);
                    _productConfigurationBloc
                        .selectConfigStreamController(true);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
