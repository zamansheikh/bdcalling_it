import 'dart:io';
import 'package:bdcalling_it/models/user_model.dart';
import 'package:bdcalling_it/screens/profile/profile_bloc/profile_bloc.dart';
import 'package:bdcalling_it/services/api_service.dart';
import 'package:bdcalling_it/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({required this.user, super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
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

  /// Download and save a file to the device
  Future<String> downloadAndSaveFile(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _firstNameController.text = widget.user.firstName;
      _lastNameController.text = widget.user.lastName;
      _addressController.text = widget.user.address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
            Navigator.pop(context);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ProfileLoaded) {
            final user = state.user;
            _firstNameController.text = user.firstName;
            _lastNameController.text = user.lastName;
            _addressController.text = user.address;
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : state.user.image != null
                                ? NetworkImage(
                                    '${ApiService.baseUrl}/${state.user.image}')
                                : null,
                        child:
                            _selectedImage == null && state.user.image == null
                                ? const Icon(Icons.camera_alt, size: 40)
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
                      controller: _addressController,
                      labelText: 'Address',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        context.read<ProfileBloc>().add(
                              UpdateProfile(
                                user: widget.user,
                                file: _selectedImage ??
                                    File(
                                      await downloadAndSaveFile(
                                          '${ApiService.baseUrl}/${state.user.image}',
                                          'profile.jpg'),
                                    ),
                              ),
                            );
                      },
                      child: const Text('Update Profile'),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
