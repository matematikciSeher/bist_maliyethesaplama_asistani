import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

import '../services/app_update_service.dart';

/// Uygulama açılışında ve ön plana döndüğünde güncellemeyi kontrol eder.
class AppUpdateGate extends StatefulWidget {
  const AppUpdateGate({super.key, required this.child});

  final Widget child;

  @override
  State<AppUpdateGate> createState() => _AppUpdateGateState();
}

class _AppUpdateGateState extends State<AppUpdateGate>
    with WidgetsBindingObserver {
  StreamSubscription<InstallStatus>? _updateSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateSubscription = AppUpdateService.listenForDownload(_onInstallStatus);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForUpdate());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _updateSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkForUpdate();
    }
  }

  void _onInstallStatus(InstallStatus status) {
    if (status == InstallStatus.downloaded && mounted) {
      AppUpdateService.showRestartDialog(context);
    }
  }

  Future<void> _checkForUpdate() async {
    if (!mounted) return;
    await AppUpdateService.checkAndPrompt(context);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
