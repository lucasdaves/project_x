import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetFinanceBalance extends StatefulWidget {
  final FinanceLogicalModel model;

  const WidgetFinanceBalance({super.key, required this.model});

  @override
  State<WidgetFinanceBalance> createState() => _WidgetFinanceBalanceState();
}

class _WidgetFinanceBalanceState extends State<WidgetFinanceBalance> {
  Map<Map<String, double>, Color> map = {};

  @override
  void initState() {
    super.initState();
    _buildValues();
  }

  void _buildValues() {
    map.addAll({
      widget.model.getInitialAmount(): AppColor.text_1,
      widget.model.getTotalAmount(): AppColor.colorOpcionalStatus,
      widget.model.getAditiveAmount(): AppColor.colorPositiveStatus,
      widget.model.getCostAmount(): AppColor.colorNegativeStatus,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: AppResponsive.instance.getHeight(145),
      margin: EdgeInsets.symmetric(
        horizontal: AppResponsive.instance.getWidth(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Balanço Financeiro",
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
    return Expanded(
      flex: 4,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: AppResponsive.instance.getHeight(16),
        ),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: AppColor.colorDivider,
              width: AppResponsive.instance.getWidth(4),
            ),
          ),
        ),
        child: RotatedBox(
          quarterTurns: 1,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(show: false),
              barTouchData: BarTouchData(
                enabled: false,
              ),
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: map.entries.first.key.entries.first.value,
                    color: map.entries.first.value,
                    strokeWidth: AppResponsive.instance.getWidth(4),
                  ),
                ],
              ),
              barGroups: map.entries.skip(1).map((entry) {
                return BarChartGroupData(
                  x: AppResponsive.instance
                      .getWidth(entry.key.values.first)
                      .round(),
                  barRods: [
                    BarChartRodData(
                      toY: entry.key.values.first,
                      color: entry.value,
                      width: AppResponsive.instance.getWidth(10),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            swapAnimationDuration: Duration(milliseconds: 150),
            swapAnimationCurve: Curves.linear,
          ),
        ),
      ),
    );
  }

  Widget _buildData() {
    return Expanded(
      flex: 6,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: AppResponsive.instance.getHeight(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...map.entries.map((entry) {
              String status = entry.key.entries.first.key;
              double amount = entry.key.entries.first.value;
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
                            fontWeight: FontWeight.w500,
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
