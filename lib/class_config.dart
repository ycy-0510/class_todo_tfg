import 'package:flutter/material.dart';

const List<String> lesson = [
  //w1
  '資訊',
  '資訊',
  '英文',
  '體育',
  '本土',
  '公民',
  '公民',
  //w2
  '英文',
  '英文',
  '國文',
  '國文',
  '班會',
  '歷史',
  '歷史',
  //w3
  '數學',
  '數學',
  '探究實作',
  '探究實作',
  '英文',
  '地理',
  '地理',
  //w4
  '數學',
  '數學',
  '第二外語',
  '體育',
  '生命教育',
  '專題寫作',
  '專題寫作',
  //w5
  '國文',
  '國文',
  '彈性學習',
  '彈性學習',
  '社團',
  '地科',
  '地科'
];

const List<TimeOfDay> classTimes = [
  TimeOfDay(hour: 8, minute: 10),
  TimeOfDay(hour: 9, minute: 10),
  TimeOfDay(hour: 10, minute: 10),
  TimeOfDay(hour: 11, minute: 10),
  //rest
  TimeOfDay(hour: 13, minute: 0),
  TimeOfDay(hour: 14, minute: 0),
  TimeOfDay(hour: 15, minute: 10),
  TimeOfDay(hour: 16, minute: 10),
];

List<int> numbersOfClass = List.generate(37, (idx) => idx + 1);
