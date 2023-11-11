import 'package:flutter/material.dart';

const List<String> lesson = [
  //w1
  '英文',
  '國文',
  '多元選修',
  '多元選修',
  '體育',
  '生科',
  '生科',
  //w2
  '地理',
  '國文',
  '國文',
  '本土語言',
  '英文',
  '英文 ',
  '歷史',
  //w3
  '地科',
  '地科',
  '數學',
  '數學',
  '生涯規劃',
  '自主學習',
  '自主學習',
  //w4
  '美術',
  '美術',
  '音樂',
  '體育',
  '數學',
  '英文',
  '地理',
  //w5
  '數學',
  '國文',
  '化學',
  '化學',
  '歷史',
  '班會',
  '社團'
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

List<int> numbersOfClass = List.generate(36, (idx) => idx + 1);
