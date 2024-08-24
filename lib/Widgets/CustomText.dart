import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

import '../Constant/colors.dart';
class Customtext extends StatefulWidget {
  final String hinttext;
  final TextEditingController controller;
  final TextEditingController? newPasswordController; // Optional controller for new password

  Customtext(this.hinttext, this.controller, {this.newPasswordController, super.key});

  @override
  State<Customtext> createState() => _CustomtextState();
}

class _CustomtextState extends State<Customtext> {
  bool obscure = false;

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    if (widget.hinttext == 'Email' && !GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    if ((widget.hinttext == 'Password' ||
        widget.hinttext == 'Old Password' ||
        widget.hinttext == 'New Password') &&
        value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (widget.hinttext == 'Confirm Password' && widget.newPasswordController != null) {
      if (value != widget.newPasswordController!.text) {
        return 'Confirm Password does not match New Password';
      }
    }
    if ((widget.hinttext == 'First name' || widget.hinttext == 'Last name') &&
        value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: _validateInput,
      cursorColor: Colors.indigo,
      onTapOutside: (v) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: widget.controller,
      obscureText: (widget.hinttext == 'Password' ||
          widget.hinttext == 'Old Password' ||
          widget.hinttext == 'New Password' ||
          widget.hinttext == 'Confirm Password')
          ? !obscure
          : false,
      style: const TextStyle(fontSize: 19),
      decoration: InputDecoration(
        suffixIcon: (widget.hinttext == 'Password' ||
            widget.hinttext == 'Old Password' ||
            widget.hinttext == 'New Password' ||
            widget.hinttext == 'Confirm Password')
            ? IconButton(
          icon: obscure
              ? Icon(Icons.remove_red_eye, color: purplefav)
              : FaIcon(CupertinoIcons.eye_slash, color: purplefav),
          onPressed: () {
            setState(() {
              obscure = !obscure;
            });
          },
        )
            : widget.hinttext == 'Email'
            ? Icon(FontAwesomeIcons.envelope, color: purplefav)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: widget.hinttext,
      ),
    );
  }
}