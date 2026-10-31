import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../state/app_state.dart';

class WalletViewModel extends ChangeNotifier {
  final AppState appState;

  WalletViewModel({required this.appState}) {
    appState.addListener(_onAppStateChanged);
  }

  void _onAppStateChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    appState.removeListener(_onAppStateChanged);
    super.dispose();
  }

  // Getters
  double get walletBalance => appState.walletBalance;
  bool get isVipMember => appState.isVipMember;
  String get vipTier => appState.vipTier;
  EVVehicle get selectedVehicle => appState.selectedVehicle;
  List<EVVehicle> get garageVehicles => appState.vehicles;
  double get greenCarbonTokens => appState.greenCarbonTokens;
  double get p2pEarnings => appState.p2pEarnings;
  bool get isMitraShieldActive => appState.isMitraShieldActive;
  String get shieldPolicyId => appState.shieldPolicyId;

  // Actions
  void topUpWallet(double amount) {
    appState.topUpWallet(amount);
  }

  void selectVehicle(int index) {
    appState.selectVehicle(index);
  }
}
