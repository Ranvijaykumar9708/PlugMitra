import 'vehicle.dart';

class ConnectorInfo {
  final String id;
  final String name; // e.g. "CCS-2 Gun A", "Type-2 AC", "Heavy Truck DC", "2W Ather Dot"
  final String type; // "CCS-2", "Type-2", "CHAdeMO", "GB/T", "16A Industrial", "Ather Dot"
  final double powerKw;
  final bool isAvailable;
  final String currentStatus; // "Available", "Charging", "Reserved", "Offline"
  final List<VehicleCategory> compatibleCategories;

  const ConnectorInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.powerKw,
    required this.isAvailable,
    required this.currentStatus,
    this.compatibleCategories = const [
      VehicleCategory.fourWheeler,
      VehicleCategory.twoWheeler,
      VehicleCategory.threeWheeler,
      VehicleCategory.commercialTruck,
    ],
  });
}

class ChargingStation {
  final String id;
  final String name;
  final String operator; // "PlugMitra Official Network", "Tata Power EZ", "Jio-bp Pulse", etc.
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final double rating;
  final int totalReviews;
  final double tariffPerKwh; // in INR
  final List<ConnectorInfo> connectors;
  final List<String> amenities; // "Café", "Restroom", "24/7 Security", "WiFi", "Truck Bay"
  final List<VehicleCategory> supportedCategories;
  final bool isOpen24x7;
  final bool isVerified;
  final bool isFastCharger;
  final bool hasHeavyTruckBay;
  final bool isPlugMitraOwned; // True for our own stations
  final int memberDiscountPercent; // E.g. 15% discount for PlugMitra users
  final bool hasPlugAndCharge; // Auto-handshake without manual verification

  const ChargingStation({
    required this.id,
    required this.name,
    required this.operator,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.rating,
    required this.totalReviews,
    required this.tariffPerKwh,
    required this.connectors,
    required this.amenities,
    required this.supportedCategories,
    this.isOpen24x7 = true,
    this.isVerified = true,
    this.isFastCharger = true,
    this.hasHeavyTruckBay = false,
    this.isPlugMitraOwned = false,
    this.memberDiscountPercent = 0,
    this.hasPlugAndCharge = false,
  });

  int get availablePorts => connectors.where((c) => c.isAvailable).length;
  int get totalPorts => connectors.length;

  double get maxSpeedKw {
    if (connectors.isEmpty) return 0;
    return connectors.map((c) => c.powerKw).reduce((a, b) => a > b ? a : b);
  }

  double get effectiveMemberTariff {
    if (!isPlugMitraOwned || memberDiscountPercent == 0) return tariffPerKwh;
    return tariffPerKwh * (1.0 - (memberDiscountPercent / 100.0));
  }

  bool supportsCategory(VehicleCategory category) {
    return supportedCategories.contains(category);
  }

  static List<ChargingStation> sampleStations = [
    // 🌟 1. GreenCharge Station (Primary Station from user's UI/UX Board)
    ChargingStation(
      id: 'pm-gc',
      name: 'GreenCharge Station',
      operator: 'PlugMitra Official Hub',
      address: 'Sector 62',
      city: 'Noida, Uttar Pradesh',
      latitude: 28.6280,
      longitude: 77.3649,
      distanceKm: 1.2,
      rating: 4.6,
      totalReviews: 120,
      tariffPerKwh: 18.0,
      isPlugMitraOwned: true,
      memberDiscountPercent: 15,
      hasPlugAndCharge: true,
      isOpen24x7: true,
      isVerified: true,
      isFastCharger: true,
      hasHeavyTruckBay: false,
      amenities: ['Restroom', 'Cafe', 'Parking', 'Wi-Fi'],
      supportedCategories: [
        VehicleCategory.fourWheeler,
        VehicleCategory.twoWheeler,
        VehicleCategory.threeWheeler,
      ],
      connectors: [
        ConnectorInfo(
          id: 'gc-1',
          name: 'DC Fast Charger',
          type: 'CCS2',
          powerKw: 60,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.fourWheeler],
        ),
        ConnectorInfo(
          id: 'gc-2',
          name: 'AC Charger',
          type: 'Type 2',
          powerKw: 22,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.fourWheeler, VehicleCategory.twoWheeler],
        ),
      ],
    ),

    // 🌟 2. ChargePoint Hub (Matching Screen 7)
    ChargingStation(
      id: 'pm-cp',
      name: 'ChargePoint Hub',
      operator: 'PlugMitra Partner',
      address: 'Sector 18 Commercial Hub',
      city: 'Noida',
      latitude: 28.5708,
      longitude: 77.3271,
      distanceKm: 2.5,
      rating: 4.7,
      totalReviews: 95,
      tariffPerKwh: 16.0,
      isPlugMitraOwned: false,
      isOpen24x7: true,
      isVerified: true,
      isFastCharger: true,
      amenities: ['Parking', 'Restroom', 'Wi-Fi', 'Coffee'],
      supportedCategories: [
        VehicleCategory.fourWheeler,
        VehicleCategory.twoWheeler,
      ],
      connectors: [
        ConnectorInfo(
          id: 'cp-1',
          name: 'Dual DC Fast Gun',
          type: 'CCS2',
          powerKw: 50,
          isAvailable: true,
          currentStatus: 'Available',
        ),
        ConnectorInfo(
          id: 'cp-2',
          name: 'AC Standard Gun',
          type: 'Type 2',
          powerKw: 22,
          isAvailable: true,
          currentStatus: 'Available',
        ),
      ],
    ),

    // 🌟 3. EV Power Zone (Matching Screen 7)
    ChargingStation(
      id: 'pm-pz',
      name: 'EV Power Zone',
      operator: 'PlugMitra Hub',
      address: 'Near Expressway Roundabout',
      city: 'Greater Noida',
      latitude: 28.4744,
      longitude: 77.5040,
      distanceKm: 4.1,
      rating: 4.8,
      totalReviews: 210,
      tariffPerKwh: 20.0,
      isPlugMitraOwned: true,
      memberDiscountPercent: 15,
      isOpen24x7: true,
      isVerified: true,
      isFastCharger: true,
      amenities: ['EV Lounge', 'Restroom', 'Wi-Fi', 'Fast Food'],
      supportedCategories: [
        VehicleCategory.fourWheeler,
        VehicleCategory.twoWheeler,
        VehicleCategory.commercialTruck,
      ],
      connectors: [
        ConnectorInfo(
          id: 'pz-1',
          name: 'Ultra Fast Gun',
          type: 'CCS2',
          powerKw: 120,
          isAvailable: true,
          currentStatus: 'Available',
        ),
      ],
    ),

    // 🌟 4. ElectroSpot (Matching Screen 7)
    ChargingStation(
      id: 'pm-es',
      name: 'ElectroSpot',
      operator: 'PlugMitra Green',
      address: 'Cyber Park Crossing',
      city: 'Gurugram',
      latitude: 28.4595,
      longitude: 77.0266,
      distanceKm: 5.3,
      rating: 4.5,
      totalReviews: 78,
      tariffPerKwh: 15.0,
      isPlugMitraOwned: false,
      isOpen24x7: true,
      isVerified: true,
      isFastCharger: false,
      amenities: ['Mall Parking', 'Restroom', 'Wi-Fi'],
      supportedCategories: [
        VehicleCategory.fourWheeler,
        VehicleCategory.twoWheeler,
      ],
      connectors: [
        ConnectorInfo(
          id: 'es-1',
          name: 'AC Smart Gun',
          type: 'Type 2',
          powerKw: 22,
          isAvailable: true,
          currentStatus: 'Available',
        ),
      ],
    ),

    // 🌟 5. PlugMitra Official Flagship SuperHub (Gurugram)
    ChargingStation(
      id: 'pm-01',
      name: 'PlugMitra SuperHub DLF Cyber City',
      operator: 'PlugMitra Official Network',
      address: 'DLF Cyber City, Building 10, Sector 24',
      city: 'Gurugram',
      latitude: 28.4952,
      longitude: 77.0891,
      distanceKm: 0.9,
      rating: 4.9,
      totalReviews: 890,
      tariffPerKwh: 18.0,
      isPlugMitraOwned: true,
      memberDiscountPercent: 15,
      hasPlugAndCharge: true,
      isOpen24x7: true,
      isVerified: true,
      isFastCharger: true,
      hasHeavyTruckBay: false,
      amenities: ['100% Solar Canopy', 'PlugMitra Lounge', 'Clean Café', 'Restroom', 'WiFi', 'Auto-Plug & Charge'],
      supportedCategories: [
        VehicleCategory.fourWheeler,
        VehicleCategory.twoWheeler,
        VehicleCategory.threeWheeler,
        VehicleCategory.commercialTruck,
      ],
      connectors: [
        ConnectorInfo(
          id: 'c1',
          name: 'Hyper Gun 1 (CCS-2)',
          type: 'CCS-2',
          powerKw: 180,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.fourWheeler, VehicleCategory.commercialTruck],
        ),
        ConnectorInfo(
          id: 'c2',
          name: 'Fast Gun 2 (CCS-2)',
          type: 'CCS-2',
          powerKw: 120,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.fourWheeler, VehicleCategory.commercialTruck],
        ),
        ConnectorInfo(
          id: 'c3',
          name: '2W Fast Point (Ather/Type-6)',
          type: 'Ather Dot/Type-6',
          powerKw: 3.3,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.twoWheeler],
        ),
        ConnectorInfo(
          id: 'c4',
          name: '3W Auto Bay (16A)',
          type: '16A Industrial',
          powerKw: 3.7,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.threeWheeler],
        ),
      ],
    ),

    // 🌟 2. PlugMitra Official Highway Mega Fleet & Truck Hub (NH-48)
    ChargingStation(
      id: 'pm-02',
      name: 'PlugMitra Highway Fleet & Mega Truck Hub',
      operator: 'PlugMitra Official Network',
      address: 'NH-48 Expressway Toll Plaza, Manesar',
      city: 'Delhi-NCR',
      latitude: 28.3582,
      longitude: 76.9421,
      distanceKm: 4.8,
      rating: 4.9,
      totalReviews: 640,
      tariffPerKwh: 16.5,
      isPlugMitraOwned: true,
      memberDiscountPercent: 15,
      hasPlugAndCharge: true,
      isOpen24x7: true,
      isVerified: true,
      isFastCharger: true,
      hasHeavyTruckBay: true,
      amenities: ['Heavy Truck Bays', 'Drivers AC Dormitory', 'Canteen', 'Tyre Air & Wash', 'Shower Rooms'],
      supportedCategories: [
        VehicleCategory.commercialTruck,
        VehicleCategory.electricBus,
        VehicleCategory.fourWheeler,
      ],
      connectors: [
        ConnectorInfo(
          id: 'c5',
          name: 'Ultra Truck Gun 1 (Heavy CCS-2)',
          type: 'CCS-2 Heavy DC',
          powerKw: 240,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.commercialTruck, VehicleCategory.electricBus],
        ),
        ConnectorInfo(
          id: 'c6',
          name: 'Truck Gun 2 (Dual CCS-2)',
          type: 'CCS-2 Heavy DC',
          powerKw: 150,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.commercialTruck, VehicleCategory.electricBus],
        ),
        ConnectorInfo(
          id: 'c7',
          name: 'Fleet Logistics Gun (60 kW)',
          type: 'CCS-2',
          powerKw: 60,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.commercialTruck, VehicleCategory.fourWheeler],
        ),
      ],
    ),

    // 🌟 3. PlugMitra Official GreenPark (Mumbai BKC)
    ChargingStation(
      id: 'pm-03',
      name: 'PlugMitra GreenPark BKC',
      operator: 'PlugMitra Official Network',
      address: 'G Block, Bandra Kurla Complex',
      city: 'Mumbai',
      latitude: 19.0660,
      longitude: 72.8687,
      distanceKm: 2.3,
      rating: 4.9,
      totalReviews: 420,
      tariffPerKwh: 17.5,
      isPlugMitraOwned: true,
      memberDiscountPercent: 15,
      hasPlugAndCharge: true,
      isOpen24x7: true,
      isVerified: true,
      isFastCharger: true,
      hasHeavyTruckBay: false,
      amenities: ['Mitra Express Café', 'Priority EV Parking', 'Restroom', 'High-Speed WiFi'],
      supportedCategories: [
        VehicleCategory.fourWheeler,
        VehicleCategory.twoWheeler,
        VehicleCategory.threeWheeler,
        VehicleCategory.commercialTruck,
      ],
      connectors: [
        ConnectorInfo(
          id: 'c8',
          name: 'Fast Gun A (120 kW)',
          type: 'CCS-2',
          powerKw: 120,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.fourWheeler, VehicleCategory.commercialTruck],
        ),
        ConnectorInfo(
          id: 'c9',
          name: 'Fast Gun B (60 kW)',
          type: 'CCS-2',
          powerKw: 60,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.fourWheeler],
        ),
        ConnectorInfo(
          id: 'c10',
          name: '2W Fast Point',
          type: 'Type-6',
          powerKw: 3.3,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.twoWheeler],
        ),
      ],
    ),

    // 🌟 4. PlugMitra Official TechHub (Bengaluru)
    ChargingStation(
      id: 'pm-04',
      name: 'PlugMitra TechHub Indiranagar',
      operator: 'PlugMitra Official Network',
      address: '100ft Road, Indiranagar',
      city: 'Bengaluru',
      latitude: 12.9784,
      longitude: 77.6408,
      distanceKm: 1.8,
      rating: 4.9,
      totalReviews: 530,
      tariffPerKwh: 15.5,
      isPlugMitraOwned: true,
      memberDiscountPercent: 15,
      hasPlugAndCharge: true,
      isOpen24x7: true,
      isVerified: true,
      isFastCharger: true,
      hasHeavyTruckBay: false,
      amenities: ['2W Battery Swap Station', 'Mitra EV Lounge', 'High-Speed WiFi', 'Café'],
      supportedCategories: [
        VehicleCategory.twoWheeler,
        VehicleCategory.threeWheeler,
        VehicleCategory.fourWheeler,
      ],
      connectors: [
        ConnectorInfo(
          id: 'c11',
          name: 'DC Fast Gun (60 kW)',
          type: 'CCS-2',
          powerKw: 60,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.fourWheeler],
        ),
        ConnectorInfo(
          id: 'c12',
          name: '2W Ather/Ola Swapping Point',
          type: 'Ather Dot/Type-6',
          powerKw: 3.3,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.twoWheeler],
        ),
        ConnectorInfo(
          id: 'c13',
          name: '3W Cargo Point (16A)',
          type: '16A Industrial',
          powerKw: 3.7,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.threeWheeler],
        ),
      ],
    ),

    // 5. Partner Station: Tata Power EZ Charge
    ChargingStation(
      id: 'pm-05',
      name: 'Tata Power EZ Charge CP',
      operator: 'Tata Power Partner',
      address: 'Outer Circle, Connaught Place',
      city: 'New Delhi',
      latitude: 28.6315,
      longitude: 77.2167,
      distanceKm: 3.5,
      rating: 4.6,
      totalReviews: 320,
      tariffPerKwh: 20.0,
      isPlugMitraOwned: false,
      memberDiscountPercent: 0,
      hasPlugAndCharge: false,
      isOpen24x7: true,
      isVerified: true,
      isFastCharger: true,
      hasHeavyTruckBay: false,
      amenities: ['Public Parking', 'Metro Station Access'],
      supportedCategories: [
        VehicleCategory.fourWheeler,
        VehicleCategory.commercialTruck,
      ],
      connectors: [
        ConnectorInfo(
          id: 'c14',
          name: 'Fast Gun 1',
          type: 'CCS-2',
          powerKw: 60,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.fourWheeler, VehicleCategory.commercialTruck],
        ),
      ],
    ),

    // 6. Partner Station: Jio-bp Pulse
    ChargingStation(
      id: 'pm-06',
      name: 'Jio-bp Pulse Aerocity',
      operator: 'Jio-bp Pulse Partner',
      address: 'Hospitality District, IGI Airport',
      city: 'New Delhi',
      latitude: 28.5504,
      longitude: 77.1218,
      distanceKm: 5.2,
      rating: 4.7,
      totalReviews: 489,
      tariffPerKwh: 21.0,
      isPlugMitraOwned: false,
      memberDiscountPercent: 0,
      hasPlugAndCharge: false,
      isOpen24x7: true,
      isVerified: true,
      isFastCharger: true,
      hasHeavyTruckBay: false,
      amenities: ['Wild Bean Café', 'Clean Restrooms', '24/7 Security'],
      supportedCategories: [
        VehicleCategory.fourWheeler,
        VehicleCategory.commercialTruck,
      ],
      connectors: [
        ConnectorInfo(
          id: 'c15',
          name: 'Hyper Gun 1 (150 kW)',
          type: 'CCS-2',
          powerKw: 150,
          isAvailable: true,
          currentStatus: 'Available',
          compatibleCategories: [VehicleCategory.fourWheeler, VehicleCategory.commercialTruck],
        ),
      ],
    ),
  ];
}
