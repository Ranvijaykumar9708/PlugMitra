import 'dart:async';
import 'package:flutter/foundation.dart';
import 'station.dart';
import 'vehicle.dart';

enum SessionStatus { idle, starting, charging, paused, completed }

class ChargingSession extends ChangeNotifier {
  final String id;
  final ChargingStation station;
  final ConnectorInfo connector;
  final EVVehicle vehicle;

  SessionStatus _status = SessionStatus.idle;
  double _currentPercent = 32.0;
  double _targetPercent = 85.0;
  double _energyDeliveredKwh = 0.0;
  double _currentPowerKw = 0.0;
  final double _voltageVolts = 405.0;
  double _currentAmps = 0.0;
  int _elapsedSeconds = 0;
  Timer? _ticker;

  ChargingSession({
    required this.id,
    required this.station,
    required this.connector,
    required this.vehicle,
    double initialPercent = 32.0,
    double targetPercent = 85.0,
  }) {
    _currentPercent = initialPercent;
    _targetPercent = targetPercent;
  }

  SessionStatus get status => _status;
  double get currentPercent => _currentPercent;
  double get targetPercent => _targetPercent;
  double get energyDeliveredKwh => _energyDeliveredKwh;
  double get currentPowerKw => _currentPowerKw;
  double get currentSpeedKw => _currentPowerKw;
  bool get isPaused => _status == SessionStatus.paused;
  double get voltageVolts => _voltageVolts;
  double get currentAmps => _currentAmps;
  int get elapsedSeconds => _elapsedSeconds;

  double get totalCost => _energyDeliveredKwh * station.tariffPerKwh;
  double get co2SavedKg => _energyDeliveredKwh * 0.82; // average coal/fossil factor vs EV

  int get remainingMinutes {
    if (_status != SessionStatus.charging || _currentPowerKw <= 0) return 0;
    final remainingPercent = (_targetPercent - _currentPercent).clamp(0.0, 100.0);
    final neededKwh = (remainingPercent / 100.0) * vehicle.batteryCapacityKwh;
    final hours = neededKwh / _currentPowerKw;
    return (hours * 60).round().clamp(1, 180);
  }

  void setTargetPercent(double value) {
    _targetPercent = value.clamp(_currentPercent, 100.0);
    notifyListeners();
  }

  void startCharging() {
    _status = SessionStatus.starting;
    _currentPowerKw = 0.0;
    notifyListeners();

    // Fast ramp up simulation
    Future.delayed(const Duration(milliseconds: 600), () {
      _status = SessionStatus.charging;
      final maxSpeed = connector.powerKw > vehicle.maxChargingRateKw
          ? vehicle.maxChargingRateKw
          : connector.powerKw;
      _currentPowerKw = maxSpeed * 0.95;
      _currentAmps = (_currentPowerKw * 1000) / _voltageVolts;
      _startTimer();
      notifyListeners();
    });
  }

  void _startTimer() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_status != SessionStatus.charging) return;

      _elapsedSeconds += 1;

      // Realistic charging simulation speed (1 sec simulated as ~30 sec of real charge for awesome portfolio demo)
      final rateKwhPerSec = (_currentPowerKw / 3600.0) * 12.0;
      _energyDeliveredKwh += rateKwhPerSec;

      final addedPercent = (_energyDeliveredKwh / vehicle.batteryCapacityKwh) * 100.0;
      final calculated = vehicle.currentSocPercent + addedPercent;

      if (calculated >= _targetPercent) {
        _currentPercent = _targetPercent;
        _status = SessionStatus.completed;
        _currentPowerKw = 0.0;
        _currentAmps = 0.0;
        _ticker?.cancel();
      } else {
        _currentPercent = calculated;
        // Natural micro-fluctuation in kW (e.g. 48.2 -> 49.1)
        final variation = (timer.tick % 4 == 0 ? 0.4 : -0.2);
        final baseMax = connector.powerKw > vehicle.maxChargingRateKw
            ? vehicle.maxChargingRateKw
            : connector.powerKw;
        _currentPowerKw = (baseMax * 0.96 + variation).clamp(5.0, baseMax);
        _currentAmps = (_currentPowerKw * 1000) / _voltageVolts;
      }

      vehicle.currentSocPercent = _currentPercent;
      notifyListeners();
    });
  }

  void pauseCharging() {
    if (_status == SessionStatus.charging) {
      _status = SessionStatus.paused;
      _currentPowerKw = 0.0;
      _currentAmps = 0.0;
      _ticker?.cancel();
      notifyListeners();
    } else if (_status == SessionStatus.paused) {
      startCharging();
    }
  }

  void resumeCharging() {
    if (_status == SessionStatus.paused) {
      startCharging();
    }
  }

  void stopCharging() {
    _status = SessionStatus.completed;
    _currentPowerKw = 0.0;
    _currentAmps = 0.0;
    _ticker?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

class BookingRecord {
  final String bookingId;
  final String stationName;
  final String stationAddress;
  final String connectorName;
  final String slotTime;
  final String date;
  final String vehicleName;
  final double estimatedCost;
  final String qrToken;
  final bool isCompleted;

  BookingRecord({
    required this.bookingId,
    required this.stationName,
    required this.stationAddress,
    required this.connectorName,
    required this.slotTime,
    required this.date,
    required this.vehicleName,
    required this.estimatedCost,
    required this.qrToken,
    this.isCompleted = false,
  });
}
