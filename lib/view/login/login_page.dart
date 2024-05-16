import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/components/custom_form_field.dart';
import 'package:tlbilling/components/side_menu_navigation.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_validation.dart';
import 'package:tlbilling/view/login/login_page_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _appColors = AppColors();
  final _loginPageBlocImpl = LoginPageBlocImpl();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(AppConstants.imgLoginPagebg),
        ),
      ),
      child: Center(
        child: buildLoginContainer(),
      ),
    ));
  }

  buildLoginContainer() {
    return SingleChildScrollView(
      child: Container(
        width: 460,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              spreadRadius: -5,
              offset: Offset(-2, 2),
              blurStyle: BlurStyle.outer,
              color: Colors.black,
              blurRadius: 10,
            ),
          ],
          color: _appColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 48),
        child: Form(
          key: _loginPageBlocImpl.loginFormKey,
          child: Column(
            children: [
              AppWidgetUtils.buildText(
                  text: AppConstants.loginheader,
                  fontSize: 28,
                  color: _appColors.blackColor,
                  fontWeight: FontWeight.w600),
              AppWidgetUtils.buildSizedBox(custHeight: 28),
              CustomFormField(
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                labelText: AppConstants.mobileNumberLable,
                controller: _loginPageBlocImpl.mobileNumberTextController,
                hintText: AppConstants.mobileNumberHint,
                validator: (validation) =>
                    InputValidations.mobileNumberValidation(validation!),
              ),
              StreamBuilder(
                stream: _loginPageBlocImpl.passwordVisibleStream,
                builder: (context, snapshot) {
                  return CustomFormField(
                    labelText: AppConstants.passwordLable,
                    controller: _loginPageBlocImpl.passwordTextController,
                    hintText: AppConstants.passwordHint,
                    obscure: !_loginPageBlocImpl.ispasswordVisible,
                    suffixIcon: IconButton(
                      onPressed: () {
                        _loginPageBlocImpl.ispasswordVisible =
                            !_loginPageBlocImpl.ispasswordVisible;
                        _loginPageBlocImpl.passwordVisbleStreamControler(true);
                      },
                      icon: Icon(
                          _loginPageBlocImpl.ispasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: _appColors.greyColor),
                    ),
                    validator: (validation) =>
                        InputValidations.passwordValidation(validation!),
                  );
                },
              ),
              AppWidgetUtils.buildSizedBox(custHeight: 32),
              CustomElevatedButton(
                height: 52,
                width: double.infinity,
                text: AppConstants.loginButtonLable,
                buttonBackgroundColor: _appColors.primaryColor,
                fontSize: 16,
                fontColor: _appColors.whiteColor,
                onPressed: () {
                  if (_loginPageBlocImpl.loginFormKey.currentState!
                      .validate()) {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return const SideMenuNavigation();
                      },
                    ));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
