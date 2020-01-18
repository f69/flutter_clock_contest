import 'package:flutter/material.dart';

class SliverIndicator extends StatelessWidget {
  SliverIndicator({
    @required this.values,
    @required this.color,
    this.digits,
    this.spacing = 8,
    this.groupSpacing = 32,
    this.digitSpacing = 8,
    this.valueSpacing = 32,
    this.border,
    this.borderRadius,
  });
  final List<int> values;
  final Color color;
  final int digits;
  final double spacing;
  final double groupSpacing;
  final double digitSpacing;
  final double valueSpacing;
  final Border border;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final children = List<Widget>();

    for (int i = 0; i < values.length; i++) {
      final number = SliverNumber(
        value: values[i],
        color: color,
        digits: digits,
        spacing: spacing,
        groupSpacing: groupSpacing,
        digitSpacing: digitSpacing,
        border: border,
        borderRadius: borderRadius,
      );
      if (i > 0) children.add(SizedBox(width: valueSpacing));
      children.add(Expanded(child: number));
    }
    return Row(children: children);
  }
}

class SliverNumber extends StatelessWidget {
  SliverNumber({
    @required this.value,
    @required this.color,
    this.digits,
    this.spacing = 8,
    this.groupSpacing = 32,
    this.digitSpacing = 8,
    this.border,
    this.borderRadius,
  });
  final int value;
  final Color color;
  final int digits;
  final double spacing;
  final double groupSpacing;
  final double digitSpacing;
  final Border border;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    var _digits = digits ?? value.toString().length;
    final children = List<Widget>();

    final _value = value.toString().padLeft(_digits, '0');
    for (int i = 0; i < _digits; i++) {
      final digitValue = int.parse(_value[i]);
      final digit = SliverDigit(
        value: digitValue,
        color: color,
        spacing: spacing,
        groupSpacing: groupSpacing,
        border: border,
        borderRadius: borderRadius,
      );
      if (i > 0) children.add(SizedBox(width: digitSpacing));
      children.add(Expanded(child: digit));
    }
    return Row(children: children);
  }
}

class SliverDigit extends StatelessWidget {
  SliverDigit({
    @required this.value,
    @required this.color,
    this.spacing = 8,
    this.groupSpacing = 32,
    this.border,
    this.borderRadius,
  });
  final int value;
  final Color color;
  final double spacing;
  final double groupSpacing;
  final Border border;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final shadowOpacity =
        Theme.of(context).brightness == Brightness.light ? 0.5 : 0.8;

    final shadow = BoxShadow(
        color: color.withOpacity(shadowOpacity),
        blurRadius: 15,
        spreadRadius: 1);

    final slivers = List<Widget>.generate(9, (i) {
      final slotValue = 9 - i;
      return Expanded(
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: value >= slotValue ? 1 : 0,
          child: Container(
            decoration: BoxDecoration(
              border: border,
              color: color,
              boxShadow: [shadow],
              borderRadius: borderRadius != null
                  ? BorderRadius.circular(borderRadius)
                  : null,
            ),
          ),
        ),
      );
    });

    for (int i = 8; i > 0; i--) {
      slivers.insert(
          i, SizedBox(height: [3, 6].contains(i) ? groupSpacing : spacing));
    }
    return Column(children: slivers);
  }
}
