class Login {
  final String emailAddress;
  final String password;

  const Login(this.emailAddress, this.password);
}

class Register {
  final String emailAddress;
  final String currency;
  final String password;

  const Register(this.emailAddress, this.currency, this.password);
}

class ChangePassword {
  final String oldPassword;
  final String newPassword;

  const ChangePassword(this.oldPassword, this.newPassword);
}

class ChangeCurrency {
  final String currency;

  const ChangeCurrency(this.currency);
}

class ForgotPassword {
  final String emailAddress;

  const ForgotPassword(this.emailAddress);
}
