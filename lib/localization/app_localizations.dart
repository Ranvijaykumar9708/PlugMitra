import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App General
      'app_name': 'PlugMitra',
      'app_tagline': 'India\'s Universal EV Smart Mobility Platform',
      'search_hint': 'Search station, area, expressway or mall...',
      'all': 'All',
      'available': 'Available',
      'fast_dc': 'Fast DC',
      'battery_swap': '60s Battery Swap',
      'rescue_sos': 'Rescue SOS',
      'solar_energy': '100% Solar',
      'services_hub': 'Services Hub (12)',
      'services_hub_title': 'Mitra Services & Innovations',
      'services_hub_subtitle': '12 Next-Gen EV Mobility & Energy Solutions',
      'switch_ev': 'Switch EV',
      'active_vehicle': 'Active Vehicle',
      'language': 'Language',
      'select_language': 'Select App Language',
      'english': 'English',
      'hindi': 'हिंदी (Hindi)',

      // Tabs
      'tab_discover': 'Discover',
      'tab_map': 'Grid Map',
      'tab_scan': 'Scan & Charge',
      'tab_charging': 'Live Charge',
      'tab_wallet': 'My Mitra',

      // Station Card & Details
      'guns_free': 'Guns Free',
      'view_details': 'View',
      'book_slot': 'Book Slot',
      'navigate': 'Navigate',
      'directions': 'Directions',
      'tariff_rate': 'Tariff',
      'power_rating': 'Max Power',
      'amenities': 'Amenities',

      // Live Charging Telemetry
      'charging_session': 'Live Charging Telemetry',
      'state_of_charge': 'State of Charge',
      'delivered_energy': 'Energy Delivered',
      'charging_speed': 'Charging Speed',
      'session_cost': 'Session Cost',
      'pause': 'Pause',
      'resume': 'Resume',
      'stop_charging': 'End & Unlock Gun',
      'in_car_comfort': 'In-Car Comfort & Services',
      'arcade_games': 'Arcade & Zen',
      'bay_dine_in': 'Bay Dine-In',
      'battery_doctor': 'Battery Doctor',
      'v2g_sell': 'V2G Grid Sell',
      'mitra_shield': 'Mitra Shield',

      // Wallet & Profile
      'wallet_balance': 'FastWallet Balance',
      'top_up': '+ Top Up',
      'vip_member': 'PlugMitra Black VIP',
      'smart_mobility': 'Smart Mobility & IoT',
      'health_protection': 'Battery Health & Protection',
      'p2p_host': 'P2P Wallbox Host',
      'home_sync': 'Home-Sync Solar',
      'valet_concierge': 'Valet Concierge',
      'carbon_tokens': 'Green Carbon Tokens',
      'highway_corridor': 'Highway Corridor',
    },
    'hi': {
      // App General
      'app_name': 'प्लग मित्र',
      'app_tagline': 'भारत का यूनिवर्सल ईवी स्मार्ट मोबिलिटी प्लेटफॉर्म',
      'search_hint': 'स्टेशन, इलाका, हाईवे या मॉल खोजें...',
      'all': 'सभी',
      'available': 'उपलब्ध',
      'fast_dc': 'फास्ट डीसी',
      'battery_swap': '60s बैटरी स्वैप',
      'rescue_sos': 'रेस्क्यू एसओएस',
      'solar_energy': '100% सोलर',
      'services_hub': 'सुविधा केंद्र (12)',
      'services_hub_title': 'मित्र सुविधाएं एवं नई तकनीक',
      'services_hub_subtitle': '12 आधुनिक ईवी मोबिलिटी और ऊर्जा सेवाएं',
      'switch_ev': 'गाड़ी बदलें',
      'active_vehicle': 'सक्रिय वाहन',
      'language': 'भाषा (Language)',
      'select_language': 'ऐप की भाषा चुनें',
      'english': 'English (अंग्रेज़ी)',
      'hindi': 'हिंदी (Hindi)',

      // Tabs
      'tab_discover': 'खोजें',
      'tab_map': 'ग्रिड मैप',
      'tab_scan': 'स्कैन व चार्ज',
      'tab_charging': 'लाइव चार्ज',
      'tab_wallet': 'माई मित्र',

      // Station Card & Details
      'guns_free': 'गन खाली हैं',
      'view_details': 'देखें',
      'book_slot': 'स्लॉट बुक करें',
      'navigate': 'रास्ता देखें',
      'directions': 'दिशानिर्देश',
      'tariff_rate': 'दर (प्रति यूनिट)',
      'power_rating': 'अधिकतम पावर',
      'amenities': 'सुविधाएं',

      // Live Charging Telemetry
      'charging_session': 'लाइव चार्जिंग टेलीमेट्री',
      'state_of_charge': 'बैटरी चार्ज',
      'delivered_energy': 'दी गई ऊर्जा',
      'charging_speed': 'चार्जिंग गति',
      'session_cost': 'कुल राशि',
      'pause': 'रोकें',
      'resume': 'शुरू रखें',
      'stop_charging': 'चार्जिंग समाप्त व अनलॉक',
      'in_car_comfort': 'गाड़ी में आराम व सेवाएं',
      'arcade_games': 'गेम्स व रिलैक्स',
      'bay_dine_in': 'गाड़ी में खाना मंगवाएं',
      'battery_doctor': 'बैटरी डॉक्टर',
      'v2g_sell': 'V2G ग्रिड में बेचें',
      'mitra_shield': 'मित्र शील्ड बीमा',

      // Wallet & Profile
      'wallet_balance': 'फास्टवॉलेट शेष राशि',
      'top_up': '+ पैसे जोड़ें',
      'vip_member': 'प्लगमित्र ब्लैक वीआईपी',
      'smart_mobility': 'स्मार्ट मोबिलिटी व हार्डवेयर',
      'health_protection': 'बैटरी सुरक्षा व स्वास्थ्य',
      'p2p_host': 'घर का चार्जर शेयर करें',
      'home_sync': 'होम-सिंक सोलर IoT',
      'valet_concierge': 'वैले रोबोचार्ज',
      'carbon_tokens': 'ग्रीन कार्बन टोकन',
      'highway_corridor': 'हाईवे कॉरिडोर सुरक्षा',
    },
  };

  String translate(String key) {
    final langCode = locale.languageCode;
    return _localizedValues[langCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension LocalizationExtension on BuildContext {
  String tr(String key) => AppLocalizations.of(this).translate(key);
}
