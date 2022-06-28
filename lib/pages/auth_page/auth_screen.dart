import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:weather_app/components/button_component.dart';
import 'package:weather_app/components/snackbar_component.dart';
import 'package:weather_app/models/user_data.dart';
import 'package:weather_app/pages/auth_page/auth_cubit.dart';
import 'package:weather_app/pages/home_page/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weather_app/utils/get_error_message.dart';
import 'auth_cubit.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _invalidEmail = false;
  bool _invalidPassword = false;
  AppLocalizations? stringRes;

  @override
  void initState() {
    super.initState();
    _emailController.text = '';
    _passwordController.text = '';
    context.read<AuthCubit>().readUserData();
    _emailController.addListener(() {
      setState(() {
        _invalidEmail = false;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        _invalidPassword = false;
      });
    });
  }

  bool validateInput() {
    return validatePassword() && validateEmail();
  }

  bool validateEmail() {
    bool valid = isValidEmail();
    _invalidEmail = !valid;
    return valid;
  }

  bool validatePassword() {
    bool valid = isValidPassword();
    _invalidPassword = !valid;
    return valid;
  }

  bool isValidEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_emailController.text);
  }

  bool isValidPassword() {
    return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(_passwordController.text);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    stringRes = AppLocalizations.of(context);
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) => true,
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.loaderOverlay.hide();
          Navigator.pushReplacementNamed(context, HomePage.route);
        } else if (state is AuthError) {
          context.loaderOverlay.hide();
          showSnackbar(context, (state.error.getErrorMessage(context)));
        } else if (state is AuthLoading) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Вход',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            elevation: 8.0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(stringRes!.login,
                      style: Theme.of(context).textTheme.headline2),
                  const SizedBox(height: 16),
                  buildEditText(
                    stringRes!.email,
                    _emailController,
                    _invalidEmail,
                    stringRes!.invalid_input_email,
                    const Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    false,
                    isLast: false,
                  ),
                  const SizedBox(height: 16),
                  buildEditText(
                      stringRes!.password,
                      _passwordController,
                      _invalidPassword,
                      stringRes!.invalid_input_password,
                      const Icon(
                        Icons.password,
                        color: Colors.white,
                      ),
                      true),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ButtonComponent(
                          text: stringRes!.login, onPressed: _login),
                      const SizedBox(width: 8),
                      ButtonComponent(
                          text: stringRes!.registration, onPressed: _register),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _register() {
    if (validateInput()) {
      context.read<AuthCubit>().register(_getUserData());
    } else {
      showSnackbar(context, stringRes!.invalid_input);
    }
  }

  UserData _getUserData() {
    return UserData(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void _login() {
    if (validateInput()) {
      context.read<AuthCubit>().login(_getUserData());
    } else {
      showSnackbar(context, stringRes!.invalid_input);
    }
  }

  Widget buildEditText(String label, TextEditingController controller,
      bool validated, String errorMessage, Widget icon, bool isPassword,
      {bool isLast = true}) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
        child: icon,
      ),
      Expanded(
        child: TextField(
          obscureText: isPassword,
          maxLines: 1,
          maxLength: 20,
          controller: controller,
          decoration: InputDecoration(
            errorText: validated ? errorMessage : null,
            labelText: label,
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
        ),
      ),
    ]);
  }
}
