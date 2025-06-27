import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tubez/client/TransaksiClient.dart';
import 'package:tubez/screens/register.dart';
import 'package:tubez/theme.dart';
import 'package:tubez/widgets/login_options.dart';
import 'package:tubez/widgets/navigation.dart';
import 'package:tubez/component/form_component.dart';
import 'package:tubez/client/UserClient.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class LoginScreen extends StatefulWidget {
  final Map? data;

  const LoginScreen({super.key, this.data});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map? dataForm = widget.data;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 180,
              ),
              Text(
                'Welcome Back',
                style: titleText,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: kDefaultPadding,
                child: Row(
                  children: [
                    Text(
                      'New to this app?',
                      style: greyText,
                    ),
                    TextButton(
                        onPressed: () {
                          Map<String, dynamic> formData = {};
                          formData['username'] = emailController.text;
                          formData['password'] = passwordController.text;
                          pushRegister(context);
                        },
                        child: const Text(
                          'Sign Up',
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
              inputForm((p0) {
                if (p0 == null || p0.isEmpty) {
                  return "username tidak boleh kosong";
                }
                return null;
              }, controller: emailController, hintTxt: "Email"),
              const SizedBox(
                height: 25,
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
                height: 40,
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll<Color>(kPrimaryColor),
                        foregroundColor:
                            WidgetStatePropertyAll<Color>(Colors.white),
                        fixedSize: WidgetStateProperty.all<Size>(
                          const Size(350, 50),
                        ),
                        textStyle: WidgetStateProperty.all<TextStyle>(
                            const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            bool response = await UserClient.login(
                                emailController.text, passwordController.text);


                            if (response) {
                              final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Success!',
                                  message: 'Berhasil Login!',
                                  contentType: ContentType.success,
                                ),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                              await Future.delayed(Duration(seconds: 1));
                              
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const navigationBar()),
                              );
                            } else {
                              Alert(
                                context: context,
                                type: AlertType.error,
                                title: "Password Salah",
                                desc: "Password Salah",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "OK",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    width: 120,
                                  )
                                ],
                              ).show();
                            } 
                          } catch (e) {
                            Alert(
                              context: context,
                              type: AlertType.error,
                              title: "Username atau Password Salah",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  color: Colors.amber,
                                  onPressed: () => pushRegister(context),
                                  width: 120,
                                ),
                                DialogButton(
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  color: Colors.lightGreen,
                                  onPressed: () => Navigator.pop(context),
                                  width: 120,
                                )
                              ],
                            ).show();
                          }
                        }
                      },
                      child: const Text('Log In')),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              const Text('Or Log in With:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 15,
              ),
              const LoginOption(),
            ],
          ),
        ),
      ),
    );
  }

  void pushRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterView(),
      ),
    );
  }
}
