import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/profile/profile_provider.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_scaffold.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _fill(UserProfile p) {
    _firstName.text = p.firstName;
    _lastName.text = p.lastName;
    _phone.text = p.phone ?? '';
  }

  Future<void> _save(UserProfile p) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final client = Supabase.instance.client;

      await client.from('employees').update({
        'first_name': _firstName.text.trim(),
        'last_name': _lastName.text.trim(),
        'phone': _phone.text.trim().isEmpty ? null : _phone.text.trim(),
      }).eq('id', p.employeeId);

      ref.invalidate(userProfileProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickAndUploadAvatar(UserProfile p) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    setState(() => _saving = true);
    try {
      final bytes = await file.readAsBytes();
      final mime = lookupMimeType(file.path) ?? 'image/jpeg';

      final client = Supabase.instance.client;

      // Storage bucket: avatars
      final ext = file.name.split('.').last;
      final path = '${p.employeeId}/avatar.$ext';

      await client.storage.from('avatars').uploadBinary(
            path,
            Uint8List.fromList(bytes),
            fileOptions: FileOptions(contentType: mime, upsert: true),
          );

      final publicUrl = client.storage.from('avatars').getPublicUrl(path);

      await client.from('employees').update({
        'avatar_url': publicUrl,
      }).eq('id', p.employeeId);

      ref.invalidate(userProfileProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Avatar upload failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _changePassword() async {
    final newPass = TextEditingController();
    final confirm = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newPass,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New password'),
            ),
            TextField(
              controller: confirm,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPass.text.length < 8) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Minimum 8 characters')),
                );
                return;
              }
              if (newPass.text != confirm.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }

              try {
                await Supabase.instance.client.auth.updateUser(
                  UserAttributes(password: newPass.text),
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password updated')),
                  );
                }
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed: $e')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return AppScaffold(
      title: 'Profile & Settings',
      navIndex: 99,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (p) {
            _fill(p);

            return ListView(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundImage:
                          (p.avatarUrl == null || p.avatarUrl!.isEmpty)
                              ? null
                              : NetworkImage(p.avatarUrl!),
                      child: (p.avatarUrl == null || p.avatarUrl!.isEmpty)
                          ? Text(
                              (p.firstName.isNotEmpty ? p.firstName[0] : 'U')
                                  .toUpperCase(),
                              style: const TextStyle(fontSize: 24),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        p.fullName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _saving ? null : () => _pickAndUploadAvatar(p),
                      icon: const Icon(Icons.image),
                      label: const Text('Change photo'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _firstName,
                        decoration:
                            const InputDecoration(labelText: 'First name'),
                        validator: (v) =>
                            Validators.requiredField(v, label: 'First name'),
                      ),
                      TextFormField(
                        controller: _lastName,
                        decoration:
                            const InputDecoration(labelText: 'Last name'),
                        validator: (v) =>
                            Validators.requiredField(v, label: 'Last name'),
                      ),
                      TextFormField(
                        controller: _phone,
                        decoration: const InputDecoration(labelText: 'Phone'),
                        inputFormatters: InputFormatters.phone(),
                        validator: Validators.phoneGhOptional,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saving ? null : () => _save(p),
                              child:
                                  Text(_saving ? 'Saving...' : 'Save changes'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: _saving ? null : _changePassword,
                            child: const Text('Change password'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
