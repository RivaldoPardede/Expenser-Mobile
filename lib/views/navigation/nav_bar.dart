import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: BottomAppBar(
        elevation: 0.0,
        color: Colors.transparent,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                navItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  isSelected: pageIndex == 0,
                  label: 'Home',
                  onTap: () => onTap(0),
                ),
                navItem(
                  icon: Icons.bar_chart_outlined,
                  selectedIcon: Icons.bar_chart,
                  isSelected: pageIndex == 1,
                  label: 'Statistic',
                  onTap: () => onTap(1),
                ),
                const SizedBox(width: 80),
                navItem(
                  icon: Icons.access_time_outlined,
                  selectedIcon: Icons.access_time,
                  isSelected: pageIndex == 3,
                  label: 'History',
                  onTap: () => onTap(3),
                ),
                navItem(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
                  isSelected: pageIndex == 4,
                  label: 'Settings',
                  onTap: () => onTap(4),
                ),
              ],
          ),
        ),
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required IconData selectedIcon,
    required bool isSelected,
    required String label,
    Function()? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? const Color(0xFF5B9EE1) : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF5B9EE1) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
