import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/widgets/actions/widget_action_icon.dart';

class WidgetActionCard extends StatelessWidget {
  final WidgetActionCardModel model;

  const WidgetActionCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppResponsive.instance.getHeight(56),
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.instance.getWidth(24),
      ),
      decoration: BoxDecoration(
        color: AppColor.colorFloating,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (model.label != null) ...[
            Text(
              model.label!,
              style: AppTextStyle.size14(
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(width: AppResponsive.instance.getWidth(24)),
          ],
          if (model.cards.isNotEmpty) ...[
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: model.cards.length,
                separatorBuilder: (context, index) {
                  return SizedBox(width: AppResponsive.instance.getWidth(12));
                },
                itemBuilder: (context, index) {
                  return model.cards.elementAt(index);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class WidgetActionCardModel {
  final List<WidgetActionIcon> cards;
  final String? label;

  WidgetActionCardModel({
    required this.cards,
    this.label,
  });
}
