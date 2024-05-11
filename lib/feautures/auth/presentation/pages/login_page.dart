import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_challenge/core/routes_names.dart';
import 'package:new_challenge/feautures/auth/presentation/widgets/login_form.dart';
import '../bloc/auth/auth_bloc.dart';
import '../widgets/login_bg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String _email = ''; //to store the entered email
  String _emailValidatorText = ''; //for validation process
  bool _obscurePassword = true; //for validation process
  String _password = ''; //to store the entered password
  String _passwordValidatorText = ''; //to control the eye password button

  Future<void> _submit() async {
    // this method for validation and login processes
    if (!_formKey.currentState!.validate() ||
        _emailValidatorText != '' ||
        _passwordValidatorText != '') {
      return;
    }
    _formKey.currentState!.save();

    BlocProvider.of<AuthBloc>(context).add(
      LoginEvent(
        email: _email,
        password: _password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //background and logo
          const LoginBg(withBackArrow: false),
          //body
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: height * 0.32),
                    //title
                    const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: height * 0.035),
                    //form
                    SizedBox(
                      width: 242,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //email
                            LoginForm(
                              title: 'البريد الالكتروني',
                              icon: const Icon(
                                Icons.email,
                                color: Color(0xFF858585),
                                size: 18,
                              ),
                              obscureText: false,
                              onEnterText: (text) {
                                _email = text;
                              },
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  setState(() {
                                    _emailValidatorText =
                                        '!البريد الالكتروني غير صالح';
                                  });
                                } else {
                                  setState(() {
                                    _emailValidatorText = '';
                                  });
                                }
                                return null;
                              },
                              validatorText: _emailValidatorText,
                            ),
                            //password
                            LoginForm(
                              title: 'كلمة المرور',
                              icon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.remove_red_eye,
                                  color: const Color(0xFF858585),
                                ),
                              ),
                              obscureText: _obscurePassword,
                              onEnterText: (text) {
                                _password = text;
                              },
                              validator: (value) {
                                if (value!.isEmpty || value.length < 5) {
                                  setState(() {
                                    _passwordValidatorText =
                                        '!كلمة المرور قصيرة للغاية';
                                  });
                                } else {
                                  setState(() {
                                    _passwordValidatorText = '';
                                  });
                                }
                                return null;
                              },
                              validatorText: _passwordValidatorText,
                            ),
                            //forget button

                            TextButton(
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.only(top: 0)),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(RoutesNames.forgetPassord);
                              },
                              child: const Text(
                                'نسيت كلمة المرور؟',
                                style: TextStyle(
                                  color: Color(0xffF1B820),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //continue or error message or circular progress indicator
                    Padding(
                      padding: EdgeInsets.only(
                        top: _emailValidatorText != '' ||
                                _passwordValidatorText != ''
                            ? 5
                            : 15,
                        bottom: 10,
                      ),
                      child: BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is ErrorState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is LoadingState) {
                            return const CircularProgressIndicator();
                          } else {
                            return GestureDetector(
                              onTap: _submit,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                height: 43,
                                width: 141,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 11),
                                child: const Text(
                                  'متابعة',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    //google
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                        ),
                        height: 43,
                        width: 141,
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        margin: EdgeInsets.only(
                          bottom: _emailValidatorText != '' ||
                                  _passwordValidatorText != ''
                              ? 10
                              : 25,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('assets/images/Google.png'),
                            const Text(
                              'Google',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //create account
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        const Text(
                          ' ،إذا لم يكن لديك حساب',
                          style: TextStyle(
                            color: Color(0xFF858585),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(RoutesNames.createAccount);
                          },
                          child: const Text(
                            'أنشىء حساباً',
                            style: TextStyle(
                              color: Color(0xffF1B820),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
