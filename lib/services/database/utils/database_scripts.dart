class DatabaseScripts {
  static final instance = DatabaseScripts._();
  DatabaseScripts._();

  //* CORE SCRIPTS *//

  String createTablesScript() {
    String script = """
      CREATE TABLE tb_address (
          atr_id integer NOT NULL CONSTRAINT tb_address_pk PRIMARY KEY,
          atr_country text NOT NULL,
          atr_state text NOT NULL,
          atr_city text NOT NULL,
          atr_postal_code text NOT NULL,
          atr_street text NOT NULL,
          atr_number text NOT NULL,
          atr_complement text,
          atr_created_at datetime,
          atr_updated_at datetime
      );

      CREATE TABLE tb_client (
          atr_id integer NOT NULL CONSTRAINT tb_client_pk PRIMARY KEY,
          tb_personal_atr_id integer,
          tb_user_atr_id integer,
          atr_created_at datetime,
          atr_updated_at datetime
      );

      CREATE TABLE tb_file (
          atr_id integer NOT NULL CONSTRAINT tb_file_pk PRIMARY KEY,
          atr_path text NOT NULL,
          atr_extension text NOT NULL,
          tb_user_atr_id integer,
          tb_project_atr_id integer,
          tb_finance_atr_id integer,
          tb_client_atr_id integer,
          atr_created_at datetime,
          atr_updated_at datetime
      );

      CREATE TABLE tb_finance (
          atr_id integer NOT NULL CONSTRAINT tb_finance_pk PRIMARY KEY,
          atr_name text NOT NULL,
          atr_description text,
          tb_user_atr_id integer,
          tb_client_atr_id integer,
          atr_created_at datetime,
          atr_updated_at datetime
      );

      CREATE TABLE tb_finance_operation (
          atr_id integer NOT NULL CONSTRAINT tb_finance_operation_pk PRIMARY KEY,
          atr_type smallint NOT NULL,
          atr_description text NOT NULL,
          atr_amount text NOT NULL,
          atr_paid_at datetime,
          atr_expires_at datetime,
          tb_finance_atr_id integer,
          atr_created_at datetime,
          atr_updated_at datetime
      );

      CREATE TABLE tb_personal (
          atr_id integer NOT NULL CONSTRAINT tb_personal_pk PRIMARY KEY,
          atr_name text NOT NULL,
          atr_document text NOT NULL,
          atr_email text,
          atr_phone text,
          atr_gender smallint,
          atr_birth date,
          atr_annotation text,
          tb_address_atr_id integer,
          atr_created_at datetime,
          atr_updated_at datetime
      );

      CREATE TABLE tb_profession (
          atr_id integer NOT NULL CONSTRAINT tb_profession_pk PRIMARY KEY,
          atr_name text NOT NULL,
          atr_document text NOT NULL,
          tb_personal_atr_id integer,
          atr_created_at datetime,
          atr_updated_at datetime
      );

      CREATE TABLE tb_project (
          atr_id integer NOT NULL CONSTRAINT tb_project_pk PRIMARY KEY,
          atr_name text NOT NULL,
          atr_description text,
          tb_user_atr_id integer,
          tb_address_atr_id integer,
          tb_client_atr_id integer,
          tb_finance_atr_id integer,
          tb_workflow_atr_id integer,
          atr_created_at datetime,
          atr_updated_at datetime
      );

      CREATE TABLE tb_recover (
          atr_id integer NOT NULL CONSTRAINT tb_recover_pk PRIMARY KEY,
          atr_question text,
          atr_response text,
          atr_code text,
          tb_user_atr_id integer,
          atr_created_at datetime,
          atr_updated_at datetime
      );

      CREATE TABLE tb_step (
          atr_id integer NOT NULL CONSTRAINT tb_step_pk PRIMARY KEY,
          atr_name text NOT NULL,
          atr_description text,
          tb_workflow_atr_id integer,
          atr_created_at datetime,
          atr_updated_at datetime
      );

      CREATE TABLE tb_substep (
          atr_id integer NOT NULL CONSTRAINT tb_substep_pk PRIMARY KEY,
          atr_name text NOT NULL,
          atr_description text,
          atr_mandatory boolean NOT NULL,
          tb_step_atr_id integer,
          atr_created_at datetime,
          atr_updated_at datetime
      );

      CREATE TABLE tb_system (
          atr_id integer NOT NULL CONSTRAINT tb_system_pk PRIMARY KEY,
          atr_language smallint NOT NULL,
          atr_reminder_date datetime NOT NULL,
          tb_user_atr_id integer,
          atr_created_at datetime,
          atr_updated_at datetime
      );

      CREATE TABLE tb_user (
          atr_id integer NOT NULL CONSTRAINT tb_user_pk PRIMARY KEY,
          atr_type smallint NOT NULL,
          atr_login text NOT NULL,
          atr_password text NOT NULL,
          tb_personal_atr_id integer,
          atr_created_at datetime,
          atr_updated_at datetime
      );

      CREATE TABLE tb_workflow (
          atr_id integer NOT NULL CONSTRAINT tb_workflow_pk PRIMARY KEY,
          atr_name text NOT NULL,
          atr_description text,
          tb_user_atr_id integer,
          tb_workflow_atr_id integer,
          atr_created_at datetime,
          atr_updated_at datetime
      );
      """;

    return script;
  }
}
