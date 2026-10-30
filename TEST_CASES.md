# ⚡ PlugMitra — QA Test Cases & User Flow
> **Portfolio QA & Validation Suite for EV Smart Charging Platform**  
> *Mobile App + Admin & Station Owner Workflows*

---

## 📌 1. End-to-End User Flow

```
[01. Splash & Logo] ──► [02. Onboarding Slides] ──► [03. Mobile Login (+91)] ──► [04. 6-Digit OTP]
                                                                                       │
┌──────────────────────────────────────────────────────────────────────────────────────┘
▼
[05. Profile & Vehicle Setup] (Name, 2W/3W/4W/Truck, Connector Type)
│
▼
[06. Home / Radar Map] ◄──► [07. Nearby Station Feed]
│
▼
[08. Station Details] (Guns, Tariffs, Amenities, Truck Bays)
│
▼
[09. Slot Booking] ──► [10. Payment & Pre-Auth] (UPI, Cards, Wallet)
│                               │
│ (Or Direct QR Scan)           ▼
└──────────────────────► [11. QR Scan & Charger Authorization]
                                │
                                ▼
                         [12. Live Telemetry Session] (kW, kWh, V, A, Timer, Cost)
                                │
                                ▼
                         [13. Stop Charging & Completed Receipt] (Invoice Download)
                                │
                                ▼
                         [14. Charging History & Mitra Wallet]
```

---

## 🧪 2. Core Functional Test Suite (TC-001 to TC-038)

**Priority Scale**:
* `P1` = Critical / Core Flow
* `P2` = Important Functional
* `P3` = Usability / Edge Case

| ID | Module / Area | Steps / Test Data | Expected Result | Priority |
| :--- | :--- | :--- | :--- | :--- |
| **TC-001** | App Launch | Fresh install; open app | Animated Splash screen loads cleanly; 3D PlugMitra logo visible | **P1** |
| **TC-002** | Onboarding | Swipe slides; tap "Get Started" | Page indicators cycle; CTA opens Mobile Login screen | **P2** |
| **TC-003** | Login Validation | Blank or invalid phone number entered | Validation message shown; OTP request blocked | **P1** |
| **TC-004** | OTP Success | Enter valid 6-digit OTP | User authenticated; Profile Setup screen opens | **P1** |
| **TC-005** | OTP Failure | Enter incorrect 6-digit OTP | Clear error message; login blocked | **P1** |
| **TC-006** | OTP Resend | Wait for 24s countdown timer; tap resend | New OTP triggered within rate limits | **P1** |
| **TC-007** | Profile Save | Select Name, EV Type (2W/3W/4W/Truck), and Connector | Profile data persisted across app restarts | **P2** |
| **TC-008** | Location Permission | Allow / Deny GPS permissions | Nearby stations displayed on allow; search fallback on deny | **P1** |
| **TC-009** | Nearby Stations | Open Home Map with location active | Nearest stations rendered with live distance & free ports | **P1** |
| **TC-010** | Search Station | Search by hub name, city (Gurugram, Mumbai, Delhi) | Filtered stations match query; clean empty state if no match | **P2** |
| **TC-011** | Filter Chips | Filter by 2W, Car, Heavy Truck Bay, Fast (>50kW) | Station list updates dynamically to matching criteria | **P1** |
| **TC-012** | Map / List Toggle | Toggle between Radar Map and Station List | Active search/filter state preserved across views | **P2** |
| **TC-013** | Station Details | Open station from map pin or card | Address, opening hours, tariff, amenities, and guns shown | **P1** |
| **TC-014** | Unavailable Charger | Select occupied or offline gun | Start/Booking disabled or blocked with clear status | **P1** |
| **TC-015** | Booking Validation | Select date, time window, and connector | Valid slot reserved; Pass with Confirmation ID generated | **P1** |
| **TC-016** | Slot Conflict | Concurrent booking on same gun & time | Only first booking succeeds; conflict alert to second user | **P1** |
| **TC-017** | Cancel Booking | Cancel reservation within allowed window | Slot freed; refund status updated | **P1** |
| **TC-018** | Payment Success | Complete UPI / Card / Wallet checkout | Booking/pre-auth confirmed; receipt & transaction ID shown | **P1** |
| **TC-019** | Payment Failure | Simulate declined payment / provider error | No false success; retry options presented | **P1** |
| **TC-020** | Payment Pending | Simulate pending gateway webhook | Order marked pending; auto-reconciliation triggered | **P1** |
| **TC-021** | Duplicate Payment Tap | Rapidly tap "Pay" multiple times | Idempotency token prevents duplicate transactions | **P1** |
| **TC-022** | QR Scan Valid | Scan valid charger QR code | Charger details validated; instant charge flow opens | **P1** |
| **TC-023** | QR Scan Invalid | Scan damaged or unrecognized QR code | Helpful error displayed; session start prevented | **P1** |
| **TC-024** | Start Charging | Initiate session on available gun | Backend/hardware confirmation triggers Live Charging UI | **P1** |
| **TC-025** | Start Timeout | Simulate charger response delay / timeout | Safe retry state shown; no false active charging | **P1** |
| **TC-026** | Live Telemetry | Monitor active charging session | Speed (kW), Energy (kWh), Voltage (V), Current (A) update | **P1** |
| **TC-027** | Network Loss | Disconnect internet during active charging | Reconnect state shown; background session state preserved | **P1** |
| **TC-028** | Stop Charging | Tap "Stop & Unlock Gun" | Stop request sent; final kWh, time, and cost calculated | **P1** |
| **TC-029** | Stop Failure | Stop command timeout / gun stuck | Uncertainty warning shown; hardware status rechecked | **P1** |
| **TC-030** | Final Bill | Session ended meter reading | Tariff rate × kWh units equals final bill with zero discrepancy | **P1** |
| **TC-031** | Invoice Download | Tap "Download Tax Invoice" on completion | GST invoice generated with units, rate, and transaction ID | **P2** |
| **TC-032** | Session History | View "Completed" tab in History screen | Accurate logs of all past charging sessions displayed | **P1** |
| **TC-033** | Push Alerts | Trigger session completed / booking event | Timely push notification delivered to user device | **P2** |
| **TC-034** | Session Expiry | Expired token / session timeout | Secure protected screens locked; login requested | **P1** |
| **TC-035** | Responsive Layout | Test small screens, large text scaling | Zero RenderFlex overflows; all touch targets accessible | **P2** |
| **TC-036** | Admin Update | Station owner updates tariff / status | Changes immediately reflected on customer discovery app | **P1** |
| **TC-037** | Multi-Tenant Isolation | Station owner edits another operator's hub | Access denied; strict data isolation maintained | **P1** |
| **TC-038** | Audit & Error Safety | Simulate API 4xx/5xx network errors | User-friendly error message; app remains stable without crash | **P2** |

---

## ⚡ 3. Negative & Edge Scenarios

* **GPS / Location drift**: User books a charger while outside city boundary; system recalculates distance accurately.
* **Charger state changed while driving**: Station showed free at search time, but became occupied before arrival; app alerts user to reserve slot.
* **App backgrounded / killed during fast charging**: Background telemetry timer and floating pill persist state seamlessly.
* **Battery Longevity Threshold**: 80% charge limit automatically protects EV battery health from overheating.
* **Emergency Gun Release**: Safety confirmation dialog prevents accidental unplugging during high-voltage DC fast flow.

---

## 📋 4. Release & Smoke Test Checklist

- [x] App launches with 3D animated Splash screen without any crash.
- [x] Onboarding, Mobile Login, OTP, and Profile Setup flows verified.
- [x] All 5 vehicle categories (2W, 3W, 4W Car, Heavy Truck, Bus) supported.
- [x] Radar map and nearby station filtering functioning smoothly.
- [x] Slot booking generates boarding pass with QR code and Gun Unlock PIN.
- [x] Camera scanner viewfinder with animated laser line works as expected.
- [x] Live telemetry circular gauge and real-time kW/kWh meters verified.
- [x] Charging completed screen with GST tax invoice download verified.
- [x] Static analyzer: `flutter analyze` ➜ **0 errors, 0 warnings**.
- [x] Automated test suite: `flutter test` ➜ **All tests passed**.
