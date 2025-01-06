import 'package:croppy/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MaterialImageCropperPage extends StatelessWidget {
  const MaterialImageCropperPage({
    super.key,
    required this.controller,
    required this.shouldPopAfterCrop,
    this.gesturePadding = 16.0,
    this.heroTag,
    this.themeData,
    required this.percentageNotifier,
    this.isMobile = true,
  });

  final CroppableImageController controller;
  final double gesturePadding;
  final Object? heroTag;
  final bool shouldPopAfterCrop;
  final ThemeData? themeData;

  final ValueNotifier<int> percentageNotifier;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final theme = themeData ?? generateMaterialImageCropperTheme(context);
    final l10n = CroppyLocalizations.of(context)!;

    return Theme(
      data: theme,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.black,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: CroppableImagePageAnimator(
          controller: controller,
          heroTag: heroTag,
          builder: (context, overlayOpacityAnimation) {
            return Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  l10n.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                automaticallyImplyLeading: false,
                // centerTitle: isDialog ? true : false,
                // actions: [
                //   if (isDialog)
                //     InkWell(
                //       onTap: () => Navigator.pop(context),
                //       child: Container(
                //         padding: const EdgeInsets.all(2),
                //         margin: const EdgeInsets.only(right: 24),
                //         decoration: const BoxDecoration(
                //           color: Colors.grey,
                //           shape: BoxShape.circle,
                //         ),
                //         child: const Icon(
                //           Icons.close,
                //           color: Colors.white,
                //           size: 16,
                //         ),
                //       ),
                //     ),
                // ],
              ),
              body: _buildBody(context, overlayOpacityAnimation),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    Animation<double> overlayOpacityAnimation,
  ) =>
      isMobile
          ? _buildMobileBody(overlayOpacityAnimation)
          : _buildDesktopBody(context, overlayOpacityAnimation);

  Column _buildMobileBody(Animation<double> overlayOpacityAnimation) => Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: _buildEditorWidget(overlayOpacityAnimation),
                    ),
                    MaterialImageCropperToolbar(
                      controller: controller,
                    ),
                  ],
                ),
                _buildLoadingWidget(),
              ],
            ),
          ),
          MaterialImageCropperBottomAppBar(
            controller: controller,
            shouldPopAfterCrop: shouldPopAfterCrop,
            percentageNotifier: percentageNotifier,
          ),
        ],
      );

  Widget _buildDesktopBody(
    BuildContext context,
    Animation<double> overlayOpacityAnimation,
  ) {
    final l10n = CroppyLocalizations.of(context)!;
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              _buildEditorWidget(overlayOpacityAnimation),
              _buildLoadingWidget(),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          decoration: const BoxDecoration(color: Colors.white),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
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
                  flex: 3,
                  child: MaterialImageCropperToolbar(
                    controller: controller,
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 2,
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
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
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
        ),
      ],
    );
  }

  RepaintBoundary _buildEditorWidget(
    Animation<double> overlayOpacityAnimation,
  ) =>
      RepaintBoundary(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: AnimatedCroppableImageViewport(
            controller: controller,
            gesturePadding: gesturePadding,
            overlayOpacityAnimation: overlayOpacityAnimation,
            heroTag: heroTag,
            cropHandlesBuilder: (context) => MaterialImageCropperHandles(
              controller: controller,
              gesturePadding: gesturePadding,
            ),
          ),
        ),
      );

  Widget _buildLoadingWidget() => ValueListenableBuilder<int>(
      valueListenable: percentageNotifier,
      builder: (
        final BuildContext context,
        final int value,
        final Widget? child,
      ) {
        if (value == 0) {
          return const SizedBox.shrink();
        }

        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.black54,
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  '$value%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    shadows: <Shadow>[
                      Shadow(blurRadius: 2, offset: Offset(1, 1)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
