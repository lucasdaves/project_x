import 'package:flutter/material.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/view/widgets/actions/widget_action_back.dart';
import 'package:project_x/view/widgets/actions/widget_action_card.dart';
import 'package:project_x/view/widgets/actions/widget_action_search.dart';

class WidgetActionHeader extends StatelessWidget {
  final WidgetActionHeaderModel model;

  const WidgetActionHeader({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppResponsive.instance.getHeight(56),
      width: double.maxFinite,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (model.backAction != null) ...[
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (model.backAction != null) ...[
                    Flexible(child: model.backAction!),
                  ],
                ],
              ),
            ),
          ],
          if (model.searchAction != null || model.cardAction != null) ...[
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (model.searchAction != null) ...[
                    Flexible(child: model.searchAction!),
                  ],
                  if (model.cardAction != null) ...[
                    Flexible(child: model.cardAction!),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class WidgetActionHeaderModel {
  final WidgetActionBack? backAction;
  final WidgetActionSearch? searchAction;
  final WidgetActionCard? cardAction;

  WidgetActionHeaderModel({
    this.backAction,
    this.searchAction,
    this.cardAction,
  });
}
