import 'dart:async';
import 'package:flutter/material.dart';
import 'profile_setup_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<String> _otp = ['1', '2', '3', '4', '', ''];
  int _secondsLeft = 24;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = 24;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onDigitPress(String digit) {
    for (int i = 0; i < _otp.length; i++) {
      if (_otp[i].isEmpty) {
        setState(() {
          _otp[i] = digit;
        });

        // If filled, auto navigate to Profile Setup
        if (i == _otp.length - 1) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (!mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
            );
          });
        }
        break;
      }
    }
  }

  void _onBackspace() {
    for (int i = _otp.length - 1; i >= 0; i--) {
      if (_otp[i].isNotEmpty) {
        setState(() {
          _otp[i] = '';
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1E293B), size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Enter OTP',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'We have sent a 6 digit code to\n+91 ${widget.phoneNumber}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 6 OTP Box Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      final hasVal = _otp[index].isNotEmpty;
                      return Container(
                        width: 46,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: hasVal ? const Color(0xFF00C853) : const Color(0xFFE2E8F0),
                            width: hasVal ? 1.8 : 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _otp[index],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Resend Timer
                  Center(
                    child: _secondsLeft > 0
                        ? RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                              children: [
                                const TextSpan(text: 'Resend OTP in '),
                                TextSpan(
                                  text: '00:${_secondsLeft.toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF00C853),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : TextButton(
                            onPressed: _startTimer,
                            child: const Text(
                              'Resend Code',
                              style: TextStyle(color: Color(0xFF00C853), fontWeight: FontWeight.w700),
                            ),
                          ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Custom On-screen Numpad matching Screen 04
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  _buildNumpadRow(['1', '2', '3']),
                  _buildNumpadRow(['4', '5', '6']),
                  _buildNumpadRow(['7', '8', '9']),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(width: 80, height: 50),
                      _buildNumpadKey('0'),
                      SizedBox(
                        width: 80,
                        height: 50,
                        child: IconButton(
                          icon: const Icon(Icons.backspace_outlined, color: Color(0xFF1E293B)),
                          onPressed: _onBackspace,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumpadRow(List<String> digits) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: digits.map((d) => _buildNumpadKey(d)).toList(),
      ),
    );
  }

  Widget _buildNumpadKey(String digit) {
    return InkWell(
      onTap: () => _onDigitPress(digit),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 80,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            digit,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
      ),
    );
  }
}
