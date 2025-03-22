import 'package:flutter/material.dart';

const Color tdRed = Color(0XFFDA4040);
const Color tdBlue = Color.fromARGB(255, 77, 125, 230);

const Color tdBlack = Color(0xff3A3A3A);
const Color tdGrey = Color(0xff717171);

const Color tdBGColor = Color(0xffEEEFF5);

// Priority Colors
const Color tdHighPriority = Color(0xFFE57373); // Red for high priority
const Color tdMediumPriority = Color(0XFFceae44); // Yellow for medium priority
const Color tdLowPriority = Color(0xFF81C784); // Green for low priority

// Priority color mapping
Map<String, Color> priorityColors = {
  'High': tdHighPriority,
  'Medium': tdMediumPriority,
  'Low': tdLowPriority,
};
