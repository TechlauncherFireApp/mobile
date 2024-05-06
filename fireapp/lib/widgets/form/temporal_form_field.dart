import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Based on InputDatePickerFormField
abstract class TemporalFormField<T> extends StatefulWidget {

  final T? currentValue;
  final Function(T) onValueChanged;
  final InputDecoration? decoration;

  const TemporalFormField({
    super.key,
    required this.currentValue,
    required this.onValueChanged,
    this.decoration
  });

  String formatTime(BuildContext context, T time);
  Future<T?> onTap(BuildContext context);

  @override
  State createState() {
    return _TemporalFormFieldState<T>();
  }
}

class _TemporalFormFieldState<T> extends State<TemporalFormField<T>> {

  final TextEditingController _controller = TextEditingController();
  T? _selectedValue;
  String? _inputText;
  
  @override
  void initState() {
    super.initState();
    _selectedValue = widget.currentValue;
  }

  @override
  void didUpdateWidget(TemporalFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateValueForSelectedTime();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateValueForSelectedTime();
  }
  
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTapCallback(),
      child: TextFormField(
        style: Theme.of(context).textTheme.labelLarge,
        decoration: widget.decoration,
        controller: _controller,
        readOnly: true,
        onTap: () {
          _onTapCallback();
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }

  void _updateValueForSelectedTime() {
    if (_selectedValue != null) {
      _inputText = widget.formatTime(context, _selectedValue!);
      TextEditingValue textEditingValue = TextEditingValue(text: _inputText!);
      textEditingValue = textEditingValue.copyWith(selection: TextSelection(
        baseOffset: 0,
        extentOffset: _inputText!.length,
      ));
      _controller.value = textEditingValue;
    } else {
      _inputText = '';
      _controller.value = TextEditingValue(text: _inputText!);
    }
  }

  Future<void> _onTapCallback() async {
    var value = await widget.onTap(context);
    _selectedValue = value;
    if (value != null) widget.onValueChanged(value);
    _updateValueForSelectedTime();
  }

}
