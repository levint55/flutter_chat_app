import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
          String? email, String? username, String? password, bool isLogin)
      submitForm;
  final bool isLoading;

  const AuthForm(
    this.submitForm,
    this.isLoading, {
    Key? key,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String? _userEmail = '';
  String? _userName = '';
  String? _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid == null) {
      return;
    }

    if (isValid) {
      _formKey.currentState?.save();
      widget.submitForm(
          _userEmail, _userName!.trim(), _userPassword!.trim(), _isLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(
                key: const ValueKey('email'),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email address'),
                validator: (value) {
                  if (value == null) {
                    return 'Input is null';
                  }
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _userEmail = value;
                },
              ),
              if (!_isLogin)
                TextFormField(
                  key: const ValueKey('username'),
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null) {
                      return 'Input is null';
                    }
                    if (value.isEmpty || value.length < 4) {
                      return 'Username must be at least 5 characters long.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userName = value;
                  },
                ),
              TextFormField(
                key: const ValueKey('password'),
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null) {
                    return 'Input is null';
                  }
                  if (value.isEmpty || value.length < 7) {
                    return 'Password must be at least 7 characters long.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _userPassword = value;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              if (widget.isLoading) const CircularProgressIndicator(),
              if (!widget.isLoading)
                ElevatedButton(
                    onPressed: _trySubmit,
                    child: !_isLogin
                        ? const Text('Sign Up')
                        : const Text('Login')),
              if (!widget.isLoading)
                TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: !_isLogin
                        ? const Text('Already have an account?')
                        : const Text('Create new account'))
            ]),
          ),
        ),
      ),
    ));
  }
}
