import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Text('Sign Up', style: Theme.of(context).textTheme.headline4),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'E-mail',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      hintText: 'Password',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // sing up
                      },
                      child: const Text("Sign Up"),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text("Already have an account, please sign in"),
                ),
                Container(
                  padding: const EdgeInsets.all(4.0),
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  child: TextButton(
                    onPressed: () {
                      // singin
                    },
                    child: const Text("Sign In"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
