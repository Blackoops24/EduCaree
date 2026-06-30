import 'package:educare/core/widgets/app_flash_message.dart';
import 'package:flutter/material.dart';

void showManagementDrawer({
  required BuildContext context,
  required GlobalKey anchorKey,
  required String drawerKey,
  required String title,
  required String submitLabel,
  required int totalRecords,
  required Widget Function(BuildContext, StateSetter) contentBuilder,
  required Future<bool> Function(BuildContext) onSubmit,
  required String successMessage,
  required AppFlashType successType,
}) {
  final renderObject =
      anchorKey.currentContext?.findRenderObject() ??
      context.findRenderObject();
  final contentRect = renderObject is RenderBox
      ? renderObject.localToGlobal(Offset.zero) & renderObject.size
      : Offset.zero & MediaQuery.sizeOf(context);

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close $title',
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 280),
    transitionBuilder: (context, animation, secondaryAnimation, child) => child,
    pageBuilder: (dialogContext, animation, secondaryAnimation) =>
        StatefulBuilder(
          builder: (context, setDrawerState) {
            final width = contentRect.width < 900
                ? contentRect.width
                : contentRect.width * 0.52;
            final panelAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return Stack(
              children: [
                Positioned(
                  left: contentRect.left,
                  top: contentRect.top,
                  width: width,
                  height: contentRect.height,
                  child: ClipRect(
                    child: AnimatedBuilder(
                      animation: panelAnimation,
                      builder: (context, child) => Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: panelAnimation.value,
                        child: child,
                      ),
                      child: Material(
                        key: Key(drawerKey),
                        elevation: 24,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Scaffold(
                          appBar: AppBar(
                            automaticallyImplyLeading: false,
                            title: Text(title),
                            actions: [
                              IconButton(
                                tooltip: 'Close',
                                onPressed: () => Navigator.pop(dialogContext),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          body: ListView(
                            padding: const EdgeInsets.all(24),
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Total records: $totalRecords',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              contentBuilder(context, setDrawerState),
                              const SizedBox(height: 24),
                            ],
                          ),
                          bottomNavigationBar: Material(
                            elevation: 12,
                            child: SafeArea(
                              top: false,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton(
                                      key: Key('${drawerKey}_cancel'),
                                      onPressed: () =>
                                          Navigator.pop(dialogContext),
                                      child: const Text('Cancel'),
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton.icon(
                                      key: Key('${drawerKey}_submit'),
                                      onPressed: () async {
                                        if (!await onSubmit(dialogContext)) {
                                          return;
                                        }
                                        if (!dialogContext.mounted) return;
                                        Navigator.pop(dialogContext);
                                        showAppFlashMessage(
                                          context,
                                          message: successMessage,
                                          type: successType,
                                        );
                                      },
                                      icon: Icon(
                                        submitLabel == 'Create'
                                            ? Icons.add
                                            : Icons.save_outlined,
                                      ),
                                      label: Text(submitLabel),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
  );
}
