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
  String? _branchId;
  String? _userName;
  final List<UIComponent> _uiComponents = [];
  final List<Menu> _selectedMenus = [];
  final Map<String, bool> _hideChecks = {};
  final Map<String, bool> _viewChecks = {};
  final Map<String, bool> _addChecks = {};
  final Map<String, bool> _pUpdateChecks = {};
  final Map<String, bool> _fUpdateChecks = {};
  final Map<String, bool> _deleteChecks = {};

  @override
  void dispose() {
    _accessViewControlBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeTabController();
    _fetchMenuConfigs();
    getUserDetails();
    _fetchMenuCheckboxValues();
  }

  void _initializeTabController() {
    _accessViewControlBloc.accessControlTabController =
        TabController(length: 2, vsync: this);
    _accessViewControlBloc.accessControlTabController.addListener(() {
      if (_accessViewControlBloc.accessControlTabController.indexIsChanging) {
        Future.microtask(() {
          if (_accessViewControlBloc.accessControlTabController.index == 0) {
            _fetchMenuConfigs();
          } else {
            _fetchUiComponentsNamesConfig();
          }
        });
      }
    });
  }

  Future<void> _fetchMenuCheckboxValues() async {
    final checkboxValue =
        await _accessViewControlBloc.getAllUserAccessControlData();
    for (AccessControlList element in checkboxValue ?? []) {
      for (MenuList menu in element.menus ?? []) {
        for (var accessLevels in menu.accessLevels ?? []) {
          _accessViewControlBloc.screenNameList.add(accessLevels);
        }
        final addedMenuNames = <String>{};
        _selectedMenus.clear();

        for (int i = 0; i < _accessViewControlBloc.screenNameList.length; i++) {
          List<String> accessLevels = [];
          final screenName = _accessViewControlBloc.screenNameList[i];
          if (_accessViewControlBloc.screenNameList.contains('HIDE')) {}
          if (_accessViewControlBloc.screenNameList.contains('VIEW')) {}
          if (_accessViewControlBloc.screenNameList.contains('ADD')) {}
          if (_accessViewControlBloc.screenNameList.contains('P_UPDATE')) {}
          if (_accessViewControlBloc.screenNameList.contains('F_UPDATE')) {}
          if (_accessViewControlBloc.screenNameList.contains('DELETE')) {}
          if (accessLevels.isNotEmpty && !addedMenuNames.contains(screenName)) {
            _selectedMenus.add(Menu(
              accessLevels: accessLevels,
              menuName: screenName,
            ));
            addedMenuNames.add(screenName);
          }
        }
      }
    }
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
    setState(() {
      _userId = prefs.getString('userId');
      _branchId = prefs.getString('branchId');
      _userName = prefs.getString('userName');
      _accessViewControlBloc.selectedUserName = _userName;
    });
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
      String screenName, String accessLevel, bool? value) {
    final isChecked = value ?? false;
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
        break;
      case 'P_UPDATE':
        _pUpdateChecks[screenName] = isChecked;
        break;
      case 'F_UPDATE':
        _fUpdateChecks[screenName] = isChecked;
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
  }

  Widget _buildCheckboxCell(int index, String screenName, String accessLevel,
      Map<String, bool> checks,
      {bool isEnabled = true}) {
    bool enableCheckbox;
    if (accessLevel == 'HIDE') {
      // HIDE checkbox should always be enabled
      enableCheckbox = true;
    } else if (accessLevel == 'DELETE') {
      // DELETE checkbox should always be enabled
      enableCheckbox = !(_hideChecks[screenName] ?? false);
    } else {
      // Enable other checkboxes only if HIDE is not checked
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Tooltip(
        message: 'Update access data',
        child: FloatingActionButton(
          backgroundColor: _appColors.primaryColor,
          shape: const CircleBorder(),
          child: Icon(
            Icons.cloud_upload,
            color: _appColors.whiteColor,
          ),
          onPressed: () {
            _updateSelectedMenus();
            _updateSelectedUIComponents();
            final accessData = UserAccess(
                menus: _selectedMenus,
                uiComponents: _uiComponents,
                userId: _userId);
            print('*&********${accessData.toJson()}');
            _accessViewControlBloc.accessControlPostData((statusCode) {
              if (statusCode == 200 || statusCode == 201) {
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
          },
        ),
      ),
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
    return FutureBuilder(
      future:
          _accessViewControlBloc.getAllUserAccessControlData(userId: _userId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: AppWidgetUtils.buildLoading(),
          );
        } else if (snapshot.hasData) {
          return Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _accessViewControlBloc.accessControlTabController,
              children: [_buildMenuListTabView(), _buildUiComponentsTabView()],
            ),
          );
        } else {
          return const Center(
            child: Text('NO DATA'),
          );
        }
      },
    );
  }

  Widget _buildMenuListTabView() {
    return StreamBuilder<List<String>>(
      stream: _accessViewControlBloc.screenNamesStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text('NO DATA'),
          );
        }
        final screenNameList = snapshot.data!;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: StreamBuilder<bool>(
                  stream: _accessViewControlBloc.refreshTabViewStream,
                  builder: (context, snapshot) {
                    return DataTable(
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
                        final deleteChecked =
                            _deleteChecks[screenName] ?? false;
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
                    );
                  }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUiComponentsTabView() {
    return StreamBuilder<List<String>>(
      stream: _accessViewControlBloc.uiComponentsNameStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text('NO DATA'),
          );
        }
        final uiComponentNameList = snapshot.data!;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: StreamBuilder<bool>(
                  stream: _accessViewControlBloc.refreshTabViewStream,
                  builder: (context, snapshot) {
                    return DataTable(
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
                        final hideChecked =
                            _hideChecks[uiComponentName] ?? false;
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
                          DataCell(_buildCheckboxCell(index, uiComponentName,
                              'P_UPDATE', _pUpdateChecks,
                              isEnabled: !hideChecked)),
                          DataCell(_buildCheckboxCell(index, uiComponentName,
                              'F_UPDATE', _fUpdateChecks,
                              isEnabled: !hideChecked)),
                          DataCell(_buildCheckboxCell(
                              index, uiComponentName, 'DELETE', _deleteChecks)),
                        ]);
                      }),
                    );
                  }),
            ),
          ),
        );
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
          return Center(
            child: AppWidgetUtils.buildLoading(),
          );
        } else if (futureSnapshot.hasData) {
          List<UserDetailsList> branches = futureSnapshot.data ?? [];
          List<String> userNameList =
              branches.map((e) => e.userName ?? '').toList();
          userNameList.insert(0, AppConstants.allBranch);
          return TldsDropDownButtonFormField(
            height: 40,
            width: 300,
            hintText: AppConstants.userName,
            dropDownItems: userNameList,
            dropDownValue: _accessViewControlBloc.selectedUserName,
            onChange: (String? newValue) async {
              setState(() {
                _accessViewControlBloc.selectedUserName = newValue ?? '';
              });
            },
          );
        } else {
          return const Text('No Data');
        }
      },
    );
  }
}
