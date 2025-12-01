
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecotrack/models/user.dart';
import 'package:ecotrack/screens/home/home_screen.dart';
import 'package:ecotrack/screens/authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    // return either Home or Authenticate widget
    if (user == null) {
      return const Authenticate();
    } else {
      return HomeScreen(); // Removed 'const' here
    }
  }
}
