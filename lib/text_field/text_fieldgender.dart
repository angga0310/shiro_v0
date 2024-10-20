import 'package:flutter/material.dart';

class GenderDropdown extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final String? selectedGender;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const GenderDropdown({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    required this.selectedGender,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedGender,
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          prefixIcon,
          color: const Color(0xFF384B70),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF384B70),
          fontSize: 15,
          fontFamily: 'Lexend',
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Color(0xFF384B70),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xFF384B70),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: const [
        DropdownMenuItem(
          value: 'Laki-Laki',
          child: Text('Laki Laki'),
        ),
        DropdownMenuItem(
          value: 'Perempuan',
          child: Text('Perempuan'),
        ),
      ],
    );
  }
}
