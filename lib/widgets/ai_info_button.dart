import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../core/localization/app_localizations.dart';

class AiInfoButton extends StatelessWidget {
  const AiInfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(IconlyLight.info_square),
      onPressed: () {
        final loc = AppLocalizations.of(context);
        showModalBottomSheet(
          context: context,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          builder: (context) => Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              loc.translate('ai_info_placeholder'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        );
      },
    );
  }
}
