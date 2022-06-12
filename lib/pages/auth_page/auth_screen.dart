import 'package:flutter/material.dart';

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
        _invalidEmail = !RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(_emailController.text);
      });
    });
    _passwordController.addListener(() {
      setState(() {
        _invalidPassword =
            !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
                .hasMatch(_passwordController.text);
      });
    });
  }
  //Walidate Email

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Вход'),
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
                buildEditText(
                  'Email',
                  _passwordController,
                  _invalidPassword,
                  'Не корректный пароль.',
                  const Icon(
                    Icons.password,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEditText(String label, TextEditingController controller,
      bool validated, String errorMessage, Widget icon) {
    return Row(children: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
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
}
