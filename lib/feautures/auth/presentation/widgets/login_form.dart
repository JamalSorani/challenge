import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.title,
    required this.icon,
    required this.onEnterText,
    required this.validator,
    required this.obscureText,
    required this.validatorText,
  });
  final String title;
  final Widget icon;
  final bool obscureText;
  final void Function(String text) onEnterText;
  final String? Function(String? value)? validator;
  final String validatorText;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          obscureText: widget.obscureText,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.title,
            hintStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w300,
              fontSize: 16,
              color: Color(0xff858585),
            ),
            icon: Padding(
                padding: const EdgeInsets.only(top: 14), child: widget.icon),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: widget.validator,
          onSaved: (value) {
            widget.onEnterText(value!);
          },
        ),
        const Divider(color: Colors.black),
        SizedBox(
          height: widget.validatorText == ''
              ? widget.title == 'البريد الالكتروني'
                  ? 10
                  : 0
              : 22,
          child: Text(
            widget.validatorText,
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
