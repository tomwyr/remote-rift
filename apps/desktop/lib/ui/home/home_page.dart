import 'package:flutter/material.dart';

import '../connection/connection_page.dart';
import '../service/service_page.dart';

class const HomePage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ServicePage.builder(startedBuilder: (_) => ConnectionPage.builder());
  }
}
