// import 'package:flutter/material.dart';
// import 'package:project_x/controller/finance_controller.dart';
// import 'package:project_x/controller/workflow_controller.dart';
// import 'package:project_x/services/database/model/finance_model.dart';
// import 'package:project_x/services/database/model/workflow_model.dart';
// import 'package:project_x/utils/app_color.dart';
// import 'package:project_x/utils/app_enum.dart';
// import 'package:project_x/utils/app_responsive.dart';
// import 'package:project_x/view/forms/sections/widget_entity_sections.dart';

// class WidgetEntityDialog extends StatefulWidget {
//   final EntityType type;
//   final EntityOperation operation;
//   final dynamic model;

//   const WidgetEntityDialog({
//     super.key,
//     required this.type,
//     required this.operation,
//     required this.model,
//   });

//   @override
//   State<WidgetEntityDialog> createState() => _WidgetEntityDialogState();
// }

// class _WidgetEntityDialogState extends State<WidgetEntityDialog> {
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   final userSection = UserSection();
//   final personalDataSection = PersonalDataSection();
//   final addressSection = AddressSection();
//   final contactSection = ContactSection();
//   final projectSection = ProjectSection();
//   final workflowOperationSection = WorkflowOperationSection();
//   final descriptionSection = DescriptionSection();
//   final operationSection = OperationSection();
//   final workflowSection = WorkflowSection();

//   void _setSectionValues() {
//     switch (widget.type) {
//       case EntityType.Workflow:
//         _setSectionValuesForWorkflow();
//         break;
//       case EntityType.Finance:
//         _setSectionValuesForFinance();
//         break;
//       default:
//         throw Exception("Tipo de entidade não suportado");
//     }
//   }

//   void _setSectionValuesForWorkflow() {
//     if (widget.entityIndex != null) {
//       WorkflowLogicalModel existingModel = WorkflowController
//           .instance.stream.value
//           .getOne(id: widget.entityIndex)!;
//       controller.setModel(existingModel);
//       descriptionSection.titleController.text = existingModel.model?.name ?? '';
//       descriptionSection.descriptionController.text =
//           existingModel.model?.description ?? '';
//     } else {
//       WorkflowLogicalModel newModel = WorkflowLogicalModel(
//         model: WorkflowDatabaseModel(
//           name: descriptionSection.titleController.text,
//           description: descriptionSection.descriptionController.text,
//         ),
//         steps: [],
//       );
//       controller.setModel(newModel);
//     }
//   }

//   void _setSectionValuesForFinance() {
//     if (widget.entityIndex != null) {
//       FinanceLogicalModel existingModel = FinanceController
//           .instance.stream.value
//           .getOne(id: widget.entityIndex)!;
//       controller.setModel(existingModel);
//       descriptionSection.titleController.text = existingModel.model?.name ?? '';
//       descriptionSection.descriptionController.text =
//           existingModel.model?.description ?? '';
//     } else {
//       FinanceLogicalModel newModel = FinanceLogicalModel(
//         model: FinanceDatabaseModel(
//           name: descriptionSection.titleController.text,
//           description: descriptionSection.descriptionController.text,
//           status: 0,
//         ),
//         operations: [],
//       );
//       controller.setModel(newModel);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _buildDialog();
//   }

//   _buildDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               backgroundColor: Colors.transparent,
//               child: Container(
//                 width: AppResponsive.instance.getWidth(300),
//                 padding: EdgeInsets.symmetric(
//                   vertical: AppResponsive.instance.getHeight(24),
//                   horizontal: AppResponsive.instance.getWidth(24),
//                 ),
//                 decoration: BoxDecoration(
//                   color: AppColor.colorFloating,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Wrap(
//                   children: [
//                     Form(
//                       key: formKey,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   _buildFields() {
//     switch (widget.type) {}
//   }
// }
