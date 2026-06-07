import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:flutter/material.dart';

final Alice alice = Alice(
  configuration: AliceConfiguration(
    showNotification: true,
    showInspectorOnShake: true,
    // directionality: TextDirection.ltr,
    showShareButton: true,
  ),
);
