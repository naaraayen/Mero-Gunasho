import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../exeception_handler/http_exception.dart';
import '../screens/home_screen.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_field.dart';

enum AuthMode { logIn, signUp }

class AuthScreen extends StatefulWidget {
  static const routeName = '/AuthScreen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, String> _authData = {'email': '', 'password': ''};

  final _passwordController = TextEditingController();

  AuthMode _authMode = AuthMode.logIn;

  final passwordFocus = FocusNode();
  final confirmPasswordfocus = FocusNode();

  @override
  void dispose() {
    passwordFocus.dispose();
    confirmPasswordfocus.dispose();
    super.dispose();
  }

  void _submit() async {
    passwordFocus.unfocus;
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();

    try {
      if (_authMode == AuthMode.logIn) {
        await Provider.of<Authentication>(context, listen: false)
            .signIn(_authData['email']!, _authData['password']!);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed(Home.routeName);
      } else {
        await Provider.of<Authentication>(context, listen: false)
            .signUp(_authData['email']!, _authData['password']!);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Sign Up Successful. You May Log In Now.')));
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find an email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'This is not a valid password';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        duration: const  Duration(seconds: 1),
      ));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Unable To Perform The Intended Action. Please Try Again Later.'),
        duration: Duration(seconds: 1),
      ));
    }
    setState(() {});
  }

//method to toggle authentication page
  void _switchAuthMode() {
    if (_authMode == AuthMode.logIn) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.logIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: 10 + mediaQueryData.viewInsets.bottom,
            ),
            child: Column(
              children: [
                //if (_authMode == AuthMode.logIn)
                SizedBox(
                    height: _authMode == AuthMode.logIn
                        ? mediaQueryData.size.height * 0.4
                        : mediaQueryData.size.height * 0.3,
                    child: Image.asset(
                      _authMode == AuthMode.logIn
                          ? 'assets/logos/mero_gunasho_signin.png'
                          : 'assets/logos/mero_gunasho_signup.png',
                      fit: BoxFit.scaleDown,
                    )),
                SizedBox(
                    width: mediaQueryData.size.width * 0.6,
                    child: const Divider(
                        color: Color(0XFF3F3D56), thickness: 2.0)),
                CustomText(
                  _authMode == AuthMode.logIn
                      ? 'LOG IN AS A CITIZEN'
                      : 'SIGN UP AS A CITIZEN',
                  fontSize: 18,
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Email',
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Email is not valid';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              _authData['email'] = value;
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(passwordFocus),
                        ),
                        CustomTextField(
                          label: 'Password',
                          focusNode: passwordFocus,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 8) {
                              return 'Password must be of 8 characters';
                            }
                            return null;
                          },
                          controller: _passwordController,
                          onSaved: (value) {
                            if (value != null) {
                              _authData['password'] = value;
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _authMode == AuthMode.logIn
                              ? FocusScope.of(context).unfocus()
                              : FocusScope.of(context)
                                  .requestFocus(confirmPasswordfocus),
                        ),
                        if (_authMode == AuthMode.signUp)
                          CustomTextField(
                            label: 'Confirm Password',
                            focusNode: confirmPasswordfocus,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Password does not match';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                _authData['password'] = value;
                              }
                            },
                          ),
                      ],
                    )),
                const SizedBox(height: 30),
                Column(
                  verticalDirection: _authMode == AuthMode.logIn
                      ? VerticalDirection.down
                      : VerticalDirection.up,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      onPressed: _authMode == AuthMode.signUp
                          ? _switchAuthMode
                          : () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _submit();
                            },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0XFF3F3D56)),
                          padding: MaterialStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 15))),
                      child: Text(
                        _authMode == AuthMode.logIn
                            ? 'LOG IN'
                            : 'LOG IN INSTEAD',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: _authMode == AuthMode.signUp
                          ? () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _submit();
                            }
                          : _switchAuthMode,
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0XFF6C63FF)),
                          padding: MaterialStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 15))),
                      child: const Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
