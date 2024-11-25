import 'package:final_project/styles/color.dart';
import 'package:flutter/material.dart';

class ModalToggleSelector extends StatelessWidget {
  final String selectedOption;
  final List<String> options;
  final ValueChanged<String> onOptionSelected;

  const ModalToggleSelector({
    super.key,
    required this.selectedOption,
    required this.options,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(56),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: options.map((option) {
          final isSelected = selectedOption == option;
          return GestureDetector(
            onTap: () => onOptionSelected(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? blackPrimary : Colors.transparent,
                borderRadius: BorderRadius.circular(56),
              ),
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected ? white : blackPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
