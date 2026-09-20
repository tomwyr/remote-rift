import 'package:flutter/material.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../mcp/mcp_footer_status.dart';

class const AppFooter() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .fromLTRB(12, 8, 12, 12),
      child: SizedBox(
        width: .infinity,
        child: Stack(
          alignment: .center,
          children: [
            const AppVersion(),
            const Align(
              alignment: .centerRight,
              child: McpFooterStatus(),
            ),
          ],
        ),
      ),
    );
  }
}
