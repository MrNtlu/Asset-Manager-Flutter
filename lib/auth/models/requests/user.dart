class Login {
  String emailAddress;
  String password;

  Login(this.emailAddress, this.password);
}

class Register {
  String emailAddress;
  String currency;
  String password;

  Register(this.emailAddress, this.currency, this.password);
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
