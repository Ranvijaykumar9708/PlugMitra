enum VehicleCategory {
  twoWheeler,
  threeWheeler,
  fourWheeler,
  commercialTruck,
  electricBus,
}

extension VehicleCategoryExtension on VehicleCategory {
  String get displayName {
    switch (this) {
      case VehicleCategory.twoWheeler:
        return '2-Wheeler (Scooter/Bike)';
      case VehicleCategory.threeWheeler:
        return '3-Wheeler (Auto/Cargo)';
      case VehicleCategory.fourWheeler:
        return 'Electric Car / SUV';
      case VehicleCategory.commercialTruck:
        return 'Commercial EV Truck / Van';
      case VehicleCategory.electricBus:
        return 'Electric Bus / Heavy Fleet';
    }
  }

  String get shortLabel {
    switch (this) {
      case VehicleCategory.twoWheeler:
        return '🛵 2-Wheeler';
      case VehicleCategory.threeWheeler:
        return '🛺 3-Wheeler';
      case VehicleCategory.fourWheeler:
        return '🚗 Car / SUV';
      case VehicleCategory.commercialTruck:
        return '🚚 Truck / Van';
      case VehicleCategory.electricBus:
        return '🚌 Bus / Heavy';
    }
  }
}

class EVVehicle {
  final String id;
  final String make;
  final String model;
  final String registrationNumber;
  final VehicleCategory category;
  final double batteryCapacityKwh;
  final double maxChargingRateKw;
  final String connectorType;
  double currentSocPercent; // State of Charge (e.g. 34.0%)
  final double rangeKm;
  final String imageType; // 'scooter', 'threeWheeler', 'car', 'truck', 'bus'

  EVVehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.registrationNumber,
    required this.category,
    required this.batteryCapacityKwh,
    required this.maxChargingRateKw,
    required this.connectorType,
    required this.currentSocPercent,
    required this.rangeKm,
    required this.imageType,
  });

  String get fullName => '$make $model';
  String get name => fullName;

  double get estimatedRemainingRangeKm {
    return (currentSocPercent / 100.0) * rangeKm;
  }

  static List<EVVehicle> defaultGarage = [
    // 🚗 4-Wheeler Car / SUV
    EVVehicle(
      id: 'v1',
      make: 'Tata',
      model: 'Nexon EV Long Range',
      registrationNumber: 'DL 01 EV 8899',
      category: VehicleCategory.fourWheeler,
      batteryCapacityKwh: 40.5,
      maxChargingRateKw: 50.0,
      connectorType: 'CCS-2',
      currentSocPercent: 34.0,
      rangeKm: 465,
      imageType: 'car',
    ),
    // 🛵 2-Wheeler (Scooter)
    EVVehicle(
      id: 'v2',
      make: 'Ather',
      model: '450X Apex',
      registrationNumber: 'KA 05 EV 1234',
      category: VehicleCategory.twoWheeler,
      batteryCapacityKwh: 3.7,
      maxChargingRateKw: 3.3,
      connectorType: 'Ather Dot / Type-6',
      currentSocPercent: 62.0,
      rangeKm: 157,
      imageType: 'scooter',
    ),
    // 🛵 2-Wheeler (Ola Scooter)
    EVVehicle(
      id: 'v3',
      make: 'Ola',
      model: 'S1 Pro Gen 2',
      registrationNumber: 'MH 12 EV 9090',
      category: VehicleCategory.twoWheeler,
      batteryCapacityKwh: 4.0,
      maxChargingRateKw: 3.0,
      connectorType: 'Ola Hypercharger / 16A',
      currentSocPercent: 48.0,
      rangeKm: 195,
      imageType: 'scooter',
    ),
    // 🛺 3-Wheeler (Auto / Cargo)
    EVVehicle(
      id: 'v4',
      make: 'Mahindra',
      model: 'Treo Electric Auto',
      registrationNumber: 'UP 16 EV 3321',
      category: VehicleCategory.threeWheeler,
      batteryCapacityKwh: 7.37,
      maxChargingRateKw: 3.7,
      connectorType: 'Bharat AC-001 / 16A',
      currentSocPercent: 55.0,
      rangeKm: 130,
      imageType: 'threeWheeler',
    ),
    // 🚚 Commercial Truck (Mini / Logistics)
    EVVehicle(
      id: 'v5',
      make: 'Tata',
      model: 'Ace EV Commercial',
      registrationNumber: 'HR 26 EV 5544',
      category: VehicleCategory.commercialTruck,
      batteryCapacityKwh: 21.3,
      maxChargingRateKw: 22.0,
      connectorType: 'CCS-2 Fast',
      currentSocPercent: 28.0,
      rangeKm: 154,
      imageType: 'truck',
    ),
    // 🚛 Heavy Commercial Truck / Fleet
    EVVehicle(
      id: 'v6',
      make: 'Tata',
      model: 'Ultra T.7 Electric Truck',
      registrationNumber: 'DL 04 EV 7700',
      category: VehicleCategory.commercialTruck,
      batteryCapacityKwh: 62.5,
      maxChargingRateKw: 120.0,
      connectorType: 'CCS-2 Heavy DC',
      currentSocPercent: 41.0,
      rangeKm: 220,
      imageType: 'truck',
    ),
  ];
}
