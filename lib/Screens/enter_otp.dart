import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_phone_auth/Screens/homepage.dart';

class EnterOtp extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const EnterOtp({super.key, required this.phoneNumber, required this.verificationId});

  @override
  State<EnterOtp> createState() => _EnterOtpState();
}

class _EnterOtpState extends State<EnterOtp> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Color buttonColor = const Color(0xFF2e3b62);
  bool _loading = false;
  String _verificationId;

  _EnterOtpState() : _verificationId = '';

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
    for (int i = 0; i < 6; i++) {
      _otpControllers[i].addListener(() {
        if (_otpControllers[i].text.isNotEmpty && i < 5) {
          FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() async {
    setState(() {
      _loading = true;
    });

    String smsCode = _otpControllers.map((controller) => controller.text).join();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );

    try {
      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (e) {
      throw('Failed to sign in: ${e.toString()}');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _resendOtp() async {
    setState(() {
      _loading = true;
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          throw('The provided phone number is not valid.');
        } else {
          print('Phone number verification failed: ${e.message}');
        }
        setState(() {
          _loading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _loading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Verify Phone',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 10),
              Text(
                'Code is sent to ${widget.phoneNumber}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: width * 0.12,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.cyan[200],
                        border: const OutlineInputBorder(borderSide: BorderSide.none),
                        counterText: "",
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                        }
                        if (index == 5 && value.isNotEmpty) {
                          _verifyOtp(); // Automatically verify OTP when last digit is entered
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the code?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: _resendOtp,
                    style: const ButtonStyle(),
                    child: const Text(
                      'Request Again',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : Container(
                      width: width * 0.9,
                      height: 50,
                      decoration: BoxDecoration(color: buttonColor),
                      child: TextButton(
                        onPressed: _verifyOtp,
                        child: const Text(
                          'VERIFY AND CONTINUE',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
