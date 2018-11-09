import 'dart:ui';

import 'package:flutter/material.dart';

var filter = BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
  child: Container(
    decoration: BoxDecoration(color: Colors.black12),
  ),
);
