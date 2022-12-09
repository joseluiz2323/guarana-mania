import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  final String label;
  final bool obscure;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool? enabled;
  const TextFieldCustom({
    Key? key,
    required this.label,
    this.obscure = false,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        enabled: enabled,
        keyboardType: keyboardType,
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(11.0)),
          ),
          labelText: label,
        ),
        obscureText: obscure,
      ),
    );
  }
}
