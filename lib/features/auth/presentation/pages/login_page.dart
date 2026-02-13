//with signup page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = TextEditingController();
    final password = TextEditingController();

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign In",
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ref.read(authControllerProvider.notifier).signIn(
                        email: email.text.trim(),
                        password: password.text.trim(),
                      );
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//without signup page

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../controllers/auth_controller.dart';

// class LoginPage extends ConsumerWidget {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final emailCtrl = TextEditingController();
//     final passCtrl = TextEditingController();

//     return Scaffold(
//       body: Center(
//         child: Card(
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: SizedBox(
//               width: 360,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'MALBO HR',
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 24),
//                   TextField(
//                     controller: emailCtrl,
//                     decoration: const InputDecoration(labelText: 'Email'),
//                   ),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: passCtrl,
//                     decoration: const InputDecoration(labelText: 'Password'),
//                     obscureText: true,
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: () async {
//                       await ref
//                           .read(authControllerProvider.notifier)
//                           .signIn(emailCtrl.text, passCtrl.text);
//                     },
//                     child: const Text('Sign in'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
