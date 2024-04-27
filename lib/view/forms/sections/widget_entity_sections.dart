//* SECTIONS *//

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class UserSection {
  // LABELS
  String loginLabel = "Login";
  String passwordLabel = "Senha";
  String recoverLabel = "Pergunta de Recuperação";
  String recoverRespLabel = "Resposta de Recuperação";

  // HINT TEXTS
  String loginHint = "Digite seu login ...";
  String passwordHint = "Digite sua senha ...";
  String recoverHint = "Digite sua pergunta ...";
  String recoverRespHint = "Digite a resposta ...";

  // TEXT CONTROLLERS
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController recoverController = TextEditingController();
  TextEditingController recoverRespController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validateLogin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o login';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a senha';
    }
    return null;
  }

  String? validateRecover(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, escolha a pergunta';
    }
    return null;
  }

  String? validateRecoverResp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a resposta';
    }
    return null;
  }
}

class PersonalDataSection {
  // LABELS
  String nameLabel = "Nome Completo";
  String documentLabel = "Documento";
  String dobLabel = "Data de Nascimento";
  String genderLabel = "Gênero";

  // HINT TEXTS
  String nameHint = "Digite seu nome completo ...";
  String documentHint = "Digite seu cpf ...";
  String dobHint = "Digite sua data de nascimento ...";
  String genderHint = "Digite seu gênero ...";

  // TEXT CONTROLLERS
  TextEditingController nameController = TextEditingController();
  MaskedTextController documentController = MaskedTextController(
    mask: '000.000.000-00',
  );
  MaskedTextController dobController = MaskedTextController(
    mask: '00/00/0000',
  );
  TextEditingController genderController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o nome';
    }
    return null;
  }

  String? validateDocument(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o documento';
    }
    return null;
  }

  String? validateDob(String? value) {
    return null;
  }

  String? validateGender(String? value) {
    return null;
  }
}

class AddressSection {
  // LABELS
  String countryLabel = "País";
  String cepLabel = "CEP";
  String stateLabel = "Estado";
  String cityLabel = "Cidade";
  String streetLabel = "Rua";
  String numberLabel = "Número";
  String complementLabel = "Complemento";

  // HINT TEXTS
  String countryHint = "Digite o país ...";
  String cepHint = "00000-000 ...";
  String stateHint = "Digite o estado ...";
  String cityHint = "Digite a cidade ...";
  String streetHint = "Digite a rua ...";
  String numberHint = "Digite o número ...";
  String complementHint = "Digite o complemento ...";

  // TEXT CONTROLLERS
  TextEditingController countryController = TextEditingController();
  MaskedTextController cepController = MaskedTextController(
    mask: '00000-000',
  );
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController complementController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validateCountry(String? value) {
    return null;
  }

  String? validateCep(String? value) {
    return null;
  }

  String? validateState(String? value) {
    return null;
  }

  String? validateCity(String? value) {
    return null;
  }

  String? validateStreet(String? value) {
    return null;
  }

  String? validateNumber(String? value) {
    return null;
  }

  String? validateComplement(String? value) {
    return null;
  }
}

class ContactSection {
  // LABELS
  final String phoneLabel = "Telefone";
  final String emailLabel = "E-mail";
  final String noteLabel = "Anotação";

  // HINT TEXTS
  final String phoneHint = "Digite seu telefone...";
  final String emailHint = "Digite seu e-mail...";
  final String noteHint = "Digite uma anotação...";

  // TEXT CONTROLLERS
  MaskedTextController phoneController = MaskedTextController(
    mask: '(00) 0 0000-0000',
  );
  TextEditingController emailController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validatePhone(String? value) {
    return null;
  }

  String? validateEmail(String? value) {
    return null;
  }

  String? validateNote(String? value) {
    return null;
  }
}

class ProjectSection {
  // LABELS
  final String titleLabel = "Titulo";
  final String descriptionLabel = "Descrição";
  final String workflowLabel = "Workflow";

  // HINT TEXTS
  final String titleHint = "Digite o titulo...";
  final String descriptionHint = "Digite a descrição...";
  final String workflowHint = "Selecione a workflow ...";

  // TEXT CONTROLLERS
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController workflowController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o titulo';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a descrição';
    }
    return null;
  }

  String? validateWorkflow(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, selecione uma opção';
    }
    return null;
  }
}

class WorkflowOperationSection {
  // LABELS
  final String titleLabel = "Titulo";
  final String descriptionLabel = "Descrição";
  final String statusLabel = "Situação da entrega";
  final String dateLabel = "Data de entrega";

  // HINT TEXTS
  final String titleHint = "Digite o titulo...";
  final String descriptionHint = "Digite a descrição...";
  final String statusHint = "Escolha uma situação";
  final String dateHint = "Digite a data de entrega ...";

  // TEXT CONTROLLERS
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  MaskedTextController dateController = MaskedTextController(
    mask: '00/00/0000',
  );
  TextEditingController statusController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o titulo';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a descrição';
    }
    return null;
  }

  String? validateDate(String? value) {
    return null;
  }

  String? validateStatus(String? value) {
    return null;
  }
}

class DescriptionSection {
  // LABELS
  final String titleLabel = "Titulo";
  final String descriptionLabel = "Descrição";

  // HINT TEXTS
  final String titleHint = "Digite o titulo...";
  final String descriptionHint = "Digite a descrição...";

  // TEXT CONTROLLERS
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o titulo';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a descrição';
    }
    return null;
  }
}

class OperationSection {
  // LABELS
  final String amountLabel = "Quantia";
  final String descriptionLabel = "Descrição";
  final String dateLabel = "Data de pagamento";
  final String statusLabel = "Situação";

  // HINT TEXTS
  final String amountHint = "Digite a quantia...";
  final String descriptionHint = "Digite a descrição...";
  final String dateHint = "Digite a data de pagamento ...";
  final String statusHint = "Escolha uma situação ...";

  // TEXT CONTROLLERS
  MoneyMaskedTextController amountController = MoneyMaskedTextController(
    decimalSeparator: '.',
    thousandSeparator: '',
    leftSymbol: '',
    precision: 2,
  );
  TextEditingController descriptionController = TextEditingController();
  MaskedTextController dateController = MaskedTextController(
    mask: '00/00/0000',
  );
  TextEditingController statusController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a quantia';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a descrição';
    }
    return null;
  }

  String? validateDate(String? value) {
    return null;
  }

  String? validateStatus(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a descrição';
    }
    return null;
  }
}

class SystemSection {
  // LABELS
  final String financeDateLabel = "Financeiros - Aviso de atraso";
  final String workflowDateLabel = "Workflows - Aviso de atraso";

  // HINT TEXTS
  final String financeDateHint = "Digite a quantidade de dias ...";
  final String workflowDateHint = "Digite a quantidade de dias ...";

  // TEXT CONTROLLERS
  MaskedTextController fianceDateController = MaskedTextController(
    mask: '000',
  );
  MaskedTextController workflowDateController = MaskedTextController(
    mask: '000',
  );

  // VALIDATION FUNCTIONS
  String? validateFinanceDate(String? value) {
    return null;
  }

  String? validateWorkflowDate(String? value) {
    return null;
  }
}

class AssociationSection {
  // LABELS
  final String clientLabel = "Cliente associado";
  final String projectLabel = "Projeto associado";
  final String financeLabel = "Financeiro associado";

  // HINT TEXTS
  final String clientHint = "Escolha um cliente ...";
  final String projectHint = "Escolha um projeto ...";
  final String financeHint = "Escolha uma finança ...";

  // TEXT CONTROLLERS
  TextEditingController clientController = TextEditingController();
  TextEditingController projectController = TextEditingController();
  TextEditingController financeController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validateClient(String? value) {
    return null;
  }

  String? validateProject(String? value) {
    return null;
  }

  String? validateFinance(String? value) {
    return null;
  }
}
