import 'package:flutter/material.dart';
import 'package:listify/constants/colors.dart';

class PriorityButton extends StatelessWidget {
  final String priority;
  final Color color;
  final String selectedPriority;
  final Function(String) onPrioritySelected;

  const PriorityButton({
    super.key,
    required this.priority,
    required this.color,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedPriority == priority;

    return Expanded(
      child: InkWell(
        onTap: () {
          onPrioritySelected(priority);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? color : color.withAlpha(50)),
          ),
          alignment: Alignment.center,
          child: Text(
            priority,
            style: TextStyle(
              color: isSelected ? Colors.white : tdBlack,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
