import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      if (user == null) {
        throw Exception('User not logged in');
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        _firstNameController.text = data['firstName'] ?? '';
        _lastNameController.text = data['lastName'] ?? '';
        _emailController.text = data['email'] ?? user!.email ?? '';
      } else {
        // ⚠️ Document missing — create it
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .set({
          'firstName': '',
          'lastName': '',
          'email': user!.email ?? '',
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Edit Profile'),
        foregroundColor: AppColors.white,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: _isSaving
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Text(
              'Save',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary,
                child:
                Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 32),

              TextFormField(
                controller: _firstNameController,
                decoration:
                const InputDecoration(labelText: 'First Name'),
                validator: (value) =>
                value == null || value.isEmpty
                    ? 'First name is required'
                    : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _lastNameController,
                decoration:
                const InputDecoration(labelText: 'Last Name'),
                validator: (value) =>
                value == null || value.isEmpty
                    ? 'Last name is required'
                    : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration:
                const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
