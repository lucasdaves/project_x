class DatabaseConsts {
  static final DatabaseConsts instance = DatabaseConsts._();
  DatabaseConsts._();

  //* DATABASE *//

  final String databaseName = "project_x.db";
  final int databaseVersion = 1;

  //* TABLE TAG *//

  final String user = "tb_user";
  final String system = "tb_system";
  final String recover = "tb_recover";
  final String client = "tb_client";
  final String workflow = "tb_workflow";
  final String step = "tb_step";
  final String substep = "tb_substep";
  final String project = "tb_project";
  final String finance = "tb_finance";
  final String finance_operation = "tb_finance_operation";
  final String personal = "tb_personal";
  final String address = "tb_address";
  final String profession = "tb_profession";
  final String file = "tb_file";
}
