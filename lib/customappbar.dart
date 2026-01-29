import 'package:flutter/material.dart';
import 'color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLeading;
  final bool showMenu; // 👈 NEW
  final VoidCallback? onBack;
  final VoidCallback? onMenuTap; // 👈 NEW

  const CustomAppBar({
    super.key,
    required this.title,
    this.showLeading = false,
    this.showMenu = false,
    this.onBack,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryEnd,
      elevation: 0,
      centerTitle: true,

      // 👇 Leading Icon Logic
      leading: showLeading
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBack ?? () => Navigator.pop(context),
      )
          : showMenu
          ? IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: onMenuTap ??
                () => Scaffold.of(context).openDrawer(),
      )
          : null,

      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
