import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_phone_auth/Screens/enter_otp.dart';

class MobileNumber001 extends StatefulWidget {
  const MobileNumber001({super.key});

  @override
  State<MobileNumber001> createState() => _MobileNumber001State();
}

class _MobileNumber001State extends State<MobileNumber001> {
  final TextEditingController _numberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Color buttonColor = const Color(0xFF2e3b62);
  bool _loading = false;

  void _verifyPhoneNumber() async {
    setState(() {
      _loading = true;
    });

    String phoneNumber = '+91${_numberController.text.trim()}';

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _loading = false;
        });
        if (e.code == 'invalid-phone-number') {
          throw ('The provided phone number is not valid.');
        } else {
          throw ('Phone number verification failed: ${e.message}');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _loading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnterOtp(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval timed out
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.clear),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Please enter your mobile number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                width: width * 0.6,
                child: Text(
                  "You'll receive a 6 digit code to verify next.",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/india.png',
                      width: 30,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "+91",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      '-',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _numberController,
                        decoration: InputDecoration(
                          hintText: 'Mobile Number',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _loading ? null : _verifyPhoneNumber,
                child: Container(
                  width: width * 0.9,
                  height: 50,
                  decoration: BoxDecoration(color: buttonColor),
                  child: Center(
                    child: _loading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'CONTINUE',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
