import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/user/create_user_dialog_bloc.dart';
import 'package:tlds_flutter/util/app_colors.dart';

class UserActiveInActiveDialog extends StatefulWidget {
  final String? userStatus;
  final String? userId;

  const UserActiveInActiveDialog({super.key, this.userStatus, this.userId});

  @override
  State<UserActiveInActiveDialog> createState() =>
      _UserActiveInActiveDialogState();
}

class _UserActiveInActiveDialogState extends State<UserActiveInActiveDialog> {
  final _createUserDialogBloc = CreateUserDialogBlocImpl();
  final _appColor = AppColor();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _appColor.whiteColor,
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          'Are you sure! \n want to change the ${widget.userStatus ?? 'user'} status',
          textAlign: TextAlign.center,
          style:
              GoogleFonts.nunitoSans(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        AppWidgetUtils.buildSizedBox(custHeight: 18),
        CustomActionButtons(
            onPressed: () {
              if (widget.userStatus == 'ACTIVE' || widget.userId == null) {
                _createUserDialogBloc.userUpdatedStatus = 'INACTIVE';
              } else {
                _createUserDialogBloc.userUpdatedStatus = 'ACTIVE';
              }
              _createUserDialogBloc.updateUserStatus(
                widget.userId,
                (statusCode) {
                  if (statusCode == 200) {
                    Navigator.pop(context);
                  }
                },
              );
            },
            buttonText: 'Change')
      ]),
    );
  }
}
