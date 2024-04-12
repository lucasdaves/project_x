//* SECTIONS *//

import 'package:flutter/material.dart';

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
  String documentHint = "Digite seu documento ...";
  String dobHint = "Digite sua data de nascimento ...";
  String genderHint = "Digite seu gênero ...";

  // TEXT CONTROLLERS
  TextEditingController nameController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController dobController = TextEditingController();
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
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o nascimento';
    }
    return null;
  }

  String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o gênero';
    }
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
  String complementLabel = "Complemento (Opcional)";
  String referenceLabel = "Referência (Opcional)";

  // HINT TEXTS
  String countryHint = "Digite o país ...";
  String cepHint = "Digite o CEP ...";
  String stateHint = "Digite o estado ...";
  String cityHint = "Digite a cidade ...";
  String streetHint = "Digite a rua ...";
  String numberHint = "Digite o número ...";
  String complementHint = "Digite o complemento ...";
  String referenceHint = "Digite a referência ...";

  // TEXT CONTROLLERS
  TextEditingController countryController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController complementController = TextEditingController();
  TextEditingController referenceController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validateCountry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o país';
    }
    return null;
  }

  String? validateCep(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o CEP';
    }
    return null;
  }

  String? validateState(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o estado';
    }
    return null;
  }

  String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a cidade';
    }
    return null;
  }

  String? validateStreet(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a rua';
    }
    return null;
  }

  String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o número';
    }
    return null;
  }

  String? validateComplement(String? value) {
    return null;
  }

  String? validateReference(String? value) {
    return null;
  }
}

class ContactSection {
  // LABELS
  final String phoneLabel = "Telefone";
  final String emailLabel = "E-mail";
  final String noteLabel = "Anotação (Opcional)";

  // HINT TEXTS
  final String phoneHint = "Digite seu telefone...";
  final String emailHint = "Digite seu e-mail...";
  final String noteHint = "Digite uma anotação...";

  // TEXT CONTROLLERS
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o telefone';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o e-mail';
    }
    return null;
  }

  String? validateNote(String? value) {
    return null;
  }
}

class DescriptionSection {
  // LABELS
  final String titleLabel = "Titulo";
  final String descriptionLabel = "Descrição";
  final String mandatoryLabel = "Obrigatório ?";

  // HINT TEXTS
  final String titleHint = "Digite o titulo...";
  final String descriptionHint = "Digite a descrição...";
  final String mandatoryHint = "Selecione ...";

  // TEXT CONTROLLERS
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController mandatoryController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o titulo';
    }
    return null;
  }

  String? validateDescription(String? value) {
    return null;
  }

  String? validateMandatory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, selecione uma opção';
    }
    return null;
  }
}

class OperationSection {
  // LABELS
  final String amountLabel = "Quantia";
  final String descriptionLabel = "Descrição";

  // HINT TEXTS
  final String amountHint = "Digite a quantia...";
  final String descriptionHint = "Digite a descrição...";

  // TEXT CONTROLLERS
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a quantia';
    }
    return null;
  }

  String? validateDescription(String? value) {
    return null;
  }
}

class WorkflowSection {
  List<DescriptionSection> steps = [];
  Map<String, List<DescriptionSection>> substeps = {};
}
