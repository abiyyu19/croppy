import 'package:flutter/material.dart';

import 'package:croppy/src/src.dart';

class MaterialImageCropperBottomAppBar extends StatelessWidget {
  const MaterialImageCropperBottomAppBar({
    super.key,
    required this.controller,
    required this.shouldPopAfterCrop,
    required this.percentageNotifier,
  });

  final CroppableImageController controller;
  final bool shouldPopAfterCrop;
  final ValueNotifier<int> percentageNotifier;

  @override
  Widget build(BuildContext context) {
    final l10n = CroppyLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: Divider.createBorderSide(context),
        ),
      ),
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 24.0,
        right: 24.0,
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        minimum: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: SizedBox(
                height: 48.0,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () => Navigator.maybePop(context),
                  child: Text(
                    l10n.cancelLabel.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 6,
              child: SizedBox(
                height: 48.0,
                child: FutureButton(
                  onTap: () async {
                    CroppableImagePageAnimator.of(context)
                        ?.setHeroesEnabled(true);

                    final result = await controller.crop();

                    final bool isPercentageValid =
                        percentageNotifier.value == 0 ||
                            percentageNotifier.value == 100;

                    if (context.mounted &&
                        shouldPopAfterCrop &&
                        isPercentageValid) {
                      Navigator.of(context).pop(result);
                    }
                  },
                  builder: (context, onTap) => FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onTap,
                    child: Text(
                      l10n.saveLabel.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
