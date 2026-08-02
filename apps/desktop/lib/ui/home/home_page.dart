import 'package:flutter/material.dart';

import '../connection/connection_page.dart';
import '../service/service_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ServicePage.builder(startedBuilder: (_) => ConnectionPage.builder());
  }
}
