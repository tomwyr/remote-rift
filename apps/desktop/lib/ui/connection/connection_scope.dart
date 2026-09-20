import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependencies.dart';

class const ConnectionScope({super.key, required final Widget child}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: Dependencies.connectionCubit,
      child: child,
    );
  }
}
