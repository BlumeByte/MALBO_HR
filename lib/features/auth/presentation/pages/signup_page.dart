import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _company = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Create MALBO HR Account',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                      controller: _company,
                      decoration:
                          const InputDecoration(labelText: 'Company Name')),
                  const SizedBox(height: 10),
                  TextField(
                      controller: _firstName,
                      decoration:
                          const InputDecoration(labelText: 'First Name')),
                  const SizedBox(height: 10),
                  TextField(
                      controller: _lastName,
                      decoration:
                          const InputDecoration(labelText: 'Last Name')),
                  const SizedBox(height: 10),
                  TextField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 10),
                  TextField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password')),
                  const SizedBox(height: 20),
                  authState.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            ref.read(authControllerProvider.notifier).signUp(
                                  email: _email.text.trim(),
                                  password: _password.text.trim(),
                                  companyName: _company.text.trim(),
                                  firstName: _firstName.text.trim(),
                                  lastName: _lastName.text.trim(),
                                );
                          },
                          child: const Text("Create Company Account"),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
