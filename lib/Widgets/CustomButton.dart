import 'package:flutter/material.dart';

import '../Constant/colors.dart';

Widget CustomButton(var text,ontap,var w,var h) {
  return ElevatedButton(
    onPressed:ontap,
    style: ElevatedButton.styleFrom(
        fixedSize: Size(w, h),
        shape: const StadiumBorder(),
        backgroundColor: purplefav),
    child: Text(
      "$text",
      style: const TextStyle(fontSize: 22, color: Colors.white),
    ),
  );
}
