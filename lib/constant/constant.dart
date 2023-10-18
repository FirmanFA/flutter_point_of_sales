import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

const primaryColor = Color(0xFF1A72DD);

FirebaseFirestore fDb = FirebaseFirestore.instance;

List monthList = [
  'JAN',
  'FEB',
  'MAR',
  'APR',
  'MAY',
  'JUN',
  'JUL',
  'AUG',
  'SEP',
  'OCT',
  'NOV',
  'DEC',
];