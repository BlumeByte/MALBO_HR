import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';

class SignupPage extends ConsumerWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = TextEditingController();
    final firstName = TextEditingController();
    final lastName = TextEditingController();
    final phone = TextEditingController();
    final email = TextEditingController();
    final password = TextEditingController();

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Create Company Account",
                  style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              TextField(
                controller: company,
                decoration: const InputDecoration(labelText: "Company Name"),
              ),
              TextField(
                controller: firstName,
                decoration: const InputDecoration(labelText: "First Name"),
              ),
              TextField(
                controller: lastName,
                decoration: const InputDecoration(labelText: "Last Name"),
              ),
              TextField(
                controller: phone,
                decoration: const InputDecoration(labelText: "Phone Number"),
              ),
              TextField(
                controller: email,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ref.read(authControllerProvider.notifier).signUp(
                        email: email.text.trim(),
                        password: password.text.trim(),
                        companyName: company.text.trim(),
                        firstName: firstName.text.trim(),
                        lastName: lastName.text.trim(),
                        phone: phone.text.trim(),
                      );
                },
                child: const Text("Create Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
