import 'package:flutter/material.dart';

class WidgetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Color? backgroundColor;
  final Size? size;
  final Widget? leading;
  final List<Widget>? actions;

  const WidgetAppBar({
    super.key,
    this.title,
    this.backgroundColor,
    this.size,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      backgroundColor: backgroundColor ?? Colors.transparent,
      actions: actions,
      leading: leading,
      toolbarHeight: preferredSize.height,
    );
  }

  @override
  Size get preferredSize => size ?? const Size(0.0, 0.0);
}
