import 'dart:convert';
import 'dart:io';
import 'package:asset_flutter/auth/pages/login_page.dart';
import 'package:asset_flutter/auth/widgets/auth_currency_dropdown.dart';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/check_dialog.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/password_textformfield.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/content/widgets/settings/offers_sheet.dart';
import 'package:asset_flutter/content/models/responses/user.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/purchase_api.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/shared_pref.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:http/http.dart' as http;
import 'package:asset_flutter/utils/extensions.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

// ignore_for_file: avoid_init_to_null
class _SettingsPageState extends State<SettingsPage> {  
  DetailState _state = DetailState.init;
  final bool isApple = Platform.isIOS || Platform.isMacOS;
  UserInfo? _userInfo = null;
  String? error = null;

  void _changeCurrency(String currency) {
    setState(() {
      _state = DetailState.loading;
    });
    try {
      http.put(
        Uri.parse(APIRoutes().userRoutes.changeCurrency),
        body: json.encode({
          "currency": currency
        }),
        headers: UserToken().getBearerToken()
      ).then((response){
        _userInfo!.currency = currency;
        setState(() {
          _state = DetailState.view;
        });
        showDialog(
          context: context, 
          builder: (ctx) => response.getBaseResponse().error == null 
            ? const SuccessView("changed currency", shouldJustPop: true)
            : ErrorDialog(response.getBaseResponse().error!)
        );
      });
    } catch(error) {
      setState(() {
        _state = DetailState.view;
      });
      showDialog(
        context: context, 
        builder: (ctx) => ErrorDialog(error.toString())
      );
    }
  }

  void _changePassword(String oldPassword, String newPassword) {
    setState(() {
      _state = DetailState.loading;
    });
    try {
      http.put(
        Uri.parse(APIRoutes().userRoutes.changePassword),
        body: json.encode({
          "old_password": oldPassword,
          "new_password": newPassword
        }),
        headers: UserToken().getBearerToken()
      ).then((response){
        setState(() {
          _state = DetailState.view;
        });
        if (response.getBaseResponse().error == null) {
          SharedPref().deleteLoginCredentials();
        }
        showDialog(
          context: context, 
          builder: (ctx) => response.getBaseResponse().error == null 
            ? const SuccessView("changed password", shouldJustPop: true)
            : ErrorDialog(response.getBaseResponse().error!)
        );
      });
    } catch(error) {
      setState(() {
        _state = DetailState.view;
      });
      showDialog(
        context: context, 
        builder: (ctx) => ErrorDialog(error.toString())
      );
    }
  }

  void _logOut() {
    setState(() {
      _state = DetailState.loading;
    });
    try {
      http.post(
        Uri.parse(APIRoutes().authRoutes.logout),
        headers: UserToken().getBearerToken()
      ).then((response){
        if (response.getBaseResponse().error != null) {
          setState(() {
            _state = DetailState.view;
          });
          showDialog(
            context: context, 
            builder: (ctx) => ErrorDialog(response.getBaseResponse().error!)
          );
        } else {
          Purchases.logOut();
          SharedPref().deleteLoginCredentials();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginPage()));
        }
      });
    } catch (error) {
      setState(() {
        _state = DetailState.view;
      });
      showDialog(
        context: context, 
        builder: (ctx) => ErrorDialog(error.toString())
      );
    }
  }

  void _deleteUserAccount() {
    setState(() {
      _state = DetailState.loading;
    });
    try {
      http.delete(
        Uri.parse(APIRoutes().userRoutes.deleteUser),
        headers: UserToken().getBearerToken()
      ).then((response){
        if (response.getBaseResponse().error != null) {
          setState(() {
            _state = DetailState.view;
          });
          showDialog(
            context: context, 
            builder: (ctx) => ErrorDialog(response.getBaseResponse().error!)
          );
        } else {
          SharedPref().deleteLoginCredentials();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginPage()));
        }
      });
    } catch (error) {
      setState(() {
        _state = DetailState.view;
      });
      showDialog(
        context: context, 
        builder: (ctx) => ErrorDialog(error.toString())
      );
    }
  }

  void _getUserInfo() {
    setState(() {
      _state = DetailState.loading;
    });

    try {
      http.get(
        Uri.parse(APIRoutes().userRoutes.info),
        headers: UserToken().getBearerToken()
      ).then((response){
        if (_state != DetailState.disposed) {
          _userInfo = response.getBaseItemResponse<UserInfo>().data;
          error = _userInfo == null ? response.getBaseItemResponse<UserInfo>().message : null;
          if (_userInfo != null) {
            PurchaseApi().userInfo = _userInfo;
          }

          setState(() {
            _state = _userInfo == null ? DetailState.error : DetailState.view;
          }); 
        }
      }).onError((error, stackTrace) {
        this.error = error.toString();
        setState(() {
          _state = DetailState.error;
        });
      });
    } catch(error) {
      this.error = error.toString();
      setState(() {
        _state = DetailState.error;
      });
    }
  }

  @override
  void dispose() {
    _state = DetailState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == DetailState.init) {
      _getUserInfo();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  Widget _body() {
    switch (_state) {
      case DetailState.error:
        return ErrorView(error ?? "Error occured.", _getUserInfo);
      case DetailState.view:
        return SettingsList(
          sections: [
            SettingsSection(
              tiles: [
                CustomSettingsTile(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _userInfoText("Email", _userInfo!.email),
                      _userInfoText("Membership", _userInfo!.isPremium ? "Premium" : "Free"),
                      _userInfoText("Currency", _userInfo!.currency),
                      _userInfoText("Investment Usage", _userInfo!.investingLimit),
                      _userInfoText("Subscription Usage", _userInfo!.subscriptionLimit),
                      if(!_userInfo!.isPremium)
                      TextButton(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12)
                            ),
                          ),
                          enableDrag: true,
                          builder: (_) => const OffersSheet()
                        ), 
                        child: const Text('See Membership Plans'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50)
                        )
                      ),
                      const Divider()
                    ],
                  ),
                ),
              ]
            ),
            SettingsSection(
              title: const Text('Account'),
              tiles: [
                SettingsTile.navigation(
                  leading: const Icon(Icons.monetization_on_rounded),
                  title: const Text('Change currency'),
                  onPressed: (ctx) {
                    showDialog(
                      context: context, 
                      builder: (ctx) => AreYouSureDialog("change currency", (){
                        Navigator.pop(ctx);
                        final RegisterCurrencyDropdown _currencyDropdown = RegisterCurrencyDropdown(currency: _userInfo!.currency); 
                        showModalBottomSheet(
                          context: context, 
                          isScrollControlled: true,
                          builder: (ctx) => Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: SizedBox(
                              height: 175,
                              child: Column(
                                children: [
                                  _currencyDropdown,
                                  const SizedBox(height: 24),
                                  isApple
                                  ? CupertinoButton.filled(
                                    padding: const EdgeInsets.all(12),
                                    onPressed: (){
                                      Navigator.pop(context);
                                      _changeCurrency(_currencyDropdown.currency);
                                    }, 
                                    child: const Text('Save', style: TextStyle(fontSize: 16))
                                  )
                                  : ElevatedButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                      _changeCurrency(_currencyDropdown.currency);
                                    }, 
                                    child: const Text('Save', style: TextStyle(fontSize: 16))
                                  )
                                ],
                              ),
                            ),
                          )
                        );
                      })
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.lock_rounded),
                  title: const Text('Change password'),
                  onPressed: (ctx) {
                    showDialog(
                      context: context, 
                      builder: (ctx) => AreYouSureDialog("change password", (){
                        Navigator.pop(ctx);
                        final _form = GlobalKey<FormState>();
                        late String oldPassword;
                        late String newPassword;

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) => Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: SizedBox(
                              height: 300,
                              child: Form(
                                key: _form,
                                child: Column(
                                  children: [
                                    PasswordTextFormField(
                                      label: "Old Password",
                                      prefixIcon: Icon(Icons.password, color: AppColors().primaryColor),
                                      onSaved: (value) {
                                        if (value != null) {
                                          oldPassword = value;
                                        }
                                      },
                                      validator: (value) {
                                        if (value != null) {
                                          if (value.isEmpty) {
                                            return "Please don't leave this empty.";
                                          }
                                        }

                                        return null;
                                      },
                                    ),
                                    PasswordTextFormField(
                                      label: "New Password",
                                      prefixIcon: Icon(Icons.password, color: AppColors().primaryColor),
                                      onSaved: (value) {
                                        if (value != null) {
                                          newPassword = value;
                                        }
                                      },
                                      validator: (value) {
                                        if (value != null) {
                                          if (value.isEmpty) {
                                            return "Please don't leave this empty.";
                                          }
                                        }

                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    isApple
                                    ? CupertinoButton.filled(
                                      padding: const EdgeInsets.all(12),
                                      onPressed: (){
                                        final isValid = _form.currentState?.validate();
                                        if (isValid != null && !isValid) {
                                          return;
                                        }
                                        _form.currentState?.save();

                                        Navigator.pop(context);
                                        _changePassword(oldPassword, newPassword);
                                      }, 
                                      child: const Text('Change Password', style: TextStyle(fontSize: 16))
                                    )
                                    : ElevatedButton(
                                      onPressed: (){
                                        final isValid = _form.currentState?.validate();
                                        if (isValid != null && !isValid) {
                                          return;
                                        }
                                        _form.currentState?.save();

                                        Navigator.pop(context);
                                        _changePassword(oldPassword, newPassword);
                                      }, 
                                      child: const Text('Change Password', style: TextStyle(fontSize: 16))
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        );
                      })
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.logout_rounded),
                  title: const Text('Sign out'),
                  onPressed: (ctx) {
                    isApple
                    ? showCupertinoDialog(
                      context: context, 
                      builder: (ctx) => AreYouSureDialog("sign out", (){
                        Navigator.pop(ctx);
                        _logOut();
                      })
                    )
                    : showDialog(
                      context: context, 
                      builder: (ctx) => AreYouSureDialog("sign out", (){
                        Navigator.pop(ctx);
                        _logOut();
                      })
                    );
                  },
                ),
              ],
            ),
            SettingsSection(
              tiles: [
                CustomSettingsTile(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: isApple
                        ? CupertinoButton(
                          child: const Text('Delete Account', style: TextStyle(color: Color(0xFF777777))),
                          onPressed: (){
                            showCupertinoDialog(
                            context: context, 
                            builder: (ctx) => AreYouSureDialog("delete account", (){
                              Navigator.pop(ctx);
                              _deleteUserAccount();
                            })
                          );
                          },
                        )
                        : TextButton(
                          child: const Text('Delete Account', style: TextStyle(color: Color(0xFF777777))),
                          onPressed: (){
                            showDialog(
                            context: context, 
                            builder: (ctx) => AreYouSureDialog("delete account", (){
                              Navigator.pop(ctx);
                              _deleteUserAccount();
                            })
                          );
                          },
                        ),
                      ),
                    ],
                  ), 
                )
              ],
            )
          ],
        );
      default:
        return const LoadingView("Please wait");
    }
  }

  Widget _userInfoText(String title, String data) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            data,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    ),
  );
}
