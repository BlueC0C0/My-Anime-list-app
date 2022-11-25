import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class CustomNumberPicker extends StatefulWidget {
  int _minValue;
  int _maxValue;
  int _initialValue;

  Function _onChange;

  CustomNumberPicker(
      this._minValue, this._maxValue, this._initialValue, this._onChange);

  @override
  _CustomNumberPickerState createState() => _CustomNumberPickerState();
}

class _CustomNumberPickerState extends State<CustomNumberPicker> {
  int currentNbEpisodes;

  @override
  void initState() {
    currentNbEpisodes = widget._initialValue;
    print(widget._minValue);
    print(widget._initialValue);
    print(widget._maxValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Center(
        child: NumberPicker(
          axis: Axis.horizontal,
          haptics: true,
          maxValue: widget._maxValue,
          minValue: 0,
          value: currentNbEpisodes,
          step: 1,
          selectedTextStyle: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700),
          textStyle: TextStyle(
              color: Colors.grey.withOpacity(0.3),
              fontSize: 20,
              fontWeight: FontWeight.w700),
          onChanged: (newValue) {
            setState(() {
              currentNbEpisodes = newValue;
              widget._onChange(newValue);
            });
          },
        ),
      ),
    );
  }
}
