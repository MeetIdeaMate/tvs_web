import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_all_booking_list_with_pagination.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/view/booking/add_booking/add_booking_dialog.dart';
import 'package:tlbilling/view/booking/booking_list_bloc.dart';
import 'package:tlbilling/view/login/login_page.dart';
import 'package:tlds_flutter/components/tlds_dropdown_button_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';
import 'package:toastification/toastification.dart';

class BookingList extends StatefulWidget {
  const BookingList({super.key});

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList>
    with SingleTickerProviderStateMixin {
  final _appColors = AppColors();
  final _bookingListBloc = BookingListBlocImpl();
  Future<void> getBranchName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _bookingListBloc.isMainBranch = prefs.getBool('mainBranch');
    });
  }

  @override
  void initState() {
    _bookingListBloc.selectedPaymentType = AppConstants.allPayments;
    _bookingListBloc.selectedBranchName = AppConstants.allBranchs;
    getBranchName();
    _bookingListBloc.bookingTabController =
        TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppWidgetUtils.buildHeaderText(AppConstants.booking),
              AppWidgetUtils.buildSizedBox(custHeight: 26),
              _buildSearchFieldsAndAddBookButton(),
              _buildDefaultHeight(),
              _buildTabBar(),
              _buildTabBarView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFieldsAndAddBookButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _bookingIdField(),
            _buildDefaultWidth(),
            _buildCustomerNameField(),
            _buildDefaultWidth(),
            _buildPaymentTypeDropdown(),
            _buildDefaultWidth(),
            if (_bookingListBloc.isMainBranch ?? false) _buildBranchDropdown()
          ],
        ),
        _buildAddBookButton(),
      ],
    );
  }

  _buildBranchDropdown() {
    return FutureBuilder(
        future: _bookingListBloc.getBranchName(),
        builder: (context, snapshot) {
          List<String>? branchNameList = snapshot.data?.result?.getAllBranchList
              ?.map((e) => e.branchName)
              .where((branchName) => branchName != null)
              .cast<String>()
              .toList();
          branchNameList?.insert(0, AppConstants.allBranchs);
          return _buildDropDown(
            dropDownItems: (snapshot.hasData &&
                    (snapshot.data?.result?.getAllBranchList?.isNotEmpty ==
                        true))
                ? branchNameList
                : List.empty(),
            hintText: (snapshot.connectionState == ConnectionState.waiting)
                ? AppConstants.loading
                : (snapshot.hasError || snapshot.data == null)
                    ? AppConstants.errorLoading
                    : AppConstants.branchName,
            selectedvalue: _bookingListBloc.selectedBranchName,
            onChange: (value) {
              _bookingListBloc.branchId = value;
              _bookingListBloc.pageNumberUpdateStreamController(0);
            },
          );
        });
  }

  _buildDropDown(
      {List<String>? dropDownItems,
      String? hintText,
      String? selectedvalue,
      Function(String?)? onChange}) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: TldsDropDownButtonFormField(
        width: MediaQuery.of(context).size.width * 0.1,
        height: 40,
        dropDownItems: dropDownItems!,
        dropDownValue: selectedvalue,
        hintText: hintText,
        onChange: onChange ??
            (String? newValue) {
              selectedvalue = newValue ?? '';
            },
      ),
    );
  }

  _bookingIdField() {
    return StreamBuilder(
      stream: _bookingListBloc.bookingIdFieldStreamController,
      builder: (context, snapshot) {
        return _buildFormField(
          _bookingListBloc.bookingIdTextController,
          AppConstants.bookingId,
          TldsInputFormatters.onlyAllowNumbers,
        );
      },
    );
  }

  Widget _buildCustomerNameField() {
    return StreamBuilder(
      stream: _bookingListBloc.customerFieldStreamController,
      builder: (context, snapshot) {
        return _buildFormField(
          _bookingListBloc.customerTextController,
          AppConstants.customerName,
          TldsInputFormatters.onlyAllowAlphabets,
        );
      },
    );
  }

  Widget _buildPaymentTypeDropdown() {
    return FutureBuilder(
      future: _bookingListBloc.getPaymentsList(),
      builder: (context, snapshot) {
        List<String> paymentTypesList = [AppConstants.allPayments];
        if (snapshot.hasData) {
          paymentTypesList.addAll(snapshot.data?.configuration ?? []);
        }
        if (_bookingListBloc.selectedPaymentType?.isEmpty ?? false) {
          _bookingListBloc.selectedPaymentType = AppConstants.allPayments;
        }
        return TldsDropDownButtonFormField(
          height: 40,
          width: 203,
          hintText: AppConstants.payments,
          dropDownItems: paymentTypesList,
          dropDownValue: _bookingListBloc.selectedPaymentType,
          onChange: (String? newValue) {
            _bookingListBloc.selectedPaymentType = newValue ?? '';
            _bookingListBloc.pageNumberUpdateStreamController(0);
          },
        );
      },
    );
  }

  Widget _buildAddBookButton() {
    return CustomElevatedButton(
      height: 40,
      width: 189,
      text: AppConstants.addBook,
      fontSize: 14,
      buttonBackgroundColor: _appColors.primaryColor,
      fontColor: _appColors.whiteColor,
      suffixIcon: SvgPicture.asset(AppConstants.icAdd),
      onPressed: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AddBookingDialog(
            bookingListBloc: _bookingListBloc,
          ),
        );
      },
    );
  }

  Widget _buildFormField(TextEditingController textController, String hintText,
      List<TextInputFormatter>? inputFormatters) {
    final bool isTextEmpty = textController.text.isEmpty;
    final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
    final Color iconColor = isTextEmpty ? _appColors.primaryColor : Colors.red;
    return TldsInputFormField(
      width: 203,
      height: 40,
      inputFormatters: inputFormatters,
      controller: textController,
      hintText: hintText,
      isSearch: true,
      suffixIcon: IconButton(
        onPressed: iconData == Icons.search
            ? () {
                _searchFilters();
                _checkController(hintText);
              }
            : () {
                textController.clear();
                _searchFilters();
                _checkController(hintText);
              },
        icon: Icon(
          iconData,
          color: iconColor,
        ),
      ),
      onSubmit: (p0) {
        _searchFilters();
        _checkController(hintText);
      },
    );
  }

  void _searchFilters() {
    _bookingListBloc.pageNumberUpdateStreamController(0);
  }

  void _checkController(String hintText) {
    if (AppConstants.bookingId == hintText) {
      _bookingListBloc.bookingIdFieldStream(true);
    } else if (AppConstants.customerName == hintText) {
      _bookingListBloc.customerFieldStream(true);
    }
  }

  Widget _buildBookingListTable() {
    return StreamBuilder(
      stream: _bookingListBloc.pageNumberStream,
      builder: (context, streamSnapShot) {
        int currentPage = streamSnapShot.data ?? 0;
        if (currentPage < 0) currentPage = 0;
        _bookingListBloc.currentPage = currentPage;
        return FutureBuilder(
          future: _bookingListBloc.getBookingListWithPagination((statusCode) {
            if (statusCode == 401) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ));
            }
          }, bookingStatus: () {
            switch (_bookingListBloc.bookingTabController.index) {
              case 0:
                return 'INPROGRESS';
              case 1:
                return AppConstants.completed;
              case 2:
                return AppConstants.cancelled;
              default:
                return '';
            }
          }()),
          builder: (context, snapshot) {
            List<BookingDetails> bookingDetails =
                snapshot.data?.bookingDetails ?? [];
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Expanded(
                  child: Center(child: AppWidgetUtils.buildLoading()));
            } else if (snapshot.hasData) {
              GetBookingListWithPagination? bookingList = snapshot.data;
              if (!snapshot.hasData || bookingDetails.isEmpty == true) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppConstants.imgNoData),
                        AppWidgetUtils.buildSizedBox(custHeight: 8),
                        Text(
                          AppConstants.noBookingDataAvailable,
                          style: TextStyle(color: _appColors.grey),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columns: _buildBookingListTableColumns(),
                                rows:
                                    _buildBookingListTableRows(bookingDetails)),
                          ),
                        ),
                        CustomPagination(
                          itemsOnLastPage: bookingList?.totalElements ?? 0,
                          currentPage: currentPage,
                          totalPages: bookingList?.totalPages ?? 0,
                          onPageChanged: (pageValue) {
                            _bookingListBloc
                                .pageNumberUpdateStreamController(pageValue);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            } else {
              return Expanded(
                  child:
                      Center(child: SvgPicture.asset(AppConstants.imgNoData)));
            }
          },
        );
      },
    );
  }

  List<DataColumn> _buildBookingListTableColumns() {
    return [
      _buildTableHeader(AppConstants.sno, flex: 1),
      _buildTableHeader(AppConstants.bookingId, flex: 2),
      _buildTableHeader(AppConstants.date, flex: 2),
      _buildTableHeader(AppConstants.customerName, flex: 2),
      _buildTableHeader(AppConstants.vehicleName, flex: 2),
      _buildTableHeader(AppConstants.paymentType, flex: 2),
      if (_bookingListBloc.isMainBranch ?? false)
        _buildTableHeader(AppConstants.branchName, flex: 2),
      _buildTableHeader(AppConstants.amount, flex: 2),
      _buildTableHeader(AppConstants.executiveName, flex: 2),
      _buildTableHeader(AppConstants.targetInvDate, flex: 2),
      if (_bookingListBloc.bookingTabController.index == 0)
        _buildTableHeader(AppConstants.action, flex: 2),
    ];
  }

  List<DataRow> _buildBookingListTableRows(
      List<BookingDetails> bookingDetails) {
    return bookingDetails.asMap().entries.map((entry) {
      return DataRow(
        color: MaterialStateColor.resolveWith((states) {
          if (entry.key % 2 == 0) {
            return Colors.white;
          } else {
            return _appColors.transparentBlueColor;
          }
        }),
        cells: [
          DataCell(Text('${entry.key + 1}')),
          DataCell(Text(entry.value.bookingNo ?? '')),
          DataCell(Text(
              AppUtils.apiToAppDateFormat(entry.value.bookingDate.toString()))),
          DataCell(Text(entry.value.customerName ?? '')),
          DataCell(Row(
            children: [
              Text(entry.value.itemName ?? ''),
              AppWidgetUtils.buildSizedBox(custWidth: 5),
              Visibility(
                visible: entry.value.additionalInfo?.isNotEmpty ?? false,
                child: Tooltip(
                  richMessage: TextSpan(
                    children: [
                      const TextSpan(
                        text: '${AppConstants.additionalInfo}\n',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: entry.value.additionalInfo,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: _appColors.primaryColor,
                  ),
                ),
              )
            ],
          )),
          DataCell(Text(entry.value.paidDetail?.paymentType ?? '')),
          if (_bookingListBloc.isMainBranch ?? false)
            DataCell(Text(entry.value.branchName ?? '')),
          DataCell(Text(AppUtils.formatCurrency(
              entry.value.paidDetail?.paidAmount?.toDouble() ?? 0))),
          DataCell(Text(entry.value.executiveName ?? '')),
          DataCell(Text(AppUtils.apiToAppDateFormat(
              entry.value.targetInvoiceDate.toString()))),
          if (_bookingListBloc.bookingTabController.index == 0)
            DataCell(_buildCancelButton(entry)),
        ],
      );
    }).toList();
  }

  Widget _buildCancelButton(MapEntry<int, BookingDetails> entry) {
    return IconButton(
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => BlurryModalProgressHUD(
              inAsyncCall: _bookingListBloc.isLoading,
              progressIndicator: AppWidgetUtils.buildLoading(),
              child: AlertDialog(
                surfaceTintColor: _appColors.whiteColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cancel,
                      color: _appColors.red,
                      size: 35,
                    ),
                    AppWidgetUtils.buildSizedBox(custHeight: 10),
                    const Text(
                      AppConstants.cancelBookingDialogMsg,
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                actions: [
                  CustomActionButtons(
                      onPressed: () {
                        _isLoading(true);
                        _bookingListBloc.bookingCancel(entry.value.bookingNo,
                            (statusCode) {
                          if (statusCode == 200 || statusCode == 201) {
                            _isLoading(false);
                            Navigator.pop(context);
                            _bookingListBloc
                                .pageNumberUpdateStreamController(0);
                            AppWidgetUtils.buildToast(
                                context,
                                ToastificationType.success,
                                AppConstants.bookingCancelled,
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: _appColors.successColor,
                                ),
                                AppConstants.bookingCancelledDes,
                                _appColors.successLightColor);
                          } else {
                            _isLoading(false);
                            AppWidgetUtils.buildToast(
                                context,
                                ToastificationType.error,
                                AppConstants.bookingCancelledErr,
                                Icon(
                                  Icons.error_outline_outlined,
                                  color: _appColors.errorColor,
                                ),
                                AppConstants.somethingWentWrong,
                                _appColors.errorLightColor);
                          }
                        });
                      },
                      buttonText: AppConstants.submit)
                ],
              ),
            ),
          );
        },
        icon: Icon(
          Icons.cancel,
          color: _appColors.errorColor,
        ));
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

  Widget _buildDefaultWidth({double? width}) {
    return AppWidgetUtils.buildSizedBox(
        custWidth: width ?? MediaQuery.sizeOf(context).width * 0.01);
  }

  Widget _buildDefaultHeight({double? height}) {
    return AppWidgetUtils.buildSizedBox(
        custHeight: height ?? MediaQuery.sizeOf(context).height * 0.02);
  }

  _isLoading(bool? isLoadingState) {
    setState(() {
      _bookingListBloc.isLoading = isLoadingState;
    });
  }

  Widget _buildTabBar() {
    return SizedBox(
      width: 400,
      child: TabBar(
        controller: _bookingListBloc.bookingTabController,
        tabs: const [
          Tab(text: AppConstants.inProgress),
          Tab(text: AppConstants.completed),
          Tab(text: AppConstants.cancelled),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _bookingListBloc.bookingTabController,
        children: [
          _buildBookingListTable(),
          _buildBookingListTable(),
          _buildBookingListTable(),
        ],
      ),
    );
  }
}
