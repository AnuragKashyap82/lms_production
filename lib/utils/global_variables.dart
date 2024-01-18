
import 'package:eduventure/screens/post_msg_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const webScreenSize = 600;

showSnackBar(String content, BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content),),);
}
