import 'package:flutter/material.dart';

import '../widgets/cutom_radio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedRole = "shipper";
  Color buttonColor = const Color(0xFF2e3b62);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Please select your profile',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildRoleOption(
                value: 'shipper',
                groupValue: _selectedRole,
                icon: Icons.warehouse_outlined,
                title: 'Shipper',
                description: 'I have products that need to be shipped.',
              ),
              const SizedBox(height: 20),
              _buildRoleOption(
                value: 'transporter',
                groupValue: _selectedRole,
                icon: Icons.local_shipping_outlined,
                title: 'Transporter',
                description: 'I provide transportation services.',
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {},
                child: Container(
                  width: width * 0.9,
                  height: 50,
                  decoration: BoxDecoration(color: buttonColor),
                  child: const Center(
                    child: Text(
                      'CONTINUE',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption({
    required String value,
    required String? groupValue,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          CustomRadio(
            value: value,
            groupValue: groupValue,
            onChanged: (String? newValue) {
              setState(() {
                _selectedRole = newValue;
              });
            },
            fillColor: buttonColor,
          ),
          const SizedBox(width: 10),
          Icon(
            icon,
            size: 50,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
