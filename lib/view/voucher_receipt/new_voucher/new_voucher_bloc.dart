import 'package:flutter/cupertino.dart';

abstract class NewVoucherBloc {
  TextEditingController get payToTextController;

  TextEditingController get voucherDateTextController;

  TextEditingController get giverTextController;

  TextEditingController get amountTextController;
}

class NewVoucherBlocImpl extends NewVoucherBloc {
  final _payToTextController = TextEditingController();
  final _voucherDateTextController = TextEditingController();
  final _giverTextController = TextEditingController();
  final _amountTextController = TextEditingController();

  @override
  TextEditingController get payToTextController => _payToTextController;

  @override
  TextEditingController get voucherDateTextController =>
      _voucherDateTextController;

  @override
  TextEditingController get giverTextController => _giverTextController;

  @override
  TextEditingController get amountTextController => _amountTextController;
}
