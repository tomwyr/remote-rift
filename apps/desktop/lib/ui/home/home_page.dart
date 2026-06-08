import 'package:flutter/material.dart';

import '../connection/connection_page.dart';
import '../service/service_page.dart';
import '../update/update_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ServicePage.builder(
          startedBuilder: (context) => ConnectionPage.builder(),
        ),
        Align(
          alignment: .topRight,
          child: Padding(
            padding: const .all(12),
            child: UpdateButton.builder(),
          ),
        ),
      ],
    );
  }
}
