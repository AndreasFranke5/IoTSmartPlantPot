import 'package:flutter/material.dart';

class ChipRounded extends StatelessWidget {
  const ChipRounded({super.key, required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding:const EdgeInsets.symmetric(horizontal: 20) ,
      label: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
      color: WidgetStateProperty.resolveWith(
        (states) {
          if (isSelected) return Theme.of(context).colorScheme.primary;
          return Colors.grey.withOpacity(.1);
        },
      ),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.white, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
    );
  }
}
