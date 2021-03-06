// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliver_clock/sliver_indicator.dart';

enum _Element {
  background,
  text,
}

final _lightTheme = {
  _Element.background: Color(0xFFF0F0F0),
  _Element.text: Color(0xFF0000D0),
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Color(0xFF10D0FF),
};

class SliverClock extends StatefulWidget {
  const SliverClock(this.model);

  final ClockModel model;

  @override
  _SliverClockState createState() => _SliverClockState();
}

class _SliverClockState extends State<SliverClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(SliverClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
//      _timer = Timer(
//        Duration(minutes: 1) -
//            Duration(seconds: _dateTime.second) -
//            Duration(milliseconds: _dateTime.millisecond),
//        _updateTime,
//      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hourFormat = widget.model.is24HourFormat ? 'HH' : 'hh';
    final hour = int.parse(DateFormat(hourFormat).format(_dateTime));
    final minute = int.parse(DateFormat('mm').format(_dateTime));
    final second = int.parse(DateFormat('ss').format(_dateTime));

    return Container(
      color: colors[_Element.background],
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(32),
            child: SliverIndicator(
              values: [hour, minute, second],
              color: colors[_Element.text],
              digits: 2,
              spacing: 14,
              digitSpacing: 16,
              valueSpacing: 40,
              borderRadius: 100,
            ),
          ),
        ],
      ),
    );
  }
}
