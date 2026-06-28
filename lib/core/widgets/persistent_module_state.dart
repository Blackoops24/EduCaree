import 'dart:async';

import 'package:educare/core/services/module_persistence_service.dart';
import 'package:flutter/material.dart';

abstract class PersistentModuleState<T extends StatefulWidget> extends State<T> {
  String get moduleKey;
  Map<String, dynamic> exportState();
  void importState(Map<String, dynamic> data);

  Timer? _saveTimer;
  bool _hydrated = false;

  @override
  void initState() {
    super.initState();
    unawaited(_hydrate());
  }

  Future<void> _hydrate() async {
    try {
      final data = await ModulePersistenceService.instance.load(moduleKey);
      if (!mounted) return;
      if (data != null) {
        super.setState(() => importState(data));
      }
      _hydrated = true;
      if (data == null) unawaited(_save());
    } catch (_) {
      _hydrated = true;
    }
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if (!_hydrated) return;
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 300), () => unawaited(_save()));
  }

  Future<void> _save() async {
    try {
      await ModulePersistenceService.instance.save(moduleKey, exportState());
    } catch (_) {
      // The UI remains usable offline; the next mutation retries persistence.
    }
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    super.dispose();
  }
}
