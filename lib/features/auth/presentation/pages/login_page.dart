//with signup page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/utils/validators.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 420,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sign In", style: TextStyle(fontSize: 24)),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _password,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: Validators.password,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authState.isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;

                            await ref
                                .read(authControllerProvider.notifier)
                                .signIn(
                                  email: _email.text.trim(),
                                  password: _password.text,
                                );

                            final s = ref.read(authControllerProvider);
                            if (s.hasError && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Login failed: ${s.error}')),
                              );
                            }
                          },
                    child:
                        Text(authState.isLoading ? 'Signing in...' : 'Login'),
                  ),
                ),
              ],
            ),
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
