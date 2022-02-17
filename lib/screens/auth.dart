import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../providers/auth.dart';
import '../constant.dart';

enum AuthMode {
  login,
  signup,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;
  bool _isLoading = false;

  AuthMode _authMode = AuthMode.login;

  bool get _isValid {
    return _formKey.currentState!.validate();
  }

  Future<void> _sendReq(AuthProvider auth, String type, Object body) async {
    final response = await http.post(
      Uri.parse("${Constants.serverUrl}/auth/$type"),
      body: json.encode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final data = json.decode(response.body.toString());

    if (response.statusCode == 200) {
      final token = data['token'];
      data['user']['_id'] = data['user']['id'];
      final user = User.fromJSON(data['user']);
      await auth.authenticate(token, user);
      // await auth.authenticate(token, user);
    } else {
      throw Exception(data['error'] ?? 'Unknown error');
    }
  }

  Future<void> _submit(AuthProvider auth) async {
    if (!_isValid) {
      return;
    }

    _formKey.currentState!.save();

    if (_authMode == AuthMode.login) {
      try {
        setState(() {
          _isLoading = true;
        });
        await _sendReq(auth, 'login', {
          'email': _emailController.text,
          'password': _passwordController.text,
        });
      } catch (e) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      try {
        setState(() {
          _isLoading = true;
        });
        await _sendReq(auth, 'signup', {
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        });
      } catch (e) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acadme'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  _authMode == AuthMode.login ? 'Login' : 'Signup',
                  style: const TextStyle(fontSize: 32),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_authMode == AuthMode.signup)
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                          ),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                        ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please enter an email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      !_isLoading
                          ? Consumer<AuthProvider>(
                              builder: (ctx, auth, _) => ElevatedButton(
                                child: Text(_authMode == AuthMode.login
                                    ? 'Login'
                                    : 'Signup'),
                                onPressed: () => _submit(auth),
                              ),
                            )
                          : const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16),
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    if (_authMode == AuthMode.login)
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(fontSize: 16),
                      ),
                    if (_authMode == AuthMode.signup)
                      const Text(
                        'Already have an account?',
                        style: TextStyle(fontSize: 16),
                      ),
                    TextButton(
                      child: Text(
                        _authMode == AuthMode.login ? 'Signup' : 'Login',
                      ),
                      onPressed: () {
                        setState(() {
                          _authMode = _authMode == AuthMode.login
                              ? AuthMode.signup
                              : AuthMode.login;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
