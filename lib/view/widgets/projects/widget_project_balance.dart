import 'package:flutter/material.dart';
import 'package:project_x/services/database/model/workflow_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetProjectBalance extends StatefulWidget {
  final WorkflowLogicalModel model;

  const WidgetProjectBalance({super.key, required this.model});

  @override
  State<WidgetProjectBalance> createState() => _WidgetProjectBalanceState();
}

class _WidgetProjectBalanceState extends State<WidgetProjectBalance> {
  Map<Map<String, double>, Color> map = {};

  @override
  void initState() {
    super.initState();
    _buildValues();
  }

  void _buildValues() {
    map.addAll({
      widget.model.getConcludedAmount(): AppColor.colorPositiveStatus,
      widget.model.getDoingAmount(): AppColor.colorNeutralStatus,
      widget.model.getToDoAmount(): AppColor.colorOpcionalStatus,
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
            "Balanço de Projeto",
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
    Map<String, double> total = widget.model.getTotalAmount();

    return Expanded(
      flex: 4,
      child: Container(
        width: double.maxFinite,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: map.entries.map((entry) {
            int flex = (entry.key.entries.first.value * 100) ~/
                total.entries.first.value;

            return Expanded(
              flex: flex,
              child: Container(
                height: AppResponsive.instance.getHeight(12),
                decoration: BoxDecoration(
                  color: entry.value,
                  border: Border.all(
                    color: AppColor.colorDivider,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: map.entries.first.value == entry.value
                        ? Radius.circular(4)
                        : Radius.zero,
                    bottomLeft: map.entries.first.value == entry.value
                        ? Radius.circular(4)
                        : Radius.zero,
                    topRight: map.entries.last.value == entry.value
                        ? Radius.circular(4)
                        : Radius.zero,
                    bottomRight: map.entries.last.value == entry.value
                        ? Radius.circular(4)
                        : Radius.zero,
                  ),
                ),
              ),
            );
          }).toList(),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...map.entries.map((entry) {
              String status = entry.key.entries.first.key;
              int amount = entry.key.entries.first.value.toInt();
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
                          text: "$amount",
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
