import 'dart:convert';
import 'dart:io';
import 'package:asset_flutter/auth/pages/login_page.dart';
import 'package:asset_flutter/auth/pages/policy_page.dart';
import 'package:asset_flutter/auth/widgets/auth_currency_dropdown.dart';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/base_button.dart';
import 'package:asset_flutter/common/widgets/check_dialog.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/password_textformfield.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/content/pages/settings/feedback_page.dart';
import 'package:asset_flutter/content/providers/settings/theme_state.dart';
import 'package:asset_flutter/content/widgets/portfolio/portfolio_color_sheet.dart';
import 'package:asset_flutter/content/widgets/portfolio/watchlist_color_sheet.dart';
import 'package:asset_flutter/content/widgets/settings/default_tab.dart';
import 'package:asset_flutter/content/widgets/settings/hide_watchlist_switch.dart';
import 'package:asset_flutter/content/widgets/settings/offers_sheet.dart';
import 'package:asset_flutter/content/models/responses/user.dart';
import 'package:asset_flutter/content/widgets/settings/theme_switch.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/google_signin_api.dart';
import 'package:asset_flutter/static/purchase_api.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/shared_pref.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:http/http.dart' as http;
import 'package:asset_flutter/utils/extensions.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage();
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

  void _changeNotificationPreference(bool isOn) {
    setState(() {
      _state = DetailState.loading;
    });
    try {
      http.put(
        Uri.parse(APIRoutes().userRoutes.changeNotification),
        body: json.encode({
          "app_notification": isOn,
          "mail_notification": false,
        }),
        headers: UserToken().getBearerToken()
      ).then((response){
        _userInfo!.appNotification = isOn;
        setState(() {
          _state = DetailState.view;
        });

        if (response.getBaseResponse().error != null) {  
          showDialog(
            context: context, 
            builder: (ctx) => ErrorDialog(response.getBaseResponse().error!)
          );
        }
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
      ).then((response) async {
        if (response.getBaseResponse().error != null) {
          setState(() {
            _state = DetailState.view;
          });
          showDialog(
            context: context, 
            builder: (ctx) => ErrorDialog(response.getBaseResponse().error!)
          );
        } else {
          try {
            await Purchases.logOut();
            SharedPref().deleteLoginCredentials();

            if (PurchaseApi().userInfo != null && PurchaseApi().userInfo!.isOAuth) {
              switch (PurchaseApi().userInfo!.oAuthType) {
                case 0:
                  await GoogleSignInApi().signOut();
                  break;
                case 1:
                  SharedPref().deleteOAuthLoginCredentials();
                  break;
                default:
                  SharedPref().deleteOAuthLoginCredentials();
                  await GoogleSignInApi().signOut();
              }
            } else if (PurchaseApi().userInfo == null) {
              SharedPref().deleteOAuthLoginCredentials();
              await GoogleSignInApi().signOut();
            }
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
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
          Purchases.logOut();
          GoogleSignInApi().signOut();
          SharedPref().deleteLoginCredentials();
          SharedPref().deleteOAuthLoginCredentials();
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
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      themeProvider.initTheme(SharedPref().isDarkTheme());
      _getUserInfo();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold)
        ),
        centerTitle: false,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    switch (_state) {
      case DetailState.error:
        return ErrorView(error ?? "Error occured.", _getUserInfo);
      case DetailState.view:
        return SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              title: const Text('Account Info'),
              tiles: [
                _userInfoText("Email", _userInfo!.email),
                _userInfoText("Membership", _userInfo!.isLifetimePremium ? "Lifetime Premium" : _userInfo!.isPremium ? "Premium" : "Free"),
                _userInfoText("Currency", _userInfo!.currency),
                _userInfoText("Investment Usage", _userInfo!.investingLimit),
                _userInfoText("Subscription Usage", _userInfo!.subscriptionLimit),
                _userInfoText("Watchlist Usage", _userInfo!.watchlistLimit),
                if(!_userInfo!.isPremium)
                SettingsTile(
                  title: const Text(
                    'See Membership Plans',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CupertinoColors.systemBlue,
                    ),
                  ),
                  onPressed: (_) => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    enableDrag: false,
                    backgroundColor: AppColors().bgSecondary,
                    builder: (_) => Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
                      child: const OffersSheet()
                    )
                  ),
                )
              ]
            ),
            SettingsSection(
              title: const Text('Account Settings'),
              tiles: [
                const CustomSettingsTile(child: SettingsThemeSwitch()),
                SettingsTile.switchTile(
                  onToggle: (value) => _changeNotificationPreference(value),
                  initialValue: _userInfo!.appNotification,
                  leading: Icon(
                    _userInfo!.appNotification 
                    ? Icons.notifications_active_rounded
                    : Icons.notifications_off_rounded
                  ),
                  title: const Text('In App Notification'),
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.monetization_on_rounded),
                  title: const Text('Change Currency'),
                  onPressed: (_) {
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

                                  showCupertinoDialog(
                                    context: context, 
                                    builder: (dialogContext) => AreYouSureDialog("change currency to ${_currencyDropdown.currency}", (){
                                      Navigator.pop(dialogContext);
                                      _changeCurrency(_currencyDropdown.currency);
                                    })
                                  );
                                }, 
                                child: const Text('Save', style: TextStyle(fontSize: 16, color: Colors.white))
                              )
                              : ElevatedButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context, 
                                    builder: (dialogContext) => AreYouSureDialog("change currency to ${_currencyDropdown.currency}", (){
                                      Navigator.pop(dialogContext);
                                      _changeCurrency(_currencyDropdown.currency);
                                    })
                                  );
                                }, 
                                child: const Text('Save', style: TextStyle(fontSize: 16, color: Colors.white))
                              )
                            ],
                          ),
                        ),
                      )
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.lock_rounded),
                  title: const Text('Change Password'),
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
                                          } else if (value.length < 6) {
                                            return "Password should be longer than 6.";
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
                                          } else if (value.length < 6) {
                                            return "Password should be longer than 6.";
                                          }
                                        }

                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    BaseButton(
                                      "Change Password",
                                      () {
                                        final isValid = _form.currentState?.validate();
                                        if (isValid != null && !isValid) {
                                          return;
                                        }
                                        _form.currentState?.save();

                                        Navigator.pop(context);
                                        _changePassword(oldPassword, newPassword);
                                      },
                                      containerMargin: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
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
                  title: const Text('Sign Out'),
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
              title: const Text('App Settings'),
              tiles: [
                const CustomSettingsTile(child: HideWatchlistSwitch()),
                SettingsTile.navigation(
                  leading: const Icon(Icons.invert_colors_on_rounded),
                  title: const Text('Portfolio Color'),
                  onPressed: (_) {
                    showModalBottomSheet(
                        context: context, 
                        isDismissible: true,
                        isScrollControlled: true,
                        enableDrag: true,
                        shape: Platform.isIOS || Platform.isMacOS
                        ? const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16)
                          ),
                        )
                        : null,
                        builder: (_) => const PortfolioColorSheet(),
                      );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.palette_rounded),
                  title: const Text('Watchlist Color'),
                  onPressed: (_) {
                    showModalBottomSheet(
                        context: context, 
                        isDismissible: true,
                        isScrollControlled: false,
                        enableDrag: true,
                        shape: Platform.isIOS || Platform.isMacOS
                        ? const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16)
                          ),
                        )
                        : null,
                        builder: (_) => const WatchlistColorSheet(),
                      );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.widgets_rounded),
                  title: const Text('Default Page'),
                  onPressed: (_) {
                    showModalBottomSheet(
                      context: context,
                      shape: Platform.isIOS || Platform.isMacOS
                      ? const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          topLeft: Radius.circular(16)
                        ),
                      )
                      : null,
                      builder: (ctx) => Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: const SafeArea(
                          child: SizedBox(
                            height: 275,
                            child: DefaultTabListSettings()
                          )
                        ),
                      )
                    );
                  },
                ),
              ],
            ),
            SettingsSection(
              title: const Text('Other Settings'),
              tiles: [
                SettingsTile.navigation(
                  leading: const Icon(Icons.stars_rounded),
                  title: const Text('Rate & Review Us'),
                  onPressed: (ctx) async {
                    final InAppReview inAppReview = InAppReview.instance;
                    try {
                      if (await inAppReview.isAvailable()) {
                          inAppReview.requestReview();
                      } else {
                        inAppReview.openStoreListing(appStoreId: '1629419797');
                      }
                    } catch (error) {
                      inAppReview.openStoreListing(appStoreId: '1629419797');
                    }
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.feedback_rounded),
                  title: const Text('Feedback/Suggestion'),
                  onPressed: (ctx) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FeedbackPage()));
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.copyright_rounded),
                  title: const Text('Licenses'),
                  onPressed: (ctx) async {
                    PackageInfo packageInfo = await PackageInfo.fromPlatform();

                    String appName = packageInfo.appName;
                    String version = packageInfo.version;
                    
                    showDialog(
                      context: context, 
                      builder: (_) => AboutDialog(
                        applicationIcon: Image.asset(
                          "assets/images/investment.png",
                          width: 45, 
                          height: 45,
                          fit: BoxFit.contain,
                        ),
                        applicationName: appName,
                        applicationVersion: "version $version",
                      )
                    );
                  },
                ),
              ]
            ),
            SettingsSection(
              tiles: [
                CustomSettingsTile(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isApple
                          ? CupertinoButton(
                            child: const Text('Terms & Conditions', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 12)),
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                return const PolicyPage(false);
                              })),
                          )
                          : TextButton(
                            child: const Text('Terms & Conditions', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 12)),
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                return const PolicyPage(false);
                              })),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: isApple
                            ? CupertinoButton(
                              child: const Text('Privacy Policy', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 12)),
                              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                return const PolicyPage(true);
                              })),
                            )
                            : TextButton(
                              child: const Text('Privacy Policy', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 12)),
                              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                return const PolicyPage(true);
                              })),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: isApple
                        ? CupertinoButton(
                          child: const Text('Delete Account', style: TextStyle(color: Color(0xFF777777), fontSize: 12)),
                          onPressed: (){
                            showCupertinoDialog(
                              context: context, 
                              builder: (ctx) => AreYouSureDialog("delete account", (){
                                Navigator.pop(ctx);

                                showCupertinoDialog(
                                  context: context, 
                                  builder: (innerContext) =>  CupertinoAlertDialog(
                                    title: const Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Text("Attention!", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                    ),
                                    content: const Text("You cannot undo this, everything will be deleted, are you sure?", style: TextStyle(fontWeight: FontWeight.w500)),
                                    actions: [
                                      CupertinoDialogAction(
                                        onPressed: (){
                                          Navigator.pop(innerContext);
                                        },
                                        child: const Text('NO', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                                      ),
                                      CupertinoDialogAction(
                                        onPressed: () {
                                          Navigator.pop(innerContext);
                                          _deleteUserAccount();
                                        },
                                        child: const Text('Delete', style: TextStyle(color: Colors.blueGrey, fontSize: 12))
                                      )
                                    ],
                                  )
                                );
                              })
                            );
                          },
                        )
                        : TextButton(
                          child: const Text('Delete Account', style: TextStyle(color: Color(0xFF777777), fontSize: 12)),
                          onPressed: (){
                            showDialog(
                              context: context, 
                              builder: (ctx) => AreYouSureDialog("delete account", (){
                                Navigator.pop(ctx);
                                
                                showDialog(
                                  context: context, 
                                  builder: (innerContext) =>  AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                    ),
                                    title: const Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Text("Attention!", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                    ),
                                    content: const Text("You cannot undo this, everything will be deleted, are you sure?", style: TextStyle(fontWeight: FontWeight.w500)),
                                    actions: [
                                      TextButton(
                                        onPressed: (){
                                          Navigator.pop(innerContext);
                                        },
                                        child: const Text('NO', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(innerContext);
                                          _deleteUserAccount();
                                        },
                                        child: const Text('Delete', style: TextStyle(color: Colors.blueGrey, fontSize: 12))
                                      )
                                    ],
                                  )
                                );
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

  SettingsTile _userInfoText(String title, String data) => SettingsTile(
    title: Row(
      children: [
        Text(title),
        const SizedBox(width: 8),
        Expanded(
          child: AutoSizeText(
            data,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
            maxLines: 1,
            maxFontSize: 16,
            minFontSize: 12,
          ),
        ),
      ],
    )
  );
}
