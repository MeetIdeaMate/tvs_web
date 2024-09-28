import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/components/custom_pagenation.dart';
import 'package:tlbilling/models/get_model/get_all_product_by_pagination.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/product/product_configuration.dart';
import 'package:tlbilling/view/product/product_view_bloc.dart';
import 'package:tlbilling/view/useraccess/access_level_shared_pref.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final _productViewBlocImpl = ProductViewBlocImpl();
  final _appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgetUtils.buildHeaderText(AppConstants.product),
            AppWidgetUtils.buildSizedBox(custHeight: 26),
            _buildsearchField(context),
            AppWidgetUtils.buildSizedBox(custHeight: 28),
            //  if (AccessLevel.canView(AppConstants.product))
            _buildDataTable(context)
          ],
        ),
      ),
    );
  }

  _buildsearchField(BuildContext context) {
    return Row(
      children: [
        if (AccessLevel.canView(AppConstants.customer)) ...[
          StreamBuilder<bool>(
            stream: _productViewBlocImpl.productNameSearchStream,
            builder: (context, snapshot) {
              return _buildFormField(
                  inputFormatters:
                      TldsInputFormatters.onlyAllowAlphabetAndNumber,
                  _productViewBlocImpl.productNameController,
                  AppConstants.product);
            },
          ),
          AppWidgetUtils.buildSizedBox(custWidth: 5),
          StreamBuilder(
            stream: _productViewBlocImpl.partNoSearchStream,
            builder: (context, snapshot) {
              return _buildFormField(
                _productViewBlocImpl.partNoController,
                AppConstants.partNo,
                inputFormatters: TlInputFormatters.onlyAllowAlphabetAndNumber,
              );
            },
          ),
          AppWidgetUtils.buildSizedBox(custWidth: 5),
          StreamBuilder(
            stream: _productViewBlocImpl.hsnCodeSearchStream,
            builder: (context, snapshot) {
              return _buildFormField(
                  inputFormatters: TldsInputFormatters.onlyAllowNumbers,
                  _productViewBlocImpl.hsnCodeController,
                  AppConstants.hsnCode);
            },
          ),
          AppWidgetUtils.buildSizedBox(custWidth: 20),
        ],
      ],
    );
  }

  Widget _buildFormField(TextEditingController textController, String hintText,
      {List<TextInputFormatter>? inputFormatters}) {
    final bool isTextEmpty = textController.text.isEmpty;
    final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
    final Color iconColor = isTextEmpty ? _appColors.primaryColor : Colors.red;
    return TldsInputFormField(
      inputFormatters: inputFormatters,
      width: MediaQuery.sizeOf(context).width * 0.18,
      height: 40,
      controller: textController,
      hintText: hintText,
      isSearch: true,
      suffixIcon: IconButton(
        onPressed: iconData == Icons.search
            ? () {
                _searchData();
                _checkController(hintText);
              }
            : () {
                textController.clear();
                _searchData();
                _checkController(hintText);
              },
        icon: Icon(
          iconData,
          color: iconColor,
        ),
      ),
      onSubmit: (value) {
        if (value.isNotEmpty) {
          _searchData();
          _checkController(hintText);
        }
      },
    );
  }

  void _searchData() {
    _productViewBlocImpl.getAllProductByPagination();
    _productViewBlocImpl.pageNumberStreamController(0);
  }

  void _checkController(String hintText) {
    if (hintText == AppConstants.product) {
      _productViewBlocImpl.productNameSearchStreamController(true);
    } else if (hintText == AppConstants.partNo) {
      _productViewBlocImpl.partNoSearchStreamController(true);
    } else if (hintText == AppConstants.hsnCode) {
      _productViewBlocImpl.hsnCodeSearchStreamController(true);
    }
  }

  _buildDataTable(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<int>(
          stream: _productViewBlocImpl.pageNumberStream,
          builder: (context, streamSnapshot) {
            int currentPage = streamSnapshot.data ?? 0;
            currentPage = currentPage < 0 ? 0 : currentPage;
            _productViewBlocImpl.currentPage = currentPage;

            return FutureBuilder(
              future: _productViewBlocImpl.getAllProductByPagination(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingIndicator();
                } else if (snapshot.hasData) {
                  return _buildProductTable(
                      context, snapshot.data!, currentPage);
                } else {
                  return _buildNoDataView();
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: AppWidgetUtils.buildLoading(),
    );
  }

  Widget _buildNoDataView() {
    return Center(
      child: SvgPicture.asset(AppConstants.imgNoData),
    );
  }

  Widget _buildProductTable(BuildContext context,
      GetAllProductByPagination productListPage, int currentPage) {
    List<Product>? productList = productListPage.content;

    if (productList?.isEmpty ?? true) {
      return _buildNoDataView();
    }

    return Column(
      children: [
        Expanded(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: _buildDataTableContent(context, productList ?? [])),
        ),
        _buildPagination(productListPage, currentPage),
      ],
    );
  }

  CustomPagination _buildPagination(
      GetAllProductByPagination productListPage, int currentPage) {
    return CustomPagination(
      itemsOnLastPage: productListPage.totalElements ?? 0,
      currentPage: currentPage,
      totalPages: productListPage.totalPages ?? 0,
      onPageChanged: (pageValue) {
        _productViewBlocImpl.pageNumberStreamController(pageValue);
      },
    );
  }

  Widget _buildDataTableContent(
      BuildContext context, List<Product> productList) {
    return SingleChildScrollView(
      child: DataTable(
        dividerThickness: 0.01,
        columns: _buildTableColumns(),
        rows: productList
            .asMap()
            .entries
            .map((entry) => _buildDataRow(entry.key, entry.value))
            .toList(),
      ),
    );
  }

  List<DataColumn> _buildTableColumns() {
    return [
      AppWidgetUtils.buildTableHeader(AppConstants.sno),
      AppWidgetUtils.buildTableHeader(AppConstants.partNo),
      AppWidgetUtils.buildTableHeader(AppConstants.vehicleName),
      AppWidgetUtils.buildTableHeader(AppConstants.hsnCode),
      //  if (AccessLevel.canPUpdate(AppConstants.product))
      AppWidgetUtils.buildTableHeader(AppConstants.action),
    ];
  }

  DataRow _buildDataRow(int index, Product product) {
    return DataRow(
      color: WidgetStateProperty.resolveWith((states) {
        return index % 2 == 0
            ? _appColors.whiteColor
            : _appColors.transparentBlueColor;
      }),
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text(product.partNo ?? '')),
        DataCell(Text(product.itemName ?? '')),
        DataCell(Text(product.hsnSacCode ?? '')),
        //   if (AccessLevel.canPUpdate(AppConstants.product))
        DataCell(
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  AppConstants.icFilledAdd,
                ),
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return ProductConfigurationView(product.itemId);
                    },
                  );
                },
              ),
              AppWidgetUtils.buildSizedBox(custWidth: 5),
              IconButton(
                icon: SvgPicture.asset(
                  AppConstants.icEyeView,
                ),
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return ProductConfigurationView(product.itemId,
                          addOns: product.addOns);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
