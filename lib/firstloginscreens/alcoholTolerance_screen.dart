import 'package:flutter/material.dart';
import 'package:todays_drink/firstloginscreens/pledge_screen.dart';
import 'package:provider/provider.dart';
import 'package:todays_drink/providers/profile_provider.dart';

class AlcoholAmountScreen extends StatefulWidget {
  const AlcoholAmountScreen({super.key});

  @override
  State<AlcoholAmountScreen> createState() => _AlcoholAmountScreenState();
}

class _AlcoholAmountScreenState extends State<AlcoholAmountScreen> {
  String? drinkType; // 'soju' or 'beer'
  double amount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '당신의 주량은?',
              style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  fontSize: 20,
                  fontWeight: FontWeight.w800)
              ,
            ),
            const SizedBox(height: 8),
            const Text(
              '주로 마시는 주종을 선택한 후 주량을 알려주세요.',
              style: TextStyle(
                  fontFamily: "NotoSansKR",
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: ['소주', '맥주'].map((type) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        drinkType = type;
                        amount = 0.0;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: drinkType == type
                              ? const Color(0xFFF2D027)
                              : Colors.grey,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          type,
                          style: TextStyle(
                            fontFamily: "NotoSansKR",
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            if (drinkType != null) ...[
              Text(
                '${amount.toStringAsFixed(1)}병',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Slider(
                value: amount,
                min: 0.0,
                max: 10.0,
                divisions: 20, // 0.5 단위로 쪼개기 (0.0 ~ 10.0)
                activeColor: const Color(0xFFF2D027),
                label: '${amount.toStringAsFixed(1)}병',
                onChanged: (value) {
                  setState(() {
                    amount = value;
                  });
                },
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0병', style: TextStyle(color: Colors.grey)),
                  Text('10병 이상', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
            const Spacer(),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: drinkType != null ? const Color(0xFF2E7B8C) : Colors.grey[300],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: drinkType != null
                    ? () {
                  Provider.of<ProfileProvider>(context, listen: false)
                      .updateDrinkingInfo(drinkType!, amount);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PledgeScreen()),
                  );
                }
                    : null,

                child: const Text('계속하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "NotoSansKR",
                      fontWeight: FontWeight.w700
                    )
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
