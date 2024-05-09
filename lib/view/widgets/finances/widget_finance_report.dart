import 'package:flutter/material.dart';
import 'package:project_x/model/finance_controller_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/widgets/list/widget_list_card.dart';

class WidgetFinanceReport extends StatefulWidget {
  final FinanceStreamModel model;

  const WidgetFinanceReport({super.key, required this.model});

  @override
  State<WidgetFinanceReport> createState() => _WidgetFinanceReportState();
}

class _WidgetFinanceReportState extends State<WidgetFinanceReport> {
  Map<List<String>, List<double>> map = {};

  @override
  void initState() {
    super.initState();
    _buildValues();
  }

  void _buildValues() {
    map = widget.model.getReport();
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
          _buildData(),
        ],
      ),
    );
  }

  Widget _buildData() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(
        vertical: AppResponsive.instance.getHeight(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (map.entries.isNotEmpty) ...[
            WidgetListEntityCard(
              value1: "Nome",
              value2: "Valor Pago",
              value3: "A receber",
              value4: "Atrasado",
              isHeader: true,
            ),
            ...map.entries.map((entry) {
              String name = entry.key.first;
              String paid = entry.value.elementAt(0).toStringAsFixed(2);
              String toPay = entry.value.elementAt(1).toStringAsFixed(2);
              String late = entry.value.elementAt(2).toStringAsFixed(2);

              return WidgetListEntityCard(
                value1: name,
                value2: "$paid R\$",
                value3: "$toPay R\$",
                value4: "$late R\$",
                color1: AppColor.text_1,
                color2: AppColor.colorPositiveStatus,
                color3: AppColor.colorNeutralStatus,
                color4: AppColor.colorNegativeStatus,
                isRead: true,
              );
            }).toList(),
          ] else ...[
            Text(
              "Não há nada para exibir até o momento",
              textAlign: TextAlign.center,
              style: AppTextStyle.size16(fontWeight: FontWeight.w300),
            ),
          ],
        ],
      ),
    );
  }
}
