import 'package:flutter/material.dart';
import 'package:project_phone_auth/Screens/mobile_number001.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  String _selectedLanguage = 'English';
  Color buttonColor = const Color(0xFF2e3b62);

  final List<String> _selectLanguages = [
    'English',
    'Hindi',
    'Spanish',
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/imageicon.png',width: 100,),
              const SizedBox(height: 20,),
              const Text('Please select your Language',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),
              const SizedBox(height: 10,),
              Container(
                width: width*0.6,
                child: Text('You can change the language at any time.',style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 16
                ),softWrap: true,
                textAlign: TextAlign.center,),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade900, width: 1.0),
                ),
                padding: const EdgeInsets.only(left: 8.0),
                child: DropdownButtonHideUnderline(  // This will remove the underline
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedLanguage,
                    icon: const Icon(Icons.arrow_drop_down,color: Colors.grey,),
                    iconSize: 32,
                    elevation: 16,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLanguage = newValue!;
                      });
                    },
                    items: _selectLanguages.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const MobileNumber001()));
                },
                child: Container(
                  width: width*0.6,
                  height: 50,
                  decoration: BoxDecoration(
                      color: buttonColor
                  ),
                  child: const Center(
                    child: Text('NEXT',style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),),
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

