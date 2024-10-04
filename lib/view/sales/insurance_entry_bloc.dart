import 'package:flutter/material.dart';

abstract class InsuranceEntryBloc {
  TextEditingController get insuranceCompanyNameTextController;
  TextEditingController get insureDateTextController;
  TextEditingController get insureNumberTextController;
  TextEditingController get insureAmountTextController;
  TextEditingController get premiumAmountTextController;
  TextEditingController get ownEmgDateExpTextController;
  TextEditingController get thirdPartyExpTextController;
  GlobalKey<FormState> get insuranceFormKey;
  bool? get isInsuranceEntryDone;
}

class InsuranceEntryBlocImpl extends InsuranceEntryBloc {
  final _insuranceCompanyNameTextController = TextEditingController();
  final _insureDateTextController = TextEditingController();
  final _insureNumberTextController = TextEditingController();
  final _insureAmountTextController = TextEditingController();
  final _premiumAmountTextController = TextEditingController();
  final _ownEmgDateExpTextController = TextEditingController();
  final _thirdPartyExpTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool? _isInsuranceEntryDone = false;
  @override
  TextEditingController get insuranceCompanyNameTextController =>
      _insuranceCompanyNameTextController;

  @override
  TextEditingController get insureAmountTextController =>
      _insureAmountTextController;

  @override
  TextEditingController get insureDateTextController =>
      _insureDateTextController;

  @override
  TextEditingController get insureNumberTextController =>
      _insureNumberTextController;

  @override
  TextEditingController get ownEmgDateExpTextController =>
      _ownEmgDateExpTextController;

  @override
  TextEditingController get premiumAmountTextController =>
      _premiumAmountTextController;

  @override
  TextEditingController get thirdPartyExpTextController =>
      _thirdPartyExpTextController;

  @override
  GlobalKey<FormState> get insuranceFormKey => _formKey;

  @override
  bool? get isInsuranceEntryDone => _isInsuranceEntryDone;

  set isInsuranceEntryDone(bool? value) {
    _isInsuranceEntryDone = value;
  }
}
