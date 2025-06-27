import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tubez/client/UserClient.dart';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:tubez/client/apiURL.dart';

import 'package:tubez/entity/User.dart';

class EditProfileScreen extends StatefulWidget {
  final String username;
  final String email;
  final String noTelp;
  final String dateBirth;
  final String password;
  final String currentPhoto;

  const EditProfileScreen({
    super.key,
    required this.username,
    required this.email,
    required this.noTelp,
    required this.dateBirth,
    required this.password,
    required this.currentPhoto,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController controllerUsername;
  late TextEditingController controllerEmail;
  late TextEditingController controllerTelp;
  late TextEditingController controllerDateBirth;
  late TextEditingController controllerPassword;
  late TextEditingController controllerConfirm;
  late File? _profileImage;

  @override
  void initState() {
    super.initState();
    controllerUsername = TextEditingController(text: widget.username);
    controllerEmail = TextEditingController(text: widget.email);
    controllerTelp = TextEditingController(text: widget.noTelp);
    controllerDateBirth = TextEditingController(text: widget.dateBirth);
    controllerPassword = TextEditingController();
    controllerConfirm = TextEditingController();
    _profileImage = File(widget.currentPhoto);
  }

  @override
  void didUpdateWidget(covariant EditProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPhoto != oldWidget.currentPhoto) {
      setState(() {
        _profileImage = widget.currentPhoto.isNotEmpty ? File(widget.currentPhoto) : null;
      });
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _chooseProfileImage() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Sumber Gambar'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, ImageSource.camera); // Camera
              },
              child: const Text('Kamera'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, ImageSource.gallery); // Gallery
              },
              child: const Text('Galeri'),
            ),
          ],
        );
      },
    );

    if (source != null) {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    // Send updated profile data to backend
    try {
      File? profileImage = _profileImage ?? File(widget.currentPhoto);
      print('File exists: ${File(widget.currentPhoto).existsSync()}');

      var updatedData = {
        'username': controllerUsername.text,
        'email': controllerEmail.text,
        'noTelp': controllerTelp.text,
        'dateBirth': controllerDateBirth.text,
        'password': controllerPassword.text,
        'foto': profileImage,
      };

      User user = User(
        username: controllerUsername.text,
        email: controllerEmail.text,
        noTelepon: controllerTelp.text,
        tanggalLahir: controllerDateBirth.text,
        password: controllerPassword.text,
      );

      var response = await UserClient.update(user, profileImage: profileImage);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          content: AwesomeSnackbarContent(
            title: 'Success!',
            message: 'Profile updated successfully!',
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Future.delayed(Duration(seconds: 1));
        Navigator.pop(context, updatedData);
      } else {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          content: AwesomeSnackbarContent(
            title: 'Failed!',
            message: 'Failed to Update Profile!',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Future.delayed(Duration(seconds: 1));
      }
    } catch (e) {
      print("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error updating profile")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(36, 158, 158, 158),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
        ),
        leadingWidth: 80,
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'Edit Profile',
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : widget.currentPhoto.isNotEmpty
                          ? NetworkImage('$urlGambar/storage/${widget.currentPhoto}')
                              as ImageProvider
                          : NetworkImage('$urlGambar/storage/$_profileImage')
                              as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _chooseProfileImage,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: const Color.fromARGB(205, 205, 144, 3),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(label: "NAME", controller: controllerUsername),
            const SizedBox(height: 15),
            _buildTextField(label: "E-MAIL", controller: controllerEmail),
            const SizedBox(height: 13),
            _buildTextField(label: "MOBILE NUMBER", controller: controllerTelp),
            const SizedBox(height: 10),
            _buildTextField(
                label: "DATE OF BIRTH", controller: controllerDateBirth),
            const SizedBox(height: 20),
            _buildTextField(
                label: "PASSWORD",
                controller: controllerPassword,
                obscureText: true),
            const SizedBox(height: 20),
            _buildTextField(
                label: "CONFIRM PASSWORD",
                controller: controllerConfirm,
                obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (controllerPassword.text != controllerConfirm.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Passwords do not match!")),
                  );
                  return;
                }

                if (controllerPassword.text != controllerConfirm.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Passwords do not match!")),
                  );
                  return;
                }

                _updateProfile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "SAVE",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
