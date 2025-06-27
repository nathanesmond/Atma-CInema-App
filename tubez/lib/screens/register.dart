import 'package:flutter/material.dart';
import 'package:tubez/screens/login.dart';
import 'package:tubez/component/form_component.dart';
import 'package:tubez/theme.dart';
import 'package:tubez/widgets/checkbox.dart';
import 'package:tubez/client/UserClient.dart';
import 'package:tubez/entity/User.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateBirthController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isObscure = true;
  bool isObscureConfirm = true;
  @override
  void initState() {
    super.initState();
  }

  String formatDate(String input) {
    try {
      // Split the input date
      List<String> parts = input.split('/');

      if (parts.length == 3) {
        // Return the formatted date in yyyy-MM-dd format
        return '${parts[2]}-${parts[1]}-${parts[0]}';
      }
      throw FormatException("Invalid date format");
    } catch (e) {
      throw FormatException("Invalid date format");
    }
  }

  DateTime parseDate(String input) {
    String formattedDate = formatDate(input);
    return DateTime.parse(formattedDate);
  }

  void _showAlertDialog(BuildContext context, Function onConfirm) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Register Alert!!!",
      desc: "Apakah kamu yakin data nya sudah benar?",
      buttons: [
        DialogButton(
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          color: Colors.red,
        ),
        DialogButton(
          child: const Text(
            "Confirm",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm();
          },
          color: Colors.green,
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: kDefaultPadding,
                child: Text(
                  'Create Account',
                  style: titleText,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: kDefaultPadding,
                child: Row(
                  children: [
                    Text(
                      'Already a member?',
                      style: subTitle,
                    ),
                    TextButton(
                        onPressed: () {
                          pushLogin(context);
                        },
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Color.fromARGB(205, 205, 144, 3),
                            fontSize: 17,
                            color: Color.fromARGB(205, 205, 144, 3),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              inputForm(
                (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'First Name tidak boleh kosong';
                  }
                  return null;
                },
                controller: firstNameController,
                hintTxt: "First Name",
              ),
              const SizedBox(
                height: 15,
              ),
              inputForm(
                (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'Last Name tidak boleh kosong';
                  }
                  return null;
                },
                controller: lastNameController,
                hintTxt: "Last Name",
              ),
              const SizedBox(
                height: 15,
              ),
              inputForm(
                (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'Date Birth tidak boleh kosong';
                  }
                  return null;
                },
                controller: dateBirthController,
                hintTxt: "Date Birth",
              ),
              const SizedBox(
                height: 15,
              ),
              inputForm(
                ((p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!p0.contains('@')) {
                    return 'Email harus menggunakan @';
                  }
                  return null;
                }),
                controller: emailController,
                hintTxt: "Email",
              ),
              const SizedBox(
                height: 15,
              ),
              inputForm(
                ((p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'Nomor HP tidak boleh kosong';
                  }
                  return null;
                }),
                controller: phoneController,
                hintTxt: "phone",
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: kDefaultPadding,
                child: SizedBox(
                    width: 350,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password tidak boleh kosong";
                        }
                        return null;
                      },
                      autofocus: true,
                      controller: passwordController,
                      obscureText: isObscure,
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          icon: isObscure
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                          color: kTextFieldColor,
                        ),
                      ),
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: kDefaultPadding,
                child: SizedBox(
                    width: 350,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Confirm Password tidak boleh kosong";
                        }
                        if (passwordController.text != value) {
                          return 'Password Tidak Sesuai';
                        }
                        return null;
                      },
                      autofocus: true,
                      controller: confirmPasswordController,
                      obscureText: isObscureConfirm,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscureConfirm = !isObscureConfirm;
                            });
                          },
                          icon: isObscureConfirm
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                          color: kTextFieldColor,
                        ),
                      ),
                    )),
              ),
              const SizedBox(
                height: 25,
              ),
              const Padding(
                padding: kDefaultPadding,
                child: CheckBox('I have Agree to Terms and Conditions.'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        const WidgetStatePropertyAll<Color>(kPrimaryColor),
                    foregroundColor:
                        const WidgetStatePropertyAll<Color>(Colors.white),
                    fixedSize: WidgetStateProperty.all<Size>(
                      const Size(350, 50),
                    ),
                    textStyle: WidgetStateProperty.all<TextStyle>(
                        const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _showAlertDialog(context, () async {
                          // buat tanggalLahir yang awalnya dd/mm/yyyy jadi yyyy-mm-dd
                          DateTime tanggalLahir =
                              parseDate(dateBirthController.text);
                          DateFormat formatter = DateFormat('yyyy-MM-dd');
                          String formatted = formatter.format(tanggalLahir);

                          User newUser = User(
                            username: firstNameController.text +
                                " " +
                                lastNameController.text,
                            password: passwordController.text,
                            tanggalLahir: formatted,
                            email: emailController.text,
                            noTelepon: phoneController.text,
                            foto: "",
                          );

                          try {
                            // ngelakuin register lalu response nya disimpan di variabel response
                            var response = await UserClient.register(newUser);
                            // jika status code nya 200 atau berhasil maka akan di push ke halaman login
                            if (response.statusCode == 200) {
                                Fluttertoast.showToast(
                                msg: "Berhasil Register! :D",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 25.0
                              );

                              await Future.delayed(Duration(seconds: 2));
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Registration failed: ${response.body}')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error Nya: $e')),
                            );
                          }
                      });
                    }
                  },
                  child: const Text('Sign Up'))
            ],
          ),
        ),
      ),
    );
  }

  void pushLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }
}
