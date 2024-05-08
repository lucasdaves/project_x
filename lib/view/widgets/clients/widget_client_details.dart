import 'package:flutter/material.dart';
import 'package:project_x/services/database/model/client_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetClientDetails extends StatefulWidget {
  final ClientLogicalModel model;

  const WidgetClientDetails({super.key, required this.model});

  @override
  State<WidgetClientDetails> createState() => _WidgetClientDetailsState();
}

class _WidgetClientDetailsState extends State<WidgetClientDetails> {
  Map<String, String> map = {};

  @override
  void initState() {
    super.initState();
    _buildValues();
  }

  void _buildValues() {
    map.addAll({
      "Nome": widget.model.personal?.model?.name ?? "Não Informado",
      "Documento": widget.model.personal?.model?.document ?? "Não Informado",
      "Telefone": widget.model.personal?.model?.phone ?? "Não Informado",
      "Email": widget.model.personal?.model?.email ?? "Não Informado",
      "Endereço":
          widget.model.personal?.address?.getAddress() ?? "Não Informado",
      "Anotação": widget.model.personal?.model?.annotation ?? "Não Informado",
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
              String title = entry.key;
              String value = entry.value;
              Color color = AppColor.text_1;

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
