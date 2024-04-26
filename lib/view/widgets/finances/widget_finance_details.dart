import 'package:flutter/material.dart';
import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetFinanceDetails extends StatefulWidget {
  final FinanceLogicalModel model;

  const WidgetFinanceDetails({super.key, required this.model});

  @override
  State<WidgetFinanceDetails> createState() => _WidgetFinanceDetailsState();
}

class _WidgetFinanceDetailsState extends State<WidgetFinanceDetails> {
  Map<String, String> map = {};

  @override
  void initState() {
    super.initState();
    _buildValues();
  }

  void _buildValues() {
    map.addAll({
      "Nome": widget.model.model?.name ?? "",
      "Descrição": widget.model.model?.description ?? "",
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(
        horizontal: AppResponsive.instance.getWidth(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dados Técnicos",
            style: AppTextStyle.size14(),
          ),
          SizedBox(height: AppResponsive.instance.getHeight(12)),
          Container(
            // padding: EdgeInsets.symmetric(
            //   horizontal: AppResponsive.instance.getWidth(16),
            // ),
            // decoration: BoxDecoration(
            //   color: AppColor.colorPrimary,
            //   borderRadius: BorderRadius.circular(8),
            // ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildData(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildData() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: AppResponsive.instance.getHeight(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...map.entries.map((entry) {
              String title = entry.key;
              String value = entry.value;
              Color color = AppColor.text_1;

              return Container(
                margin: EdgeInsets.symmetric(
                  vertical: AppResponsive.instance.getHeight(4),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "$title: ",
                            style: AppTextStyle.size12(
                              color: color,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          TextSpan(
                            text: "$value",
                            style: AppTextStyle.size12(
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      style: AppTextStyle.size12(),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
