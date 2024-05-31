import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tlbilling/models/get_model/get_all_branches_by_pagination.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';

class BranchDetails extends StatefulWidget {
  final List<SubBranch>? subBranches;
  final String? mainBranchName;

  const BranchDetails({super.key, this.subBranches, this.mainBranchName});

  @override
  State<BranchDetails> createState() => _BranchDetailsState();
}

class _BranchDetailsState extends State<BranchDetails> {
  final _appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _appColors.whiteColor,
      surfaceTintColor: _appColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: _buildBranchDetailsTitle(),
      content: _buildBranchDetails(),
    );
  }

  _buildBranchDetailsTitle() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppWidgetUtils.buildText(
                text: AppConstants.branchDetails,
                fontSize: 22,
                color: _appColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  _buildBranchDetails() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppWidgetUtils.buildText(
              text: widget.mainBranchName,
              color: _appColors.grey,
              fontSize: 12),
          AppWidgetUtils.buildText(
              text: widget.mainBranchName,
              color: _appColors.blackColor,
              fontSize: 16),
          const Divider(),
          AppWidgetUtils.buildText(
              text: AppConstants.subBranch,
              color: _appColors.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 14),
          SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: widget.subBranches?.length ?? 0,
              itemBuilder: (context, index) {
                final subBranch = widget.subBranches![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: _appColors.grey,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppWidgetUtils.buildText(
                              text: subBranch.branchName,
                              color: _appColors.blackColor,
                              fontSize: 17),
                          AppWidgetUtils.buildText(
                              text: subBranch.city,
                              color: _appColors.grey,
                              fontSize: 11),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
