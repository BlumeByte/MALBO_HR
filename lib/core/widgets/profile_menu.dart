import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../profile/profile_provider.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../constants/app_routes.dart';
import 'package:go_router/go_router.dart';

class ProfileMenu extends ConsumerWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(right: 12),
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, __) => PopupMenuButton<String>(
        icon: const Icon(Icons.account_circle),
        onSelected: (v) async {
          if (v == 'logout') {
            await ref.read(authControllerProvider.notifier).signOut();
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'logout', child: Text('Logout')),
        ],
      ),
      data: (p) => PopupMenuButton<String>(
        tooltip: p.fullName,
        onSelected: (v) async {
          if (v == 'settings') {
            context.go(AppRoutes.settings);
          }
          if (v == 'logout') {
            await ref.read(authControllerProvider.notifier).signOut();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: (p.avatarUrl == null || p.avatarUrl!.isEmpty)
                    ? null
                    : NetworkImage(p.avatarUrl!),
                child: (p.avatarUrl == null || p.avatarUrl!.isEmpty)
                    ? Text(
                        (p.firstName.isNotEmpty ? p.firstName[0] : 'U')
                            .toUpperCase(),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                p.fullName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.expand_more),
            ],
          ),
        ),
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'settings', child: Text('Profile & Settings')),
          PopupMenuDivider(),
          PopupMenuItem(value: 'logout', child: Text('Logout')),
        ],
      ),
    );
  }
}
