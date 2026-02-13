import 'package:flutter/services.dart';

class InputFormatters {
  static List<TextInputFormatter> phone() => [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
        LengthLimitingTextInputFormatter(16),
      ];
}
