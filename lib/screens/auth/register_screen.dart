import 'dart:io';

import 'package:bdcalling_it/screens/auth/regi_bloc/register_bloc.dart';
import 'package:bdcalling_it/services/auth_service.dart';
import 'package:bdcalling_it/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Register'),
      ),
      body: BlocProvider(
        create: (context) => RegisterBloc(
          authService: AuthService(),
        ),
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration successful')),
              );
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : null,
                            child: _selectedImage == null
                                ? const Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _firstNameController,
                          labelText: 'First Name',
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _lastNameController,
                          labelText: 'Last Name',
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _emailController,
                          labelText: 'Email',
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _addressController,
                          labelText: 'Address',
                        ),
                        const SizedBox(height: 16),
                        if (state is RegisterLoading)
                          const CircularProgressIndicator()
                        else
                          ElevatedButton(
                            onPressed: () {
                              context.read<RegisterBloc>().add(UserRegistered(
                                    firstName: _firstNameController.text,
                                    lastName: _lastNameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    address: _addressController.text,
                                    profileImage: _selectedImage,
                                  ));
                            },
                            child: const Text('Register'),
                          ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: 'Already have an account? ',
                              children: [
                                TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
