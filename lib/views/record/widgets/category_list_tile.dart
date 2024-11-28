import 'package:final_project/styles/color.dart';
import 'package:flutter/material.dart';

class CategoryListTile extends StatefulWidget {
  final Widget icon;
  final String title;
  final bool needCircleAvatar;
  final VoidCallback onTap;

  const CategoryListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.needCircleAvatar,
    required this.onTap,
  });

  @override
  State<CategoryListTile> createState() => _CategoryListTileState();
}

class _CategoryListTileState extends State<CategoryListTile> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isTapped = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isTapped = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          isTapped = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        color: isTapped ? Colors.grey[500] : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.needCircleAvatar ?
            CircleAvatar(
                radius: 20,
                backgroundColor: isTapped ? Colors.grey[100] : Colors.grey[300],
                child: widget.icon
            )
                : widget.icon,
            const SizedBox(width: 16),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isTapped ? FontWeight.w700 : FontWeight.w500,
                color: blackPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
