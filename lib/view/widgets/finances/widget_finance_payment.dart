import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetFinancePayment extends StatefulWidget {
  final FinanceLogicalModel model;

  const WidgetFinancePayment({super.key, required this.model});

  @override
  State<WidgetFinancePayment> createState() => _WidgetFinancePaymentState();
}

class _WidgetFinancePaymentState extends State<WidgetFinancePayment> {
  Map<Map<String, double>, Color> map = {};

  @override
  void initState() {
    super.initState();
    _buildValues();
  }

  void _buildValues() {
    map.addAll({
      widget.model.getPaidAmount(): AppColor.colorPositiveStatus,
    });

    if (widget.model.getStatus().keys.first.values.first) {
      map.addAll({
        widget.model.getToPayAmount(): AppColor.colorNeutralStatus,
        widget.model.getLateAmount(): AppColor.colorNegativeStatus,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: AppResponsive.instance.getHeight(130),
      margin: EdgeInsets.symmetric(
        horizontal: AppResponsive.instance.getWidth(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Situação de Pagamento",
            style: AppTextStyle.size14(),
          ),
          SizedBox(height: AppResponsive.instance.getHeight(12)),
          Expanded(
            child: Container(
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
                  _buildChart(),
                  SizedBox(width: AppResponsive.instance.getWidth(20)),
                  _buildData(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    int percentage = ((widget.model.getPaidAmount().entries.first.value * 100) /
            widget.model.getInitialAmount().entries.first.value)
        .floor();

    return Expanded(
      flex: 4,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: AppResponsive.instance.getHeight(16),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieChart(
              PieChartData(
                sections: map.entries.map((entry) {
                  return PieChartSectionData(
                    color: entry.value,
                    value: entry.key.values.first,
                    radius: AppResponsive.instance.getWidth(10),
                    showTitle: false,
                  );
                }).toList(),
              ),
              swapAnimationDuration: Duration(milliseconds: 150),
              swapAnimationCurve: Curves.linear,
            ),
            Text(
              "${percentage}%",
              style: AppTextStyle.size12(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildData() {
    return Expanded(
      flex: 7,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: AppResponsive.instance.getHeight(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...map.entries.map((entry) {
              String status = entry.key.entries.first.key;
              String amount = entry.key.entries.first.value.toStringAsFixed(2);
              Color color = entry.value;

              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: AppResponsive.instance.getWidth(10),
                    width: AppResponsive.instance.getWidth(10),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(width: AppResponsive.instance.getWidth(10)),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "$status - ",
                          style: AppTextStyle.size12(
                            color: AppColor.text_1,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        TextSpan(
                          text: "$amount R\$",
                          style: AppTextStyle.size12(
                            color: AppColor.text_1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    style: AppTextStyle.size12(),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
