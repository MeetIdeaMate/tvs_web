import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Corrected import
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/models/get_model/get_all_sales_list_model.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';

class PaymentHistoryDialog extends StatefulWidget {
  final Content? salesdata;
  const PaymentHistoryDialog({super.key, this.salesdata});

  @override
  State<PaymentHistoryDialog> createState() => _PaymentHistoryDialogState();
}

class _PaymentHistoryDialogState extends State<PaymentHistoryDialog> {
  // ignore: prefer_typing_uninitialized_variables
  late var _paymentHistoryDetails;
  final _appColors = AppColors();

  @override
  void initState() {
    super.initState();
    _paymentHistoryDetails = widget.salesdata?.paidDetails ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: _buildAlertDialogContent(),
    );
  }

  Widget _buildAlertDialogContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeaderOfTheDialog(),
        const Divider(),
        _buildPatientDetails(),
        AppWidgetUtils.buildSizedBox(custHeight: 8),
        _buildListOfTheDialog(),
        _buildOverAllPaymentCard()
      ],
    );
  }

  Widget _buildHeaderOfTheDialog() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTextWidget('Payment History',
            fontWeight: FontWeight.w700, fontSize: 20),
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close))
      ],
    );
  }

  Widget _buildPatientDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextWidget(
                'Customer Name: ${widget.salesdata?.customerName ?? ''}'),
            AppWidgetUtils.buildSizedBox(custHeight: 8),
            _buildTextWidget(
                'Mobile Number: ${widget.salesdata?.mobileNo ?? ''}'),
          ],
        ),
      ],
    );
  }

  Widget _buildListOfTheDialog() {
    return SizedBox(
      height: 350,
      width: 500,
      child: _buildPaymentHistoryList(),
    );
  }

  Widget _buildPaymentHistoryList() {
    if (_paymentHistoryDetails.isEmpty) {
      return Center(child: SvgPicture.asset(AppConstants.imgNoData));
    } else {
      return ListView.builder(
        itemCount: _paymentHistoryDetails.length,
        itemBuilder: (context, index) {
          var response = _paymentHistoryDetails[index];
          return _buildPaymentHistoryListCard(response);
        },
      );
    }
  }

  Widget _buildPaymentHistoryListCard(PaidDetail? response) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ListTile(
            title: _buildTextWidget(
                AppUtils.formatCurrency(response?.paidAmount?.toDouble() ?? 0)),
            subtitle: _buildTextWidget(response?.paymentReference ?? ''),
            trailing: _buildTextWidget(
                'Date: ${AppUtils.apiToAppDateFormat(response?.paymentDate.toString() ?? '')}'),
          ),
          if (response?.cancelled == true)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                AppConstants.cancelled,
                style: TextStyle(color: Colors.red),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildTextWidget(String text,
      {double? fontSize,
      FontWeight? fontWeight,
      TextOverflow? textOverflow,
      Color? color}) {
    return Text(
      text,
      style: GoogleFonts.nunitoSans(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color ?? Colors.black),
      overflow: textOverflow ?? TextOverflow.fade,
    );
  }

  Widget _buildOverAllPaymentCard() {
    return Card(
      color: _appColors.hightlightColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextWidget('Total Fees'),
                _buildTextWidget(AppUtils.formatCurrency(
                    widget.salesdata?.totalInvoiceAmt ?? 0))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextWidget('Balance Fees'),
                _buildTextWidget(
                    AppUtils.formatCurrency(widget.salesdata?.pendingAmt ?? 0))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
