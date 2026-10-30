# ⚡ PlugMitra (प्लग मित्र)
> **India's Universal EV Smart Mobility & Charging Platform**  
> *Charge Smarter. Go Greener. Find. Book. Charge. Pay.*  

[![Flutter](https://img.shields.io/badge/Flutter-v3.29.0-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-v3.7.0-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue.svg)](https://flutter.dev)
[![Code Quality](https://img.shields.io/badge/Analysis-0%20Issues-brightgreen.svg)]()

---

## 📖 About The Project

**PlugMitra** is a production-grade, state-of-the-art Flutter EV charging super-app crafted for the Indian electric mobility ecosystem. It bridges the gap between EV drivers and fragmented charging networks by providing a single, unified interface for discovery, smart reservation, tap-to-charge authentication, live telemetry, automated payments, and exclusive VIP roadside assistance.

Engineered with a clean, high-contrast **Emerald Green & Pure White** design aesthetic, PlugMitra seamlessly supports all electric vehicle segments across India:
- 🛵 **2-Wheelers** (Ather 450X, Ola S1 Pro, TVS iQube, Ultraviolette)
- 🛺 **3-Wheelers** (Mahindra Treo, Piaggio Ape E-City, Euler HiLoad)
- 🚗 **4-Wheelers** (Tata Nexon EV, Mahindra XUV400, MG ZS EV, Hyundai Ioniq 5)
- 🚚 **Commercial Trucks & Fleet Vans** (Tata Ace EV, Tata Ultra T.7 Electric Truck)
- 🚌 **Heavy Electric Buses & Fleets** (Olectra, Switch Mobility)

---

## 👑 Elite & Exclusive Premium Services

### 1. 👑 PlugMitra Black VIP Club (Elite Membership)
* **Flat 25% Off Super-Tariff**: Automatic discounted rate across all verified hubs (`₹13.50/kWh` instead of `₹18.00/kWh`).
* **3-Hour Priority Slot Booking**: Block charging bays up to 3 hours in advance with zero queue waiting.
* **PlugMitra Executive Lounge Access**: Complimentary access to air-conditioned pods, Wi-Fi, work desks & gourmet coffee.
* **Laser-Engraved Metal Keycard**: Physical matte-black NFC RFID card delivered home.
* **2x Free Mitra Rescue Dispatches**: Free roadside mobile fast-charging van dispatches annually.

### 2. 🚨 Mitra Rescue — On-Demand Mobile EV Fast-Charging Van (SOS)
* **Stranded Driver SOS Dispatch**: Call a Mobile Fast-Charging Van directly to your breakdown GPS coordinates.
* **30 kW DC Mobile Rapid Boost**: Delivers 15-20 min high-speed boost (+35 to +40 km range) to safely reach the nearest permanent hub.
* **Emergency roadside assistance**: Includes digital tyre pressure inflator and 12V LiFePO4 auxiliary battery jumpstart.

### 3. 🌙 Smart ToD (Time-of-Day) Off-Peak Tariff Optimizer
* **24-Hour Electricity Tariff Chart**: Dynamic visualization of off-peak hours (11:00 PM – 06:00 AM at ₹9.50/unit) vs peak demand (₹22.50/unit).
* **Overnight Auto-Charge Scheduler**: Plug the charging gun now; charging automatically starts when off-peak begins.
* **Real-time Savings Calculator**: Displays exact rupee savings per session (~₹340/session).

### 4. 🌱 100% Certified Solar Green Energy & ESG Certificates
* **Solar Microgrid Filter**: Dedicated toggle and map filter to discover charging stations powered 100% by solar and wind.
* **Verified ESG Renewable Energy Certificate (REC)**: Downloadable and LinkedIn-ready verified carbon avoidance certificates for ESG audits and tax benefits.

### 5. 🏢 Fleet Mitra — Commercial EV Fleet Control & Logistics Dashboard
* **Centralized Corporate FastWallet**: Multi-driver shared wallet balance (`₹48,500.00`) with consolidated monthly GST tax reports.
* **Live Fleet Roster & Telemetry**: Monitor battery levels, active charging sessions, and transit routes across delivery trucks and cargo 3-wheelers.

### 6. 🎙️ Hey Mitra — AI Smart Voice Co-Pilot (Bilingual)
* **Natural Voice Commands**: Hands-free voice navigation in Hindi and English.
* **Intelligent Query Interpretation**: *"Agra Expressway 60kW charger with coffee"* or *"Nearest 2-wheeler Ather charger"*.

---

## 🌟 Core App Features

### 🎛️ Advanced Multi-Factor EV Filter
* Filter by socket type (`CCS-2`, `Type-2`, `CHAdeMO`, `Bharat AC-001`, `Ather Dot / 16A`).
* Minimum power slider (3.3 kW to 150 kW+), driver amenities (`Coffee`, `Wi-Fi`, `Restrooms`, `Lounge`), and 24x7 status.

### 🚗 Multi-EV Garage & Dynamic App Adaptation
* Switch between active vehicles from the Discover screen or Profile screen. All station compatibility, tariffs, and range adapt dynamically.

### 💳 Virtual Tap-to-Charge RFID Keycard & AutoCharge (ISO 15118)
* Built-in contactless smart card simulation (`PM-RFID-8921-IN`) with NFC animation.
* ISO 15118 Plug & Charge support for seamless gun connection without scanning.

### 🔋 Live Telemetry HUD & 80% Sweet-Spot Battery Protection
* Radial telemetry gauge displaying SoC %, charging speed (kW), energy delivered (kWh), voltage (405V), and current (142A).
* 80% sweet-spot protection alert to preserve battery longevity.

### ⭐ Crowdsourced Community Reviews & Broken Gun Reporting
* Authentic driver star ratings with vehicle stamps.
* In-app issue reporting for `Broken Gun`, `ICEing (Petrol car blocking bay)`, `Offline Kiosk`, or `Slow Charging`.

### ⚡ EV vs Petrol Fuel Savings & Carbon Calculator
* Real-time monthly and annual cost savings comparison (EV at ₹1.25/km vs Petrol at ₹7.50/km).
* Environmental impact counter displaying monthly CO₂ emissions eliminated and trees planted.

---

## 📂 Project Structure

```
lib/
├── main.dart                  # Application bootstrap, routing & AppState provider
├── theme/
│   └── app_theme.dart         # Emerald Green, Mint Glow & Dark HUD theme tokens
├── models/
│   ├── vehicle.dart           # VehicleCategory (2W, 3W, 4W, Truck, Bus) & Garage presets
│   ├── station.dart           # Charging station, operator metadata, solar flags & sockets
│   └── charging_session.dart  # Telemetry engine, dynamic power curves & billing
├── state/
│   └── app_state.dart         # Centralized ChangeNotifier for VIP, Rescue, Fleet & sessions
├── widgets/
│   ├── advanced_filter_sheet.dart # Multi-factor filter modal (connectors, kW, amenities)
│   ├── charging_gauge.dart    # High-contrast radial telemetry gauge with glow
│   ├── map_preview_widget.dart# Interactive visual EV grid map with live status pins
│   ├── station_card.dart      # Clean station card with status chips and distance
│   ├── connector_badge.dart   # Interactive socket chip with live status
│   ├── booking_ticket_dialog.dart # Boarding-pass QR ticket modal
│   ├── tax_invoice_dialog.dart# GST-compliant charging invoice dialog
│   ├── vip_membership_sheet.dart  # 👑 PlugMitra Black VIP Club membership modal
│   ├── mitra_rescue_sheet.dart    # 🚨 On-Demand Mobile DC Charging Van SOS
│   ├── tariff_scheduler_dialog.dart # 🌙 Smart ToD off-peak charging optimizer
│   ├── esg_certificate_dialog.dart # 🌱 100% Certified Clean Energy Certificate
│   ├── fleet_mitra_sheet.dart     # 🏢 Commercial EV Fleet Control Dashboard
│   └── voice_copilot_sheet.dart   # 🎙️ Hey Mitra AI Smart Voice Co-Pilot
└── screens/
    ├── main_shell.dart        # 5-Tab shell with adaptive navigation bar & mini telemetry pill
    ├── discover_screen.dart   # Search, map/list view, vehicle picker & quick filters
    ├── scan_qr_screen.dart    # Viewfinder, animated laser, Virtual RFID tap & manual ID
    ├── live_charging_screen.dart # Real-time telemetry dashboard & 80% battery alert
    ├── charging_completed_screen.dart # Completion receipt, ESG certificate & tax invoice
    ├── booking_screen.dart    # Advance slot reservation workflow & pass manager
    ├── station_detail_sheet.dart # Connector selector, community reviews & issue reporting
    ├── wallet_profile_screen.dart# Mitra wallet, VIP club, Fleet portal & savings calculator
    └── profile_setup_screen.dart # Vehicle specs manager & registration editor
```

---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.20.0 or higher)
* [Dart SDK](https://dart.dev/get-dart) (v3.4.0 or higher)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/Ranvijaykumar9708/PlugMitra.git
cd PlugMitra

# 2. Install dependencies
flutter pub get

# 3. Verify zero errors & warnings
flutter analyze
flutter test

# 4. Run on connected device / emulator
flutter run
```

---

## 🛡️ Code Quality & Testing

PlugMitra maintains strict Flutter best practices:
- **0 Analysis Issues**: Clean `flutter analyze` run with zero warnings or errors.
- **Responsive Layout**: Designed to render smoothly on any mobile screen width from 360px up to tablets without RenderFlex overflows.
- **Modular Architecture**: Decoupled models, reactive State Management via `ChangeNotifier`, and reusable design system components.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  <b>Built with 💚 for India's Clean Energy Transition & EV Drivers</b>
</p>
