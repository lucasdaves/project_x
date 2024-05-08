import 'package:flutter/material.dart';
import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetFinanceSituation extends StatefulWidget {
  final FinanceLogicalModel model;

  const WidgetFinanceSituation({super.key, required this.model});

  @override
  State<WidgetFinanceSituation> createState() => _WidgetFinanceSituationState();
}

class _WidgetFinanceSituationState extends State<WidgetFinanceSituation> {
  Map<Map<String, Color>, String> map = {};

  @override
  void initState() {
    super.initState();
    _buildValues();
  }

  void _buildValues() {
    map.addAll({
      widget.model.getStatus(): widget.model.getRelationPaid(),
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
            "Andamento Geral",
            style: AppTextStyle.size14(),
          ),
          SizedBox(height: AppResponsive.instance.getHeight(12)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.instance.getWidth(16),
            ),
            decoration: BoxDecoration(
              color: AppColor.colorPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
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
              String status = entry.key.entries.first.key;
              String relation = entry.value;
              Color color = entry.key.entries.first.value;

              return Container(
                margin: EdgeInsets.symmetric(
                  vertical: 2,
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
                            text: "Pagamentos:",
                            style: AppTextStyle.size12(
                              color: AppColor.text_1,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          TextSpan(
                            text: " ${relation} parcelas pagas",
                            style: AppTextStyle.size12(
                              color: AppColor.colorNeutralStatus,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      style: AppTextStyle.size12(),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(8)),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Situação:",
                            style: AppTextStyle.size12(
                              color: AppColor.text_1,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          TextSpan(
                            text: " ${status}",
                            style: AppTextStyle.size12(
                              color: color,
                              fontWeight: FontWeight.w600,
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
