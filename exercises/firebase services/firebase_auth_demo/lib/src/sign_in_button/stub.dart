import 'dart:async';

import 'package:flutter/material.dart';

///the type of the onClick callback for the (mobile) sign in button
typedef HandleSignInFn = Future<void> Function();


///renders a SIGN IN button that (maybe) calls the 'handleSignIn' onclick
Widget buildSignInButton({HandleSignInFn? onPressed}){
  return Container();
}