import 'package:flutter/material.dart';
import 'package:tramatec_app/config/service_locator.dart';
import 'package:tramatec_app/stores/book_store.dart';

class VersionWidget extends StatelessWidget {
  const VersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final BookStore provider = getIt<BookStore>();
    final theme = Theme.of(context);
    return Text("v.${provider.packageInfo?.version}",
        style:
            TextStyle(color: theme.textTheme.labelMedium?.color, fontSize: 12));
  }
}
