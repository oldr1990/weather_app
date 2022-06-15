import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:weather_app/pages/auth_page/auth_cubit.dart';
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

  @override
  void initState() {
    super.initState();
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
    bool valid = isValideEmail();
    _invalidEmail = !valid;
    return valid;
  }

  bool validatePassword() {
    bool valid = isValidPassword();
    _invalidPassword = !valid;
    return valid;
  }

  bool isValideEmail() {
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
    BlocListener<AuthCubit, AuthState>(listener: (context, state) {
      switch (state.status) {
        case AuthStatus.success:
          context.loaderOverlay.hide();
          showError('Success');
          break;
        case AuthStatus.initial:
          context.loaderOverlay.hide();
          break;
        case AuthStatus.failure:
          context.loaderOverlay.hide();
          showError(state.errorMessage);
          break;
        case AuthStatus.loading:
          context.loaderOverlay.show();
          break;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Вход',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          elevation: 8.0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Вход'),
                const SizedBox(height: 16),
                buildEditText(
                  'Email',
                  _emailController,
                  _invalidEmail,
                  'Не корректный Email.',
                  const Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                buildEditText(
                  'Пароль',
                  _passwordController,
                  _invalidPassword,
                  'Не корректный пароль.',
                  const Icon(
                    Icons.password,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black12)),
                  child: Text(
                    "Регистрация",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  onPressed: validateInput() ? _onPressed : null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPressed() {
    context.read<AuthCubit>().register(
          _emailController.text,
          _passwordController.text,
        );
  }

  Widget buildEditText(String label, TextEditingController controller,
      bool validated, String errorMessage, Widget icon) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
        child: icon,
      ),
      Expanded(
        child: TextField(
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
          textInputAction: TextInputAction.next,
        ),
      ),
    ]);
  }

  void showError(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message ?? "Unexpected Error",
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      backgroundColor: Colors.black38,
      duration: const Duration(seconds: 2),
    ));
  }
}
