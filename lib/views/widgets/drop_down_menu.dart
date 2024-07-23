import 'package:flutter/material.dart';

class DropDownMenuComponent extends StatelessWidget {
  final void Function(String? value) onChanged;
  final List<String> items;
  final String hint;
  final Icon icon;


  const DropDownMenuComponent({
    super.key,
    required this.onChanged,
    required this.items,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: null,
      icon: const Icon(Icons.arrow_drop_down),
      isExpanded: true,
      elevation: 16,
      style: Theme.of(context).textTheme.titleMedium,
      hint: FittedBox(
        child: Text(
          hint,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      onChanged: onChanged,
      dropdownColor: Colors.white,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}