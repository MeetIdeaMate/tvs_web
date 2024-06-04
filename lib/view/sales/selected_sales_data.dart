// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class SelectedSalesData extends StatefulWidget {
  AddSalesBlocImpl addSalesBloc;
  SelectedSalesData({
    super.key,
    required this.addSalesBloc,
  });

  @override
  State<SelectedSalesData> createState() => _SelectedSalesDataState();
}

class _SelectedSalesDataState extends State<SelectedSalesData> {
  final _appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        Text(
          AppConstants.selectVehicleAndAccessories,
          style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: _appColors.primaryColor),
        ),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        Flexible(
          child: StreamBuilder<bool>(
              stream: widget.addSalesBloc.selectedSalesStreamItems,
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: widget.addSalesBloc.selectedItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    widget.addSalesBloc.salesIndex = index;
                    return widget.addSalesBloc.selectedItems[index];
                  },
                );
              }),
        ),
        _buildGSTType(),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        _buildDiscount(context),
        const Divider(),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Taxable Amount : ₹ 10,0000',
              style: TextStyle(fontSize: 14),
            ),
            AppWidgetUtils.buildSizedBox(custHeight: 6),
            const Text('CGST (14%)  : ₹ 14,000',
                style: TextStyle(fontSize: 14)),
            AppWidgetUtils.buildSizedBox(custHeight: 6),
            const Text('SGST(14%) :  ₹ 14,000', style: TextStyle(fontSize: 14)),
            AppWidgetUtils.buildSizedBox(custHeight: 6),
            const Text('Disc :  10%', style: TextStyle(fontSize: 14)),
            AppWidgetUtils.buildSizedBox(custHeight: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: _appColors.bgHighlightColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: const Text('Total Inv Amount : ₹ 12,8000',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            AppWidgetUtils.buildSizedBox(custHeight: 10),
            Row(
              children: [
                Checkbox(
                  value: widget.addSalesBloc.isInsurenceChecked,
                  onChanged: (value) {
                    setState(() {
                      widget.addSalesBloc.isInsurenceChecked = value!;
                    });
                  },
                ),
                AppWidgetUtils.buildSizedBox(custWidth: 5),
                const Text('Insurance for the vehicle YES / NO'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDiscount(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: widget.addSalesBloc.isDiscountChecked,
              onChanged: (value) {
                setState(() {
                  widget.addSalesBloc.isDiscountChecked = value ?? false;
                });
              },
            ),
            AppWidgetUtils.buildSizedBox(custWidth: 5),
            const Text(AppConstants.discount),
          ],
        ),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        if (widget.addSalesBloc.isDiscountChecked)
          TldsInputFormField(
            width: 300,
            controller: widget.addSalesBloc.discountTextController,
            hintText: AppConstants.discount,
          ),
      ],
    );
  }

  Widget _buildGSTType() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppConstants.gstType,
          style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: _appColors.primaryColor),
        ),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio(
                  value: 'GST',
                  groupValue: widget.addSalesBloc.selectedGstType,
                  onChanged: (value) {
                    setState(() {
                      widget.addSalesBloc.selectedGstType = value ?? '';
                    });
                  },
                ),
                const Text('GST(%)'),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 'IGST',
                  groupValue: widget.addSalesBloc.selectedGstType,
                  onChanged: (value) {
                    setState(() {
                      widget.addSalesBloc.selectedGstType = value ?? '';
                    });
                  },
                ),
                const Text('IGST(%)'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
