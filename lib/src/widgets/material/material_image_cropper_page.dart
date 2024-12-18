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
    this.isDialog = false,
  });

  final CroppableImageController controller;
  final double gesturePadding;
  final Object? heroTag;
  final bool shouldPopAfterCrop;
  final ThemeData? themeData;
  final bool isDialog;

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
                centerTitle: isDialog ? true : false,
                actions: [
                  if (isDialog)
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.only(right: 24),
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: RepaintBoundary(
                        child: Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: AnimatedCroppableImageViewport(
                            controller: controller,
                            gesturePadding: gesturePadding,
                            overlayOpacityAnimation: overlayOpacityAnimation,
                            heroTag: heroTag,
                            cropHandlesBuilder: (context) =>
                                MaterialImageCropperHandles(
                              controller: controller,
                              gesturePadding: gesturePadding,
                            ),
                          ),
                        ),
                      ),
                    ),
                    MaterialImageCropperToolbar(
                      controller: controller,
                    ),
                    MaterialImageCropperBottomAppBar(
                      controller: controller,
                      shouldPopAfterCrop: shouldPopAfterCrop,
                    ),

                    // RepaintBoundary(
                    //   child: AnimatedBuilder(
                    //     animation: overlayOpacityAnimation,
                    //     builder: (context, _) => Opacity(
                    //       opacity: overlayOpacityAnimation.value,
                    //       child: MaterialImageCropperToolbar(
                    //         controller: controller,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // AnimatedBuilder(
                    //   animation: overlayOpacityAnimation,
                    //   builder: (context, _) => Opacity(
                    //     opacity: overlayOpacityAnimation.value,
                    //     child: MaterialImageCropperBottomAppBar(
                    //       controller: controller,
                    //       shouldPopAfterCrop: shouldPopAfterCrop,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
