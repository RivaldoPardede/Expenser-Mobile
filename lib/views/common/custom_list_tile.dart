import 'package:final_project/styles/color.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatefulWidget {
  final Widget icon;
  final String title;
  final String value;
  final bool needCircleAvatar;
  final VoidCallback onTap;
  final IconData? trailingIcon;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.needCircleAvatar,
    required this.onTap,
    this.trailingIcon,
  });

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
            // Trailing Text and Icon
            Row(
              children: [
                Container(
                  width: 130,
                  child: Text(
                    widget.value,
                    maxLines: 1,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.value == "Required"
                          ? Colors.red
                          : isTapped ? blackPrimary : Colors.grey[800],
                      fontWeight: isTapped ? FontWeight.w700 : FontWeight.normal
                    ),
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
