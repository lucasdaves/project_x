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
          atr_created_at datetime,
          atr_updated_at datetime,
          tb_user_atr_id integer NOT NULL,
          CONSTRAINT tb_client_tb_personal FOREIGN KEY (tb_personal_atr_id)
          REFERENCES tb_personal (atr_id)
          ON DELETE CASCADE 
          ON UPDATE CASCADE,
          CONSTRAINT tb_client_tb_user FOREIGN KEY (tb_user_atr_id)
          REFERENCES tb_user (atr_id)
          ON DELETE CASCADE 
          ON UPDATE CASCADE
      );

      CREATE TABLE tb_finance (
          atr_id integer NOT NULL CONSTRAINT tb_finance_pk PRIMARY KEY,
          atr_name text NOT NULL,
          atr_description text NOT NULL,
          atr_status integer NOT NULL,
          atr_created_at datetime,
          atr_updated_at datetime,
          tb_user_atr_id integer NOT NULL,
          tb_client_atr_id integer,
          CONSTRAINT tb_finance_tb_user FOREIGN KEY (tb_user_atr_id)
          REFERENCES tb_user (atr_id)
          ON DELETE CASCADE 
          ON UPDATE CASCADE,
          CONSTRAINT tb_finance_tb_client FOREIGN KEY (tb_client_atr_id)
          REFERENCES tb_client (atr_id)
          ON DELETE SET NULL 
          ON UPDATE CASCADE
      );

      CREATE TABLE tb_finance_operation (
          atr_id integer NOT NULL CONSTRAINT tb_finance_operation_pk PRIMARY KEY,
          atr_type smallint NOT NULL,
          atr_description text NOT NULL,
          atr_status integer NOT NULL,
          atr_amount text NOT NULL,
          atr_expires_at datetime,
          atr_created_at datetime,
          atr_updated_at datetime,
          tb_finance_atr_id integer NOT NULL,
          CONSTRAINT tb_finance_operation_tb_finance FOREIGN KEY (tb_finance_atr_id)
          REFERENCES tb_finance (atr_id)
          ON DELETE CASCADE 
          ON UPDATE CASCADE
      );

      CREATE TABLE tb_personal (
          atr_id integer NOT NULL CONSTRAINT tb_personal_pk PRIMARY KEY,
          atr_name text NOT NULL,
          atr_document text NOT NULL,
          atr_email text,
          atr_phone text,
          atr_gender text,
          atr_birth date,
          atr_annotation text,
          atr_profession text,
          atr_created_at datetime,
          atr_updated_at datetime,
          tb_address_atr_id integer,
          CONSTRAINT tb_personal_tb_address FOREIGN KEY (tb_address_atr_id)
          REFERENCES tb_address (atr_id)
          ON DELETE SET NULL 
          ON UPDATE CASCADE
      );

      CREATE TABLE tb_project (
          atr_id integer NOT NULL CONSTRAINT tb_project_pk PRIMARY KEY,
          atr_name text NOT NULL,
          atr_description text,
          atr_created_at datetime,
          atr_updated_at datetime,
          tb_user_atr_id integer NOT NULL,
          tb_address_atr_id integer,
          tb_workflow_atr_id integer,
          tb_client_atr_id integer,
          tb_finance_atr_id integer,
          CONSTRAINT tb_project_tb_address FOREIGN KEY (tb_address_atr_id)
          REFERENCES tb_address (atr_id)
          ON DELETE SET NULL 
          ON UPDATE CASCADE,
          CONSTRAINT tb_project_tb_workflow FOREIGN KEY (tb_workflow_atr_id)
          REFERENCES tb_workflow (atr_id)
          ON DELETE RESTRICT 
          ON UPDATE CASCADE,
          CONSTRAINT tb_project_tb_user FOREIGN KEY (tb_user_atr_id)
          REFERENCES tb_user (atr_id)
          ON DELETE CASCADE 
          ON UPDATE CASCADE,
          CONSTRAINT tb_project_tb_client FOREIGN KEY (tb_client_atr_id)
          REFERENCES tb_client (atr_id)
          ON DELETE SET NULL 
          ON UPDATE CASCADE,
          CONSTRAINT tb_project_tb_finance FOREIGN KEY (tb_finance_atr_id)
          REFERENCES tb_finance (atr_id)
          ON DELETE SET NULL 
          ON UPDATE CASCADE
      );

      CREATE TABLE tb_recover (
          atr_id integer NOT NULL CONSTRAINT tb_recover_pk PRIMARY KEY,
          atr_question text,
          atr_response text,
          atr_code text NOT NULL,
          atr_created_at datetime,
          atr_updated_at datetime
      );

      CREATE TABLE tb_step (
          atr_id integer NOT NULL CONSTRAINT tb_step_pk PRIMARY KEY,
          atr_name text NOT NULL,
          atr_description text,
          atr_created_at datetime,
          atr_updated_at datetime,
          tb_workflow_atr_id integer NOT NULL,
          CONSTRAINT tb_step_tb_workflow FOREIGN KEY (tb_workflow_atr_id)
          REFERENCES tb_workflow (atr_id)
          ON DELETE CASCADE 
          ON UPDATE CASCADE
      );

      CREATE TABLE tb_substep (
          atr_id integer NOT NULL CONSTRAINT tb_substep_pk PRIMARY KEY,
          atr_name text NOT NULL,
          atr_description text,
          atr_status integer NOT NULL,
          atr_expires_at datetime,
          atr_concluded_at datetime,
          atr_created_at datetime,
          atr_updated_at datetime,
          tb_step_atr_id integer NOT NULL,
          CONSTRAINT tb_substep_tb_step FOREIGN KEY (tb_step_atr_id)
          REFERENCES tb_step (atr_id)
          ON DELETE CASCADE 
          ON UPDATE CASCADE
      );

      CREATE TABLE tb_system (
          atr_id integer NOT NULL CONSTRAINT tb_system_pk PRIMARY KEY,
          atr_language smallint,
          atr_finance_reminder_date text,
          atr_workflow_reminder_date text,
          atr_created_at datetime,
          atr_updated_at datetime,
          tb_user_atr_id integer,
          CONSTRAINT tb_system_tb_user FOREIGN KEY (tb_user_atr_id)
          REFERENCES tb_user (atr_id)
          ON DELETE CASCADE 
          ON UPDATE CASCADE
      );

      CREATE TABLE tb_user (
          atr_id integer NOT NULL CONSTRAINT tb_user_pk PRIMARY KEY,
          atr_type smallint NOT NULL,
          atr_login text NOT NULL,
          atr_password text NOT NULL,
          atr_created_at datetime,
          atr_updated_at datetime,
          tb_personal_atr_id integer,
          tb_recover_atr_id integer,
          CONSTRAINT tb_user_tb_personal FOREIGN KEY (tb_personal_atr_id)
          REFERENCES tb_personal (atr_id)
          CONSTRAINT tb_user_tb_recover FOREIGN KEY (tb_recover_atr_id)
          REFERENCES tb_recover (atr_id)
          ON DELETE CASCADE 
          ON UPDATE CASCADE
      );

      CREATE TABLE tb_workflow (
          atr_id integer NOT NULL CONSTRAINT tb_workflow_pk PRIMARY KEY,
          atr_name text NOT NULL,
          atr_description text NOT NULL,
          atr_copy boolean NOT NULL,
          atr_created_at datetime,
          atr_updated_at datetime,
          tb_user_atr_id integer NOT NULL,
          CONSTRAINT tb_workflow_tb_user FOREIGN KEY (tb_user_atr_id)
          REFERENCES tb_user (atr_id)
          ON DELETE CASCADE 
          ON UPDATE CASCADE
      );
    """;

    return script;
  }
}
