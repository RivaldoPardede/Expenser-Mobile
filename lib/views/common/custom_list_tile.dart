import 'package:final_project/styles/color.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;
  final IconData? trailingIcon;

  const CustomListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    this.trailingIcon,
  }) : super(key: key);

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Leading Icon and Title
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    widget.icon,
                    color: isTapped ? Colors.grey[800] : Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isTapped ? FontWeight.w900 : FontWeight.w500,
                    color: blackPrimary,
                  ),
                ),
              ],
            ),
            // Trailing Text and Icon
            Row(
              children: [
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.value == "Required"
                        ? Colors.red
                        : isTapped ? blackPrimary : Colors.grey[800],
                    fontWeight: isTapped ? FontWeight.w900 : FontWeight.normal
                  ),
                ),
                const SizedBox(width: 8),
                if(widget.trailingIcon == null)
                  const SizedBox.shrink()
                else if(widget.trailingIcon == Icons.chevron_right)
                  Icon(
                    widget.trailingIcon,
                    color: isTapped ? blackPrimary : Colors.grey[600],
                  )
                else
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: blue,
                    child: Icon(
                      widget.trailingIcon,
                      color: white,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
