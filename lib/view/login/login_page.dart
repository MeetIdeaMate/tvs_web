import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:tlbilling/components/custom_elevated_button.dart';
import 'package:tlbilling/components/side_menu_navigation.dart';
import 'package:tlbilling/services/status_handling.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/input_validation.dart';
import 'package:tlbilling/view/login/login_page_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _appColors = AppColors();
  final _loginPageBlocImpl = LoginPageBlocImpl();
  bool _loading = false;
  final _statusHandler = StatusMessageHandling();

  @override
  void initState() {
    super.initState();
    _loginPageBlocImpl.mobileNumberTextController.text = '9876543210';
    _loginPageBlocImpl.passwordTextController.text = '1234';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlurryModalProgressHUD(
            inAsyncCall: _loading,
            progressIndicator: AppWidgetUtils.buildLoading(),
            color: _appColors.whiteColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    height: MediaQuery.sizeOf(context).height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(AppConstants.imgLoginPagebg),
                      ),
                    ),
                  ),
                ),
                AppWidgetUtils.buildSizedBox(
                    custWidth: MediaQuery.sizeOf(context).width * 0.07),
                Center(
                  child: buildLoginContainer(),
                ),
                AppWidgetUtils.buildSizedBox(
                    custWidth: MediaQuery.sizeOf(context).width * 0.07),
              ],
            )));
  }

  buildLoginContainer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Container(
              height: 70,
              width: MediaQuery.sizeOf(context).width * 0.15,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(AppConstants.imgTvsLogo),
                ),
              ),
            ),
          ),
          AppWidgetUtils.buildText(
              text: AppConstants.hasiniTvs,
              fontSize: 34,
              fontWeight: FontWeight.w700),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: _buildBoxDecoration(),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 48),
            child: Form(
              key: _loginPageBlocImpl.loginFormKey,
              child: Column(
                children: [
                  _buildHeadingText(),
                  AppWidgetUtils.buildSizedBox(custHeight: 26),
                  _buildMobNoTextFeild(),
                  AppWidgetUtils.buildSizedBox(custHeight: 26),
                  _buildPasswordTextField(),
                  AppWidgetUtils.buildSizedBox(custHeight: 26),
                  _buildLoginButton()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
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
    );
  }

  Widget _buildHeadingText() {
    return AppWidgetUtils.buildText(
        text: AppConstants.loginheader,
        fontSize: 28,
        color: _appColors.blackColor,
        fontWeight: FontWeight.w600);
  }

  Widget _buildMobNoTextFeild() {
    return TldsInputFormField(
      maxLength: 10,
      counterText: '',
      inputFormatters: TldsInputFormatters.onlyAllowNumbers,
      labelText: AppConstants.mobileNumberLable,
      controller: _loginPageBlocImpl.mobileNumberTextController,
      hintText: AppConstants.mobileNumberHint,
      validator: (validation) =>
          InputValidations.mobileNumberValidation(validation!),
    );
  }

  Widget _buildPasswordTextField() {
    return StreamBuilder(
      stream: _loginPageBlocImpl.passwordVisibleStream,
      builder: (context, snapshot) {
        return TldsInputFormField(
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
                color: _appColors.primaryColor),
          ),
          validator: (validation) =>
              InputValidations.passwordValidation(validation!),
        );
      },
    );
  }

  Widget _buildLoginButton() {
    return CustomElevatedButton(
      height: 52,
      width: double.infinity,
      text: AppConstants.loginButtonLable,
      buttonBackgroundColor: _appColors.primaryColor,
      fontSize: 16,
      fontColor: _appColors.whiteColor,
      onPressed: _buiuldOnPressed,
    );
  }

  _buiuldOnPressed() async {
    if (_loginPageBlocImpl.loginFormKey.currentState!.validate()) {
      _isLoadingState(state: true);
      _loginPageBlocImpl.login((statusCode) {
        if (statusCode == 200 || statusCode == 201) {
          _isLoadingState(state: true);
          Future.delayed(const Duration(seconds: 3), () {
            _statusHandler.handleSuccess(context, AppConstants.loginSuccess,
                AppConstants.loginToApplication);
            _isLoadingState(state: false);
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return const SideMenuNavigation();
              },
            ));
          });
        } else {
          _isLoadingState(state: false);
          _statusHandler.handleSuccess(context, AppConstants.loginFailed,
              AppConstants.somethingWentWrong);
        }
      });
    }
  }

  void _isLoadingState({required bool state}) {
    setState(() {
      _loading = state;
    });
  }
}
