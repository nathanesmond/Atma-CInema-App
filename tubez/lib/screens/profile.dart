import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubez/client/UserClient.dart';
import 'package:tubez/client/apiURL.dart';
import 'package:tubez/screens/edit_profile.dart';
import 'dart:convert';
import 'package:tubez/screens/login.dart';
import 'package:tubez/entity/User.dart';

class profileScreen extends StatefulWidget {
  profileScreen({super.key, required this.updatedUser});

  final Function(User) updatedUser;

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  bool _isLoading = true; // Track loading state for fetching data
  String? _name;
  String? _email;
  String? _noTelp;
  String? _dateBirth;
  String? _password;
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Method to load the user profile
  Future<void> _loadUserProfile() async {
    UserClient userClient = UserClient();
    String? token = await userClient.getToken(); // Getting the token

    if (token != null) {
      // Fetch user data using the API
      final response = await userClient.dataUser(token);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var dataUser = data['data'];

        setState(() {
          _name = dataUser['username'];
          _email = dataUser['email'];
          _noTelp = dataUser['noTelepon'];
          _dateBirth = dataUser['tanggalLahir'];
          _password = dataUser['password'];
          _profileImage = dataUser['foto'];
          _isLoading = false;
        });
      } else {
        print("Failed to load user data");
      }
    } else {
      print("Token is null");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 35, 35, 35),
        leading: IconButton(
          onPressed: () {
            widget.updatedUser(User(
              username: _name!,
              email: _email!,
              noTelepon: _noTelp!,
              tanggalLahir: _dateBirth!,
              password: _password!,
              foto: _profileImage!,
            ));
            Navigator.pop(context);
          },
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
        ),
        leadingWidth: 80,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  'My Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(205, 205, 144, 3),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: const Color.fromARGB(36, 158, 158, 158),
                radius: 25,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 60,
                    width: 60,
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              width: 1,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                NetworkImage('$urlGambar/storage/$_profileImage'),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _name!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 27,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                _noTelp!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 111, 111, 111),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'PROFILE',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final updatedData = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  username: _name!,
                                  email: _email!,
                                  noTelp: _noTelp!,
                                  dateBirth: _dateBirth!,
                                  password: _password!,
                                  currentPhoto: _profileImage!,
                                ),
                              ),
                            );

                            if (updatedData != null) {
                              setState(() {
                                _name = updatedData['username'];
                                _email = updatedData['email'];
                                _noTelp = updatedData['noTelp'];
                                _dateBirth = updatedData['dateBirth'];
                                _password = updatedData['password'];
                                _profileImage = updatedData['currentPhoto'];
                              });
                            }

                            _loadUserProfile();
                          },
                          child: const Text(
                            'EDIT',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(205, 205, 144, 3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(
                    thickness: 1,
                    color: Color.fromARGB(104, 178, 178, 178),
                  ),
                  const SizedBox(height: 20),
                  _buildProfileInfo("Username", _name!),
                  _buildProfileInfo("Email", _email!),
                  _buildProfileInfo("Nomor Telepon", _noTelp!),
                  _buildProfileInfo("Tanggal Lahir", _dateBirth!),
                  _buildProfileInfo("Password", '******'),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // ngeluarin snackbar
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Success!',
                          message: 'Berhasil Logout!',
                          contentType: ContentType.success,
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      await Future.delayed(Duration(seconds: 1));
                      try {
                        // ngelakuin logout lalu response nya disimpan di variabel response
                        var response = await UserClient.logout();
                        // jika status code nya 200 atau berhasil maka akan di push ke halaman login
                        if (response.statusCode == 200) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text("Log Out",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255))),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
    );
  }
}
