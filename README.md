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

**PlugMitra** is a production-grade, state-of-the-art Flutter EV charging super-app crafted for the Indian electric mobility ecosystem. It bridges the gap between EV drivers and fragmented charging networks by providing a single, unified interface for discovery, smart reservation, tap-to-charge authentication, live telemetry, and automated payments.

Engineered with a clean, high-contrast **Emerald Green & Pure White** design aesthetic, PlugMitra seamlessly supports all electric vehicle segments across India:
- 🛵 **2-Wheelers** (Ather 450X, Ola S1 Pro, TVS iQube, Ultraviolette)
- 🛺 **3-Wheelers** (Mahindra Treo, Piaggio Ape E-City, Euler HiLoad)
- 🚗 **4-Wheelers** (Tata Nexon EV, Mahindra XUV400, MG ZS EV, Hyundai Ioniq 5)
- 🚚 **Commercial Trucks & Fleet Vans** (Tata Ace EV, Tata Ultra T.7 Electric Truck)
- 🚌 **Heavy Electric Buses & Fleets** (Olectra, Switch Mobility)

---

## 🌟 Key Features

### 1. 🎛️ Advanced Multi-Factor EV Filter
* **Connector Compatibility**: Filter exclusively by `CCS-2`, `Type-2 (AC)`, `CHAdeMO`, `Bharat AC-001`, or `Ather Dot / 16A`.
* **Charging Speed Slider**: Set minimum power from `3.3 kW` (Slow AC) up to `150 kW+` (Hyper-Fast DC).
* **Driver Amenities**: Find hubs equipped with `☕ Coffee Shop / Cafe`, `📶 High-Speed Wi-Fi`, `🚻 Restrooms`, and `🛋️ EV Driver Lounge`.
* **Station Status**: One-tap toggles for `Available Now`, `24x7 Open`, and `⭐ PlugMitra Verified Hubs`.

### 2. 🚗 Multi-EV Garage & Dynamic App Adaptation
* Switch between active vehicles right from the **Discover screen** or the **Profile & Wallet screen**.
* The entire app (station compatibility, connector list, charging curves, tariff estimates, and range calculations) dynamically adapts to the selected vehicle's battery pack and socket type.

### 3. 💳 Virtual Tap-to-Charge RFID Keycard & AutoCharge (ISO 15118)
* **Digital RFID Keycard**: Built-in contactless smart card simulation (`PM-RFID-8921-IN`) with NFC animation for friction-free authentication at charging kiosks.
* **AutoCharge (Plug & Charge)**: Support for automated gun-plug handshake without requiring QR scanning or manual app actions.
* **Dual QR & RFID Scanner**: In-app camera scanner featuring animated green laser viewfinder, flashlight toggle, and manual 6-digit Charger ID entry.

### 4. 🔋 Live Telemetry HUD & 80% Sweet-Spot Battery Protection
* **Radial Telemetry Gauge**: High-contrast, glowing radial meter displaying real-time State-of-Charge (SoC %), charging speed (kW), energy delivered (kWh), voltage (405V), and current (142A).
* **80% Battery Sweet-Spot Alert**: Smart banner notification advising drivers to stop at 80% SoC to preserve Lithium battery health and avoid thermal tapering costs.
* **Cost & Timer Tracking**: Live session timer with real-time rupee billing calculation.

### 5. ⭐ Crowdsourced Community Reviews & Broken Gun Reporting
* **Driver Star Ratings**: Authentic community reviews from verified EV drivers with date and vehicle stamps.
* **Crowdsourced Issue Reporting**: In-sheet reporting for `Broken Gun`, `ICEing (Petrol car blocking bay)`, `Offline Kiosk`, or `Slow Power Delivery`.
* **Active Issue Tracking**: Logged reports appear in the user's Profile screen under **"My Reported Station Issues"** with real-time status tracking.

### 6. ⚡ EV vs Petrol Fuel Savings & Carbon Calculator
* Interactive daily commute slider (10 km to 200 km).
* Real-time monthly and annual cost savings comparison (EV at ₹1.25/km vs Petrol at ₹7.50/km).
* Environmental impact counter displaying monthly **CO₂ emissions eliminated** and equivalent **trees planted**.

### 7. 📅 Advance Slot Booking & Boarding-Pass Tickets
* Reserve charging slots ahead of arrival to eliminate queue anxiety.
* Boarding-pass style QR ticket with unique Gun Unlock PIN, slot duration, and directions shortcut.

### 8. 🧾 GST Tax Invoice & FastWallet
* Instant UPI AutoPay wallet top-ups (₹500, ₹1000, ₹2000).
* Complete transaction history with downloadable GST-compliant Tax Invoices for business expense reimbursement.

---

## 📱 Architecture & Flow

| Screen | Design Focus | Highlights |
| :--- | :--- | :--- |
| **01. Splash & Onboarding** | Clean Emerald White | Quick feature walkthrough with vehicle category highlights |
| **02. Discover & Radar** | Interactive Map & List | Live station markers, quick chips, multi-EV vehicle switcher |
| **03. Station Detail** | Sheet Modal | Socket availability, power rates, driver reviews & issue reporting |
| **04. Advanced Filter** | Bottom Sheet | Power slider, socket types, amenities & verified hub toggles |
| **05. Scan & Charge** | Dark HUD | Animated laser scanner, Virtual RFID tap, manual ID dialog |
| **06. Live Charging** | Dark Telemetry | Circular gauge, 80% sweet-spot alert, emergency stop dialog |
| **07. Session Completed** | Success Receipt | Total kWh, amount, green carbon offset badge & tax invoice |
| **08. Slot Booking** | Reservation Flow | Time slot selector, tariff calculation, QR boarding pass |
| **09. Wallet & Profile** | Account & EV Garage | Virtual RFID card, AutoCharge toggle, savings calculator |

---

## 📂 Project Structure

```
lib/
├── main.dart                  # Application bootstrap, routing & AppState provider
├── theme/
│   └── app_theme.dart         # Emerald Green, Mint Glow & Dark HUD theme tokens
├── models/
│   ├── vehicle.dart           # VehicleCategory (2W, 3W, 4W, Truck, Bus) & Garage presets
│   ├── station.dart           # Charging station, operator metadata, connector sockets
│   └── charging_session.dart  # Telemetry engine, dynamic power curves & billing
├── state/
│   └── app_state.dart         # Centralized ChangeNotifier for filters, vehicle selection & sessions
├── widgets/
│   ├── advanced_filter_sheet.dart # Multi-factor filter modal (connectors, kW, amenities)
│   ├── charging_gauge.dart    # High-contrast radial telemetry gauge with glow
│   ├── map_preview_widget.dart# Interactive visual EV grid map with live status pins
│   ├── station_card.dart      # Clean station card with status chips and distance
│   ├── connector_badge.dart   # Interactive socket chip with live status
│   ├── booking_ticket_dialog.dart # Boarding-pass QR ticket modal
│   └── tax_invoice_dialog.dart# GST-compliant charging invoice dialog
└── screens/
    ├── main_shell.dart        # 5-Tab shell with adaptive navigation bar & mini telemetry pill
    ├── discover_screen.dart   # Search, map/list view, vehicle picker & quick filters
    ├── scan_qr_screen.dart    # Viewfinder, animated laser, Virtual RFID tap & manual ID
    ├── live_charging_screen.dart # Real-time telemetry dashboard & 80% battery alert
    ├── charging_completed_screen.dart # Completion receipt & invoice download modal
    ├── booking_screen.dart    # Advance slot reservation workflow & pass manager
    ├── station_detail_sheet.dart # Connector selector, community reviews & issue reporting
    ├── wallet_profile_screen.dart# Mitra wallet, Virtual RFID card, AutoCharge & savings calculator
    └── profile_setup_screen.dart # Vehicle specs manager & registration editor
```

---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.20.0 or higher)
* [Dart SDK](https://dart.dev/get-dart) (v3.4.0 or higher)
* Android Studio / Xcode / VS Code with Flutter extension

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/your-username/plugmitra.git
cd plugmitra

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
