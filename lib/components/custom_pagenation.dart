import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';

class CustomPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final void Function(int) onPageChanged;
  final int itemsOnLastPage;

  const CustomPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    required this.itemsOnLastPage,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEffectivelyLastPage = itemsOnLastPage < 10;
    final appColor = AppColors();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage == 0 ? null : () => onPageChanged(0),
          icon: SvgPicture.asset(AppConstants.icFirstPage),
          disabledColor: currentPage == 0 ? Colors.grey : null,
        ),
        IconButton(
          onPressed:
              currentPage == 0 ? null : () => onPageChanged(currentPage - 1),
          icon: SvgPicture.asset(AppConstants.icPrevPage),
          disabledColor: currentPage == 0 ? Colors.grey : null,
        ),
        const SizedBox(width: 10),
        for (int i = 1; i <= totalPages; i++)
          if ((currentPage - i).abs() <= 1 || i == 1 || i == totalPages)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: InkWell(
                onTap: () => onPageChanged(i - 1),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: currentPage == i - 1
                          ? appColor.primaryColor
                          : appColor.borderColor,
                      width: 2,
                    ),
                    color: currentPage == i - 1
                        ? appColor.primaryColor
                        : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$i',
                    style: TextStyle(
                      color: currentPage == i - 1 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          else if ((currentPage - i).abs() == 2)
            const Text('...'),
        const SizedBox(width: 10),
        IconButton(
          onPressed: (currentPage == totalPages - 1 || isEffectivelyLastPage)
              ? null
              : () => onPageChanged(currentPage + 1),
          icon: SvgPicture.asset(AppConstants.icNextPage),
          disabledColor:
              (currentPage == totalPages - 1 || isEffectivelyLastPage)
                  ? Colors.grey
                  : null,
        ),
        IconButton(
          onPressed: (currentPage == totalPages - 1 || isEffectivelyLastPage)
              ? null
              : () => onPageChanged(totalPages - 1),
          icon: SvgPicture.asset(AppConstants.icLastPage),
          disabledColor:
              (currentPage == totalPages - 1 || isEffectivelyLastPage)
                  ? Colors.grey
                  : null,
        ),
      ],
    );
  }
}
