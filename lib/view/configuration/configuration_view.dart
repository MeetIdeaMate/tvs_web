import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/models/get_model/get_configuration_list_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/configuration/configuration_dialog/configuration_dialog.dart';
import 'package:tlbilling/view/configuration/configuration_dialog/configuration_dialog_bloc.dart';
import 'package:tlbilling/view/configuration/configuration_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class ConfigurationView extends StatefulWidget {
  const ConfigurationView({super.key});

  @override
  State<ConfigurationView> createState() => _ConfigurationViewState();
}

class _ConfigurationViewState extends State<ConfigurationView> {
  final _appColors = AppColors();
  final _configurationViewBloc = ConfigurationBlocImpl();
  final _configurationDialogBloc = ConfigurationDialogBlocImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildConfigurationView(),
    );
  }

  Widget _buildConfigurationView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderOfTheScreen(),
          AppWidgetUtils.buildSizedBox(custHeight: 26),
          _buildSearchAndAddConfigButton(),
          AppWidgetUtils.buildSizedBox(custHeight: 28),
          _buildConfigDataTable(),
        ],
      ),
    );
  }

  Widget _buildHeaderOfTheScreen() {
    return _buildTextWidget('Config',
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: _appColors.primaryColor);
  }

  Widget _buildSearchAndAddConfigButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSearchBox(),
        //_buildAddConfigButton(),
      ],
    );
  }

  Widget _buildSearchBox() {
    return StreamBuilder(
      stream: _configurationViewBloc.searchConfigStream,
      builder: (context, snapshot) {
        final bool isTextEmpty =
            _configurationViewBloc.configSearchTextController.text.isEmpty;
        final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
        final Color iconColor =
            isTextEmpty ? _appColors.primaryColor : Colors.red;
        return TldsInputFormField(
          height: 40,
          width: 350,
          onSubmit: (searchValue) {
            _configurationViewBloc.getAllConfigList();
            _configurationViewBloc.searchConfigStreamController(true);
            _configurationViewBloc.reLoadStreamController(true);
          },
          controller: _configurationViewBloc.configSearchTextController,
          hintText: 'Search Config',
          isSearch: true,
          suffixIcon: IconButton(
            onPressed: () {
              isTextEmpty
                  ? null
                  : _configurationViewBloc.configSearchTextController.clear();
              _configurationViewBloc.getAllConfigList();
              _configurationViewBloc.searchConfigStreamController(true);
              _configurationViewBloc.reLoadStreamController(true);
            },
            icon: Icon(
              iconData,
              color: iconColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddConfigButton() {
    return CustomElevatedButton(
      text: 'Add Config',
      buttonBackgroundColor: _appColors.primaryColor,
      fontColor: _appColors.whiteColor,
      height: 50,
      fontSize: 12,
      suffixIcon: SvgPicture.asset(AppConstants.icAdd),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return const ConfigurationDialog();
          },
        ).then((value) {
          _configurationViewBloc.reLoadStreamController(true);
        });
      },
    );
  }

  Widget _buildConfigDataTable() {
    return StreamBuilder(
      stream: _configurationViewBloc.reLoadStream,
      builder: (context, snapshot) {
        return Expanded(
            child: FutureBuilder<List<GetAllConfigurationListModel>?>(
          future: _configurationViewBloc.getAllConfigList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: AppWidgetUtils.buildLoading(),
              );
            } else if (snapshot.hasData) {
              List<GetAllConfigurationListModel>? configListModel =
                  snapshot.data;
              if (configListModel != null && configListModel.isNotEmpty) {
                return Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: DataTable(
                            key: UniqueKey(),
                            dividerThickness: 0.1,
                            columns: [
                              _buildTableHeader('S.No', flex: 1),
                              _buildTableHeader('Config Id', flex: 2),
                              _buildTableHeader('Default Value', flex: 2),
                              _buildTableHeader('Configuration Values',
                                  flex: 2),
                              _buildTableHeader('Action', flex: 2),
                            ],
                            rows: _buildDataTableRow(configListModel) ?? [],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
                return Center(
                  child: SvgPicture.asset(AppConstants.imgNoData),
                );
              }
            }
            return Center(
              child: SvgPicture.asset(AppConstants.imgNoData),
            );
          },
        ));
      },
    );
  }

  List<DataRow>? _buildDataTableRow(
      List<GetAllConfigurationListModel>? configListModel) {
    return configListModel
        ?.asMap()
        .entries
        .map(
          (entry) => DataRow(
            color: MaterialStateColor.resolveWith((states) {
              if (entry.key % 2 == 0) {
                return Colors.white;
              } else {
                return _appColors.transparentBlueColor;
              }
            }),
            cells: [
              DataCell(Text('${entry.key + 1}')),
              DataCell(Text(entry.value.configId ?? '')),
              DataCell(Text(entry.value.defaultValue ?? '')),
              DataCell(Text(entry.value.configuration!.length > 2
                  ? '${entry.value.configuration?.getRange(0, 2).join(', ')}, ...'
                  : entry.value.configuration?.join(', ') ?? '')),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ConfigurationDialog(
                              configId: entry.value.configId ?? ''),
                        ).then((value) => _configurationViewBloc
                            .reLoadStreamController(true));
                      },
                      icon: SvgPicture.asset(AppConstants.icEdit),
                    ),
                    AppWidgetUtils.buildSizedBox(custWidth: 10),
                  ],
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  DataColumn _buildTableHeader(String headerValue, {int flex = 1}) =>
      DataColumn(
        label: Expanded(
          child: Text(
            headerValue,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );

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
}
