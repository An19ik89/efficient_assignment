import 'package:efficient_flutter_task/pages/home_page.dart';
import 'package:efficient_flutter_task/styles/text_styles.dart';
import 'package:efficient_flutter_task/validations/validator.dart';
import 'package:efficient_flutter_task/widgets/buttons.dart';
import 'package:efficient_flutter_task/widgets/text_fields.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFieldCustom(
                labelText: 'login',
                validator: (v) => Validator.validateEmail(v!),
                controller: usernameController,
              ),
              TextFieldCustom(
                labelText: 'password',
                validator: (v) => Validator.validatePassword(v!),
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(
                height: 40,
              ),
              ButtonCustom(
                onPressed: () {
                  final isValid = formKey.currentState!.validate();
                  if (isValid) {
                    setState(() {
                      userLogin(
                          username: usernameController.text.trim(),
                          password: passwordController.text.trim());
                    });
                  }
                },
                buttonName: const Text(
                        'login',
                        style: buttonMedium16,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  userLogin({required String username, required String password}) async {

      if ((username == "esssumon@gmail.com" || username == "user") &&
          password == "password") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('login successful')),
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credential does not match')),
        );
      }

  }
}
