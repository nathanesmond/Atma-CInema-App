import 'package:flutter/material.dart';
import 'package:tubez/theme.dart';

Padding inputForm(Function(String?) validasi, {required TextEditingController controller,
required String hintTxt, bool password = false}) {
    return Padding(
      padding: kDefaultPadding,
      child: SizedBox(
        width: 350,
        child : TextFormField(
          style: const TextStyle(color: Colors.white),
          validator: (value) => validasi(value),
          autofocus: true,
          controller: controller,
          obscureText: password,
          decoration: InputDecoration(
            hintText: hintTxt,
          ),
        )
      ),
    );
}

Padding inputFormPassword(Function(String?) validasi, {required TextEditingController controller,
required String hintTxt, required IconData iconData, required bool password}) {
  bool isObscure = password;
    return Padding(
      padding: kDefaultPadding,
      child: SizedBox(
        width: 350,
        child : TextFormField(
          style: const TextStyle(color: Colors.white),
          validator: (value) => validasi(value),
          autofocus: true,
          controller: controller,
          obscureText: isObscure,
          decoration: InputDecoration(
            hintText: hintTxt,
            suffixIcon: IconButton(
                    onPressed: () {          
                      isObscure = !password;
                    },
                    
                    icon: isObscure ? 
                      Icon(iconData) : const Icon(Icons.account_balance),
                      color: kTextFieldColor,
                    ),
          ),
        )
      ),
    );
}