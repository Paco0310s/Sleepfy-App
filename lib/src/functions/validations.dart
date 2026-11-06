class Validations {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El correo electrónico no puede estar vacío';
    }
    if (!EmailValidator.validate(value.trim())) {
      return 'Correo electrónico no válido';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña no puede estar vacía';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    if (value.length > 64) {
      return 'La contraseña no puede exceder 64 caracteres';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre no puede estar vacío';
    }
    if (value.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El apellido no puede estar vacío';
    }
    if (value.trim().length < 2) {
      return 'El apellido debe tener al menos 2 caracteres';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono no puede estar vacío';
    }
    if (!PhoneValidator.validate(value)) {
      return 'El teléfono debe tener 10 dígitos';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String text) {
    if (value == null || value.isEmpty) {
      return 'La confirmación de la contraseña no puede estar vacía';
    }
    if (value != text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }
}

class EmailValidator {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9_.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  static bool validate(String email) {
    return _emailRegExp.hasMatch(email);
  }
}

class PhoneValidator {
  static final RegExp _phoneRegExp = RegExp(
    r'^[0-9]{10}$',
  );

  static bool validate(String phone) {
    return _phoneRegExp.hasMatch(phone);
  }
}

class NameValidator {
  static final RegExp _nameRegExp = RegExp(
    r'^[a-zA-Z]{3,}$',
  );

  static bool validate(String name) {
    return _nameRegExp.hasMatch(name);
  }
}
