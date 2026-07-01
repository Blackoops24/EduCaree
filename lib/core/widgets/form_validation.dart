import 'package:flutter/material.dart';

/// Validates a form and moves the user directly to its first invalid field.
bool validateAndFocusFirstInvalid(GlobalKey<FormState> formKey) {
  final isValid = formKey.currentState?.validate() ?? false;
  if (isValid) return true;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final formContext = formKey.currentContext;
    if (formContext == null || !formContext.mounted) return;

    Element? invalidElement;

    void findInvalid(Element element) {
      if (invalidElement != null) return;
      if (element is StatefulElement &&
          element.state is FormFieldState &&
          (element.state as FormFieldState).hasError) {
        invalidElement = element;
        return;
      }
      element.visitChildren(findInvalid);
    }

    (formContext as Element).visitChildren(findInvalid);
    final target = invalidElement;
    if (target == null || !target.mounted) return;

    FocusNode? focusNode;

    void findFocusNode(Element element) {
      if (focusNode != null) return;
      final widget = element.widget;
      if (widget is EditableText && widget.focusNode.canRequestFocus) {
        focusNode = widget.focusNode;
        return;
      }
      if (widget is Focus &&
          widget.focusNode != null &&
          widget.focusNode!.canRequestFocus) {
        focusNode = widget.focusNode;
        return;
      }
      element.visitChildren(findFocusNode);
    }

    target.visitChildren(findFocusNode);
    focusNode?.requestFocus();
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      alignment: 0.2,
    );
  });

  return false;
}

/// Focuses and reveals a controller-backed field in the active route/dialog.
void focusAndRevealController(
  BuildContext context,
  TextEditingController controller,
) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    final overlayContext = Navigator.maybeOf(context)?.overlay?.context;
    if (overlayContext == null || !overlayContext.mounted) return;

    Element? target;

    void findEditable(Element element) {
      if (target != null) return;
      final widget = element.widget;
      if (widget is EditableText && identical(widget.controller, controller)) {
        target = element;
        widget.focusNode.requestFocus();
        return;
      }
      element.visitChildren(findEditable);
    }

    (overlayContext as Element).visitChildren(findEditable);
    final field = target;
    if (field == null || !field.mounted) return;
    Scrollable.ensureVisible(
      field,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      alignment: 0.2,
    );
  });
}
