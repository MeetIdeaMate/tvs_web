import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/models/get_model/get_all_access_controll_model.dart';
import 'package:tlbilling/models/post_model/user_access_model.dart';
import 'package:tlbilling/models/user_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/useraccess/access_control_view_bloc.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:toastification/toastification.dart';

class AccessControlViewScreen extends StatefulWidget {
  const AccessControlViewScreen({super.key});

  @override
  State<AccessControlViewScreen> createState() =>
      _AccessControlViewScreenState();
}

class _AccessControlViewScreenState extends State<AccessControlViewScreen>
    with SingleTickerProviderStateMixin {
  final _appColors = AppColors();
  final _accessViewControlBloc = AccessControlViewBlocImpl();
  String? _userId;
  String? _userName;
  bool? isUpdateAccess;
  String? accessId;
  bool _loading = false;
  final List<UIComponent> _uiComponents = [];
  final List<Menu> _selectedMenus = [];
  final Map<String, bool> _hideChecks = {};
  final Map<String, bool> _viewChecks = {};
  final Map<String, bool> _addChecks = {};
  final Map<String, bool> _pUpdateChecks = {};
  final Map<String, bool> _fUpdateChecks = {};
  final Map<String, bool> _deleteChecks = {};
  final Set<String> _changedCheckboxes = {};
  bool? isCheckBoxChanges;

  @override
  void dispose() {
    _accessViewControlBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserDetails().then((_) {
      _fetcthCheckboxValues();
      _fetchUiComponentsNamesConfig();
      _fetchMenuConfigs();
    });
    _initializeTabController();
  }

  Future<void> _fetcthCheckboxValues() async {
    final checkboxValue = await _accessViewControlBloc
        .getAllUserAccessControlData(userId: _userId);
    if (checkboxValue == null) {
      return;
    }
    isUpdateAccess = checkboxValue.isEmpty;

    _selectedMenus.clear();
    _hideChecks.clear();
    _viewChecks.clear();
    _addChecks.clear();
    _pUpdateChecks.clear();
    _fUpdateChecks.clear();
    _deleteChecks.clear();

    final addedComponentNames = <String>{};

    for (AccessControlList element in checkboxValue) {
      accessId = element.id;
      for (UiComponent components in element.uiComponents ?? []) {
        final accessLevelsMap = <String, bool>{
          'HIDE': false,
          'VIEW': false,
          'ADD': false,
          'P_UPDATE': false,
          'F_UPDATE': false,
          'DELETE': false,
        };

        for (var accessLevel in components.accessLevels ?? []) {
          if (accessLevelsMap.containsKey(accessLevel)) {
            accessLevelsMap[accessLevel] = true;
          }
        }

        _hideChecks[components.componentName ?? ''] =
            accessLevelsMap['HIDE'] ?? false;
        _viewChecks[components.componentName ?? ''] =
            accessLevelsMap['VIEW'] ?? false;
        _addChecks[components.componentName ?? ''] =
            accessLevelsMap['ADD'] ?? false;
        _pUpdateChecks[components.componentName ?? ''] =
            accessLevelsMap['P_UPDATE'] ?? false;
        _fUpdateChecks[components.componentName ?? ''] =
            accessLevelsMap['F_UPDATE'] ?? false;
        _deleteChecks[components.componentName ?? ''] =
            accessLevelsMap['DELETE'] ?? false;

        if (!addedComponentNames.contains(components.componentName)) {
          _uiComponents.add(UIComponent(
            accessLevels: components.accessLevels,
            componentName: components.componentName,
          ));
          addedComponentNames.add(components.componentName ?? '');
        }
      }
    }

    final addedMenuNames = <String>{};

    for (AccessControlList element in checkboxValue) {
      for (MenuList menu in element.menus ?? []) {
        accessId = element.id;
        final accessLevelsMap = <String, bool>{
          'HIDE': false,
          'VIEW': false,
          'ADD': false,
          'P_UPDATE': false,
          'F_UPDATE': false,
          'DELETE': false,
        };

        for (var accessLevel in menu.accessLevels ?? []) {
          if (accessLevelsMap.containsKey(accessLevel)) {
            accessLevelsMap[accessLevel] = true;
          }
        }

        _hideChecks[menu.menuName ?? ''] = accessLevelsMap['HIDE'] ?? false;
        _viewChecks[menu.menuName ?? ''] = accessLevelsMap['VIEW'] ?? false;
        _addChecks[menu.menuName ?? ''] = accessLevelsMap['ADD'] ?? false;
        _pUpdateChecks[menu.menuName ?? ''] =
            accessLevelsMap['P_UPDATE'] ?? false;
        _fUpdateChecks[menu.menuName ?? ''] =
            accessLevelsMap['F_UPDATE'] ?? false;
        _deleteChecks[menu.menuName ?? ''] = accessLevelsMap['DELETE'] ?? false;

        if (!addedMenuNames.contains(menu.menuName)) {
          _selectedMenus.add(Menu(
            accessLevels: menu.accessLevels,
            menuName: menu.menuName,
          ));
          addedMenuNames.add(menu.menuName ?? '');
        }
      }
    }
    _accessViewControlBloc.refreshTavViewStreamController(true);
  }

  void _initializeTabController() {
    _accessViewControlBloc.accessControlTabController =
        TabController(length: 2, vsync: this);
    _accessViewControlBloc.accessControlTabController.addListener(() {
      Future.microtask(() {
        if (_accessViewControlBloc.accessControlTabController.index == 0) {
          _fetchMenuConfigs();
        } else {
          _fetchUiComponentsNamesConfig();
        }
      });
    });
  }

  void _isLoadingState({required bool state}) {
    setState(() {
      _loading = state;
    });
  }

  Future<void> _fetchMenuConfigs() async {
    final menuConfig = await _accessViewControlBloc.getMenuNameConfigList();

    if (menuConfig?.configuration != null) {
      _accessViewControlBloc.updateScreenNames(menuConfig!.configuration!);
    }
  }

  Future<void> _fetchUiComponentsNamesConfig() async {
    final componentsConfig =
        await _accessViewControlBloc.getUiComponentsConfigList();
    if (componentsConfig?.configuration != null) {
      _accessViewControlBloc
          .updateUiComponentNameList(componentsConfig!.configuration!);
    }
  }

  Future<void> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _userId = prefs.getString('userId');
    _userName = prefs.getString('userName');
    _accessViewControlBloc.selectedUserName = _userName;
  }

  void _updateSelectedMenus() {
    final addedMenuNames = <String>{};
    _selectedMenus.clear();

    for (int i = 0; i < _accessViewControlBloc.screenNameList.length; i++) {
      List<String> accessLevels = [];
      final screenName = _accessViewControlBloc.screenNameList[i];
      if (_hideChecks[screenName] == true) {
        accessLevels.add('HIDE');
      }
      if (_viewChecks[screenName] == true) {
        accessLevels.add('VIEW');
      }
      if (_addChecks[screenName] == true) {
        accessLevels.add('ADD');
      }
      if (_pUpdateChecks[screenName] == true) {
        accessLevels.add('P_UPDATE');
      }
      if (_fUpdateChecks[screenName] == true) {
        accessLevels.add('F_UPDATE');
      }
      if (_deleteChecks[screenName] == true) {
        accessLevels.add('DELETE');
      }

      if (accessLevels.isNotEmpty && !addedMenuNames.contains(screenName)) {
        _selectedMenus.add(Menu(
          accessLevels: accessLevels,
          menuName: screenName,
        ));
        addedMenuNames.add(screenName);
      }
    }
  }

  void _updateSelectedUIComponents() {
    final addedComponentNames = <String>{};
    _uiComponents.clear();
    for (int i = 0; i < _accessViewControlBloc.uiComponentsList.length; i++) {
      List<String> accessLevels = [];
      final componentName = _accessViewControlBloc.uiComponentsList[i];
      if (_hideChecks[componentName] == true) {
        accessLevels.add('HIDE');
      }
      if (_viewChecks[componentName] == true) {
        accessLevels.add('VIEW');
      }
      if (_addChecks[componentName] == true) {
        accessLevels.add('ADD');
      }
      if (_pUpdateChecks[componentName] == true) {
        accessLevels.add('P_UPDATE');
      }
      if (_fUpdateChecks[componentName] == true) {
        accessLevels.add('F_UPDATE');
      }
      if (_deleteChecks[componentName] == true) {
        accessLevels.add('DELETE');
      }
      if (accessLevels.isNotEmpty &&
          !addedComponentNames.contains(componentName)) {
        _uiComponents.add(UIComponent(
          accessLevels: accessLevels,
          componentName: componentName,
        ));
        addedComponentNames.add(componentName);
      }
    }
  }

  void _updateCheckboxState(
      String screenName, String accessLevel, bool? value) async {
    final isChecked = value ?? false;
    final key = '$screenName-$accessLevel';
    _accessViewControlBloc.checkBoxStreamController(true);
    switch (accessLevel) {
      case 'HIDE':
        _hideChecks[screenName] = isChecked;
        if (isChecked) {
          // Disable all other checkboxes when "HIDE" is selected
          _viewChecks[screenName] = false;
          _addChecks[screenName] = false;
          _pUpdateChecks[screenName] = false;
          _fUpdateChecks[screenName] = false;
          _deleteChecks[screenName] = false;
        }
        _accessViewControlBloc.refreshTavViewStreamController(true);

        break;
      case 'VIEW':
        _viewChecks[screenName] = isChecked;

        break;
      case 'ADD':
        _addChecks[screenName] = isChecked;
        if (isChecked) {
          _viewChecks[screenName] = true;
        }
        _accessViewControlBloc.refreshTavViewStreamController(true);
        break;
      case 'P_UPDATE':
        _pUpdateChecks[screenName] = isChecked;
        if (isChecked) {
          _viewChecks[screenName] = true;
        }
        _accessViewControlBloc.refreshTavViewStreamController(true);
        break;
      case 'F_UPDATE':
        _fUpdateChecks[screenName] = isChecked;
        if (isChecked) {
          _viewChecks[screenName] = true;
        }
        _accessViewControlBloc.refreshTavViewStreamController(true);
        break;
      case 'DELETE':
        _deleteChecks[screenName] = isChecked;
        if (isChecked) {
          _hideChecks[screenName] = false;
          _viewChecks[screenName] = true;
          _addChecks[screenName] = true;
          _pUpdateChecks[screenName] = true;
          _fUpdateChecks[screenName] = true;
        }
        _accessViewControlBloc.refreshTavViewStreamController(true);
        break;
    }

    bool hasChanges = _changedCheckboxes.contains('$screenName-$accessLevel');

    if (!hasChanges) {
      _changedCheckboxes.add(key);
    } else {
      _changedCheckboxes.remove(key);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    isCheckBoxChanges = _changedCheckboxes.isNotEmpty;
    prefs.setBool('isAccessCheckBoxChanged', isCheckBoxChanges ?? false);
  }

  Widget _buildCheckboxCell(int index, String screenName, String accessLevel,
      Map<String, bool> checks,
      {bool isEnabled = true}) {
    bool enableCheckbox;
    if (accessLevel == 'HIDE') {
      enableCheckbox = true;
    } else if (accessLevel == 'DELETE') {
      enableCheckbox = !(_hideChecks[screenName] ?? false);
    } else {
      enableCheckbox = !(_hideChecks[screenName] ?? false);
    }
    return StreamBuilder<bool>(
        stream: _accessViewControlBloc.checkBoxStream,
        builder: (context, snapshot) {
          return Checkbox(
            value: checks[screenName] ?? false,
            onChanged: enableCheckbox
                ? (newValue) {
                    _updateCheckboxState(screenName, accessLevel, newValue);
                    _updateSelectedMenus();
                    if (_accessViewControlBloc
                            .accessControlTabController.index ==
                        1) {
                      _updateSelectedUIComponents();
                    }
                  }
                : null,
          );
        });
  }

  buttonOnPressed() async {
    _updateSelectedMenus();
    _updateSelectedUIComponents();
    if (_changedCheckboxes.isEmpty) {
      AppWidgetUtils.buildToast(
          context,
          ToastificationType.warning,
          'Warning',
          Icon(
            Icons.warning_rounded,
            color: _appColors.errorColor,
          ),
          isUpdateAccess ?? false
              ? 'No access control data selected.'
              : 'No access control data changed.',
          _appColors.errorLightColor);
    } else {
      final accessData = UserAccess(
          menus: _selectedMenus, uiComponents: _uiComponents, userId: _userId);
      _isLoadingState(state: true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (isUpdateAccess ?? false) {
        _accessViewControlBloc.accessControlPostData((statusCode) {
          _changedCheckboxes.clear();
          prefs.remove('isAccessCheckBoxChanged');

          if (statusCode == 200 || statusCode == 201) {
            _isLoadingState(state: false);
            AppWidgetUtils.buildToast(
                context,
                ToastificationType.success,
                AppConstants.userAccessCreated,
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: _appColors.successColor,
                ),
                AppConstants.userAccessCreatedDes,
                _appColors.successLightColor);
          } else {
            _isLoadingState(state: false);
            AppWidgetUtils.buildToast(
                context,
                ToastificationType.error,
                AppConstants.userAccessNotCreated,
                Icon(
                  Icons.error_outline_outlined,
                  color: _appColors.errorColor,
                ),
                AppConstants.userAccessNotCreatedDes,
                _appColors.errorLightColor);
          }
        }, accessData);
      } else {
        _accessViewControlBloc.accessControlUpdateData((statusCode) {
          if (statusCode == 200 || statusCode == 201) {
            _isLoadingState(state: false);
            prefs.remove('isAccessCheckBoxChanged');

            _changedCheckboxes.clear();
            AppWidgetUtils.buildToast(
                context,
                ToastificationType.success,
                AppConstants.userAccessUpdated,
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: _appColors.successColor,
                ),
                AppConstants.userAccessUpdatedDes,
                _appColors.successLightColor);
          } else {
            _isLoadingState(state: false);
            AppWidgetUtils.buildToast(
                context,
                ToastificationType.error,
                AppConstants.userAccessNotUpdated,
                Icon(
                  Icons.error_outline_outlined,
                  color: _appColors.errorColor,
                ),
                AppConstants.userAccessNotUpdatedDes,
                _appColors.errorLightColor);
          }
        }, accessData, accessId ?? '');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var tooltip = Tooltip(
      message: 'update access data',
      child: FloatingActionButton(
          backgroundColor: _appColors.primaryColor,
          shape: const CircleBorder(),
          onPressed: buttonOnPressed,
          child: Icon(
            Icons.cloud_upload,
            color: _appColors.whiteColor,
          )),
    );
    return BlurryModalProgressHUD(
      inAsyncCall: _loading,
      progressIndicator: AppWidgetUtils.buildLoading(),
      color: _appColors.whiteColor,
      child: Scaffold(
        floatingActionButton: tooltip,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppWidgetUtils.buildHeaderText(AppConstants.accessControl),
              AppWidgetUtils.buildSizedBox(custHeight: 10),
              Row(
                children: [
                  _buildRoleDropdown(),
                  AppWidgetUtils.buildSizedBox(custWidth: 10),
                  _buildDesignationDropdown(),
                  AppWidgetUtils.buildSizedBox(custWidth: 10),
                  _buildUserNameList()
                ],
              ),
              AppWidgetUtils.buildSizedBox(custHeight: 10),
              _buildTabBar(),
              AppWidgetUtils.buildSizedBox(custHeight: 26),
              _buildTabBarView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      width: 400,
      child: TabBar(
        controller: _accessViewControlBloc.accessControlTabController,
        tabs: const [
          Tab(text: AppConstants.menus),
          Tab(text: AppConstants.uiComponents),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return StreamBuilder(
        stream: _accessViewControlBloc.refreshTabViewStream,
        builder: (context, snapshot) {
          return Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _accessViewControlBloc.accessControlTabController,
              children: [_buildMenuListTabView(), _buildUiComponentsTabView()],
            ),
          );
        });
  }

  Widget _buildMenuListTabView() {
    return StreamBuilder<List<String>>(
      stream: _accessViewControlBloc.screenNamesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: AppWidgetUtils.buildLoading(),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text('NO DATA'),
          );
        } else {
          final screenNameList = snapshot.data ?? [];
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  dividerThickness: 0,
                  headingRowHeight: 30,
                  horizontalMargin: 20,
                  columns: [
                    _buildDataColumn('Screen name'),
                    _buildDataColumn('Hide'),
                    _buildDataColumn('View'),
                    _buildDataColumn('Add'),
                    _buildDataColumn('PUpdate'),
                    _buildDataColumn('FUpdate'),
                    _buildDataColumn('Delete'),
                  ],
                  rows: List.generate(screenNameList.length, (index) {
                    final screenName = screenNameList[index];
                    final hideChecked = _hideChecks[screenName] ?? false;

                    final deleteChecked = _deleteChecks[screenName] ?? false;
                    return DataRow(cells: [
                      DataCell(Text(screenName)),
                      DataCell(_buildCheckboxCell(
                          index, screenName, 'HIDE', _hideChecks)),
                      DataCell(_buildCheckboxCell(
                          index, screenName, 'VIEW', _viewChecks,
                          isEnabled: !hideChecked)),
                      DataCell(_buildCheckboxCell(
                          index, screenName, 'ADD', _addChecks,
                          isEnabled: !hideChecked)),
                      DataCell(_buildCheckboxCell(
                          index, screenName, 'P_UPDATE', _pUpdateChecks,
                          isEnabled: !hideChecked)),
                      DataCell(_buildCheckboxCell(
                          index, screenName, 'F_UPDATE', _fUpdateChecks,
                          isEnabled: !hideChecked)),
                      DataCell(_buildCheckboxCell(
                          index, screenName, 'DELETE', _deleteChecks)),
                    ]);
                  }),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildUiComponentsTabView() {
    return StreamBuilder<List<String>>(
      stream: _accessViewControlBloc.uiComponentsNameStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: AppWidgetUtils.buildLoading(),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text('NO DATA'),
          );
        } else {
          final uiComponentNameList = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  dividerThickness: 0,
                  headingRowHeight: 30,
                  horizontalMargin: 20,
                  columns: [
                    _buildDataColumn('UI component name'),
                    _buildDataColumn('Hide'),
                    _buildDataColumn('View'),
                    _buildDataColumn('Add'),
                    _buildDataColumn('PUpdate'),
                    _buildDataColumn('FUpdate'),
                    _buildDataColumn('Delete'),
                  ],
                  rows: List.generate(uiComponentNameList.length, (index) {
                    final uiComponentName = uiComponentNameList[index];
                    final hideChecked = _hideChecks[uiComponentName] ?? false;
                    final deleteChecked =
                        _deleteChecks[uiComponentName] ?? false;
                    return DataRow(cells: [
                      DataCell(Text(uiComponentName)),
                      DataCell(_buildCheckboxCell(
                          index, uiComponentName, 'HIDE', _hideChecks)),
                      DataCell(_buildCheckboxCell(
                          index, uiComponentName, 'VIEW', _viewChecks,
                          isEnabled: !hideChecked)),
                      DataCell(_buildCheckboxCell(
                          index, uiComponentName, 'ADD', _addChecks,
                          isEnabled: !hideChecked)),
                      DataCell(_buildCheckboxCell(
                          index, uiComponentName, 'P_UPDATE', _pUpdateChecks,
                          isEnabled: !hideChecked)),
                      DataCell(_buildCheckboxCell(
                          index, uiComponentName, 'F_UPDATE', _fUpdateChecks,
                          isEnabled: !hideChecked)),
                      DataCell(_buildCheckboxCell(
                          index, uiComponentName, 'DELETE', _deleteChecks)),
                    ]);
                  }),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  DataColumn _buildDataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return FutureBuilder(
      future: _accessViewControlBloc.getRoleConfigList(),
      builder: (context, snapshot) {
        List<String> roleList = [AppConstants.all];
        if (snapshot.hasData) {
          roleList.addAll(snapshot.data?.configuration ?? []);
        }
        if (_accessViewControlBloc.selectedRole?.isEmpty ?? false) {
          _accessViewControlBloc.selectedRole = AppConstants.all;
        }
        return TldsDropDownButtonFormField(
          height: 40,
          width: 203,
          hintText: AppConstants.payments,
          dropDownItems: roleList,
          dropDownValue: _accessViewControlBloc.selectedRole,
          onChange: (String? newValue) {
            _accessViewControlBloc.selectedRole = newValue ?? '';
          },
        );
      },
    );
  }

  Widget _buildDesignationDropdown() {
    return FutureBuilder(
      future: _accessViewControlBloc.getDesignationConfigList(),
      builder: (context, snapshot) {
        List<String> designationList = [AppConstants.all];
        if (snapshot.hasData) {
          designationList.addAll(snapshot.data?.configuration ?? []);
        }
        if (_accessViewControlBloc.selectedDesignation?.isEmpty ?? false) {
          _accessViewControlBloc.selectedDesignation = AppConstants.all;
        }
        return TldsDropDownButtonFormField(
          height: 40,
          width: 203,
          hintText: AppConstants.designation,
          dropDownItems: designationList,
          dropDownValue: _accessViewControlBloc.selectedDesignation,
          onChange: (String? newValue) {
            _accessViewControlBloc.selectedDesignation = newValue ?? '';
          },
        );
      },
    );
  }

  Widget _buildUserNameList() {
    return FutureBuilder(
      future: _accessViewControlBloc.getAllUserNameList(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text(AppConstants.loading),
          );
        } else if (futureSnapshot.hasData) {
          List<UserDetailsList> users = futureSnapshot.data ?? [];
          List<String> userNameList =
              users.map((e) => e.userName ?? '').toList();

          return TldsDropDownButtonFormField(
            height: 40,
            width: 300,
            hintText: AppConstants.userName,
            dropDownItems: userNameList,
            dropDownValue: _accessViewControlBloc.selectedUserName,
            onChange: (String? newValue) {
              _accessViewControlBloc.selectedUserName = newValue ?? '';

              _userId = users.firstWhere((e) => e.userName == newValue).userId;

              _changedCheckboxes.clear();

              //    prefs.remove('isAccessCheckBoxChanged');

              _fetcthCheckboxValues();
              _accessViewControlBloc.refreshTavViewStreamController(true);
            },
          );
        } else {
          return const Text('No Data');
        }
      },
    );
  }
}
