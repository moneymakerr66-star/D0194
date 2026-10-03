import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const D0194App());
}

class D0194App extends StatelessWidget {
  const D0194App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'D0194',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const WarningPage(),
    );
  }
}

class PredictorPage extends StatefulWidget {
  const PredictorPage({super.key});

  @override
  State<PredictorPage> createState() => _PredictorPageState();
}

class _PredictorPageState extends State<PredictorPage> {
final Random random = Random();

final int rows = 5;
final int columns = 5;
final List<String> multipliers = [
  'x4.01',
  'x2.41',
  'x1.93',
  'x1.54',
  'x1.23',
];
Set<int> apples = {};

void showPrediction() {
final Set<int> result = {};

for (int row = 0; row < rows; row++) {
final column = random.nextInt(columns);
result.add((row * columns) + column);
}

setState(() {
apples = result;
});
}

void clearPrediction() {
setState(() {
apples.clear();
});
}
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFF071826),
body: SafeArea(
child: Center(
child: SingleChildScrollView(
padding: const EdgeInsets.all(20),
child: SizedBox(
width: 430,
child: Column(
children: [
const Text(
'D0194',
style: TextStyle(
fontSize: 36,
fontWeight: FontWeight.w900,
letterSpacing: 5,
),
),

const SizedBox(height: 6),

const Text(
'APPLE PREDICTOR',
style: TextStyle(
color: Colors.white54,
letterSpacing: 2,
),
),

const SizedBox(height: 25),

Row(
children: [
Expanded(
child: Container(
height: 50,
decoration: BoxDecoration(
color: const Color(0xFF18A84A),
borderRadius: BorderRadius.circular(14),
),
child: const Center(
child: Text(
'FREE',
style: TextStyle(
fontSize: 17,
fontWeight: FontWeight.bold,
),
),
),
),
),

const SizedBox(width: 12),

Expanded(
  child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const VipOfferPage(),
        ),
      );
    },
    child: Container(
height: 50,
decoration: BoxDecoration(
color: const Color(0xFFFFC107),
borderRadius: BorderRadius.circular(14),
),
child: const Center(
child: Text(
'VIP ⭐',
style: TextStyle(
color: Colors.black,
fontSize: 17,
fontWeight: FontWeight.w900,
),
),
),
    ),
  ),
),
],
),

const SizedBox(height: 25),

Container(
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: const Color(0xFF10283D),
borderRadius: BorderRadius.circular(24),
),
child: Column(
children: [
const Text(
'APPLE OF FORTUNE',
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.w900,
),
),

const SizedBox(height: 20),
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rows * columns,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final hasApple = apples.contains(index);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasApple
                    ? const RadialGradient(
                  colors: [
                    Color(0xFF188A42),
                    Color(0xFF073E25),
                  ],
                )
                    : const RadialGradient(
                  colors: [
                    Color(0xFFB84A22),
                    Color(0xFF67210F),
                    Color(0xFF321008),
                  ],
                ),
                border: Border.all(
                  color: hasApple
                      ? const Color(0xFF37FF88)
                      : const Color(0xFFE36A35),
                  width: 2,
                ),
                boxShadow: hasApple
                    ? const [
                  BoxShadow(
                    color: Color(0xAA00FF66),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
                    : const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  hasApple ? '🍎' : '',
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                ),
              ),
            );
          },
        ),
      ),

      const SizedBox(width: 12),

      Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          multipliers.length,
              (index) => SizedBox(
            height: 58,
            child: Center(
              child: Text(
                multipliers[index],
                style: const TextStyle(
                  color: Color(0xFFFFC94A),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  ),

  const SizedBox(height: 25),

  SizedBox(
    width: double.infinity,
    height: 58,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF18A84A),
        foregroundColor: Colors.white,
      ),
      onPressed: showPrediction,
      child: const Text(
        'إظهار التوقع',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),

  TextButton(
    onPressed: clearPrediction,
    child: const Text('مسح التوقع'),
  ),
],
),
),
],
),
),
),
),
),
);
}
}
class WarningPage extends StatelessWidget {
  const WarningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070707),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 520),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1524),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFFFFB21A),
                  width: 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33FF8A00),
                    blurRadius: 35,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      color: const Color(0xFF211C16),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0x55FFB21A),
                      ),
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFFFC13D),
                      size: 50,
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'تنبيه مهم',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'يرجى قراءة التعليمات التالية بعناية قبل البدء',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFD166),
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121A28),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '● استخدم حساباً جديداً',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          '● اختر المنصة ثم أدخل بياناتك',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          '● يجب أن يكون حسابك مربوطاً بالبروموكود D0194',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xFF101B31),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0x334A8CFF),
                      ),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'البروموكود الخاص',
                          style: TextStyle(
                            color: Color(0xFFFFD166),
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: 12),
                        SelectableText(
                          'D0194',
                          style: TextStyle(
                            color: Color(0xFFFF8A32),
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3478E5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'ابدأ الآن',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
String selectedPlatform = '1xBet';
final TextEditingController passwordController =
TextEditingController();

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFF070707),
body: SafeArea(
child: Center(
child: SingleChildScrollView(
padding: const EdgeInsets.all(22),
child: Container(
constraints: const BoxConstraints(maxWidth: 520),
padding: const EdgeInsets.all(28),
decoration: BoxDecoration(
color: const Color(0xFF171008),
borderRadius: BorderRadius.circular(30),
border: Border.all(
color: const Color(0xFFFFB21A),
),
boxShadow: const [
BoxShadow(
color: Color(0x33FF8A00),
blurRadius: 35,
),
],
),
child: Column(
children: [
const Icon(
Icons.account_circle_rounded,
color: Color(0xFFFFB21A),
size: 80,
),

const SizedBox(height: 18),

const Text(
'تسجيل الدخول',
textDirection: TextDirection.rtl,
style: TextStyle(
color: Colors.white,
fontSize: 34,
fontWeight: FontWeight.w900,
),
),

const SizedBox(height: 8),

const Text(
'أدخل بياناتك للوصول إلى النظام',
textDirection: TextDirection.rtl,
style: TextStyle(
color: Color(0xFFFFD166),
fontSize: 17,
),
),

const SizedBox(height: 28),

TextField(
keyboardType: TextInputType.number,
decoration: InputDecoration(
hintText: 'ID',
prefixIcon: const Icon(
Icons.person_outline,
color: Color(0xFFFFC13D),
),
filled: true,
fillColor: const Color(0xFF21170F),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(18),
borderSide: BorderSide.none,
),
),
),

const SizedBox(height: 16),

TextField(
  controller: passwordController,
obscureText: true,
decoration: InputDecoration(
hintText: 'كلمة المرور',
prefixIcon: const Icon(
Icons.lock_outline,
color: Color(0xFFFFC13D),
),
filled: true,
fillColor: const Color(0xFF21170F),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(18),
borderSide: BorderSide.none,
),
),
),

const SizedBox(height: 25),

const Align(
alignment: Alignment.centerRight,
child: Text(
'اختر المنصة',
textDirection: TextDirection.rtl,
style: TextStyle(
color: Color(0xFFFFD166),
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
),

const SizedBox(height: 14),
  Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedPlatform = 'Melbet';
            });
          },
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF21170F),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selectedPlatform == 'Melbet'
                    ? const Color(0xFFFFB21A)
                    : Colors.white12,
                width: 2,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/melbet.webp',
                width: 105,
                height: 75,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),

      const SizedBox(width: 14),

      Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedPlatform = '1xBet';
            });
          },
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF21170F),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selectedPlatform == '1xBet'
                    ? const Color(0xFFFFB21A)
                    : Colors.white12,
                width: 2,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/1xbet.jpeg',
                width: 105,
                height: 75,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    ],
  ),

  const SizedBox(height: 28),

  SizedBox(
    width: double.infinity,
    height: 62,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF8A1F),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: () {
        if (passwordController.text.trim() == 'D0194') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PredictorPage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'كلمة المرور غير صحيحة',
                textDirection: TextDirection.rtl,
              ),
            ),
          );
        }
      },
      child: const Text(
        'دخول إلى النظام',
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w900,
        ),
      ),
    ),
  ),
],
),
),
),
),
),
);
}
}

class VipPage extends StatefulWidget {
  const VipPage({super.key});

  @override
  State<VipPage> createState() => _VipPageState();
}

class _VipPageState extends State<VipPage> {
  DateTime? vipUntil;
  Timer? vipTimer;
  Duration remaining = Duration.zero;

  void startVipTimer(DateTime until) {
    vipTimer?.cancel();

    setState(() {
      vipUntil = until;
      remaining = until.difference(DateTime.now().toUtc());
    });

    vipTimer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        final left = until.difference(DateTime.now().toUtc());

        if (left <= Duration.zero) {
          vipTimer?.cancel();

          setState(() {
            vipUntil = null;
            remaining = Duration.zero;
          });
        } else {
          setState(() {
            remaining = left;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    vipTimer?.cancel();
    super.dispose();
  }
  bool get isVipActive {
    return vipUntil != null && remaining > Duration.zero;
  }

  String get remainingText {
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

static const String wallet =
'0x51cc4b4407d8ad80450e6a66adebd58941824f64';

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFF050505),
appBar: AppBar(
backgroundColor: Colors.transparent,
elevation: 0,
title: const Text(
'D0194 VIP',
style: TextStyle(
color: Color(0xFFFFC107),
fontWeight: FontWeight.w900,
),
),
),
body: SafeArea(
child: Center(
child: SingleChildScrollView(
padding: const EdgeInsets.all(22),
child: Container(
constraints: const BoxConstraints(maxWidth: 520),
padding: const EdgeInsets.all(28),
decoration: BoxDecoration(
color: const Color(0xFF10131C),
borderRadius: BorderRadius.circular(30),
border: Border.all(
color: const Color(0xFFFFC107),
width: 2,
),
boxShadow: const [
BoxShadow(
color: Color(0x55FFC107),
blurRadius: 35,
spreadRadius: 2,
),
],
),
child: Column(
children: [
const Icon(
Icons.workspace_premium_rounded,
color: Color(0xFFFFC107),
size: 75,
),

const SizedBox(height: 15),

const Text(
'VIP ACCESS',
style: TextStyle(
color: Color(0xFFFFD54F),
fontSize: 30,
fontWeight: FontWeight.w900,
letterSpacing: 3,
),
),

const SizedBox(height: 8),

const Text(
'10 USDT  •  1 HOUR',
style: TextStyle(
color: Colors.white,
fontSize: 22,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 28),

Container(
width: double.infinity,
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: const Color(0xFF171B26),
borderRadius: BorderRadius.circular(20),
border: Border.all(color: Colors.white12),
),
child: const Column(
children: [
Text(
'NETWORK',
style: TextStyle(color: Colors.white54),
),
SizedBox(height: 6),
Text(
'BSC (BEP20)',
style: TextStyle(
color: Color(0xFFFFC107),
fontSize: 21,
fontWeight: FontWeight.w900,
),
),
SizedBox(height: 20),
Text(
'USDT WALLET',
style: TextStyle(color: Colors.white54),
),
SizedBox(height: 8),
SelectableText(
wallet,
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.white,
fontSize: 14,
),
),
],
),
),

const SizedBox(height: 22),
  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFF19130A),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: const Color(0x55FFC107),
      ),
    ),
    child: const Column(
      children: [
        Text(
          'طريقة التفعيل',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: Color(0xFFFFD54F),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 12),
        Text(
          '1. أرسل 10 USDT فقط عبر شبكة BSC (BEP20)\n'
              '2. تأكد من عنوان المحفظة قبل الإرسال\n'
              '3. بعد الدفع أدخل TXID للتحقق من العملية\n'
              '4. بعد نجاح التحقق يتم تفعيل VIP لمدة ساعة واحدة',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
            height: 1.7,
          ),
        ),
      ],
    ),
  ),

  const SizedBox(height: 22),

  TextField(
    decoration: InputDecoration(
      hintText: 'TXID / Transaction Hash',
      hintStyle: const TextStyle(color: Colors.white38),
      prefixIcon: const Icon(
        Icons.receipt_long_rounded,
        color: Color(0xFFFFC107),
      ),
      filled: true,
      fillColor: const Color(0xFF171B26),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    ),
  ),

  const SizedBox(height: 18),

  SizedBox(
    width: double.infinity,
    height: 60,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFC107),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: isVipActive
          ? null
          : () async {

        final vipUntil = await Navigator.push<DateTime>(
          context,
          MaterialPageRoute(
            builder: (context) => const VipOfferPage(),
          ),
        );

        if (vipUntil == null) return;

        startVipTimer(vipUntil);
      },

      child: Text(
        isVipActive
            ? 'VIP ACTIVE • $remainingText'
            : 'VERIFY PAYMENT',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    ),
  ),

  const SizedBox(height: 14),

  const Text(
    'VIP لن يتم تفعيله قبل تأكيد معاملة 10 USDT على شبكة BSC.',
    textDirection: TextDirection.rtl,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white54,
      fontSize: 13,
    ),
  ),
],
),
),
),
),
),
);
}
}

class VipOfferPage extends StatelessWidget {
  const VipOfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060606),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 460),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF101820),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color(0xFFFFC107),
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x55FFC107),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    color: Color(0xFFFFC107),
                    size: 70,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'D0194 VIP ACCESS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFC107),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'افتح الوصول الحصري الآن',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  _vipLine(
                    Icons.lock_open,
                    'وصول حصري إلى محتوى VIP',
                  ),

                  const SizedBox(height: 15),

                  _vipLine(
                    Icons.bolt,
                    'تفعيل سريع بعد تأكيد الدفع',
                  ),

                  const SizedBox(height: 15),

                  _vipLine(
                    Icons.timer,
                    'ساعة كاملة من وصول VIP',
                  ),

                  const SizedBox(height: 15),

                  _vipLine(
                    Icons.diamond_outlined,
                    'واجهة خاصة للمشتركين',
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    '10 USDT',
                    style: TextStyle(
                      color: Color(0xFFFFC107),
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const Text(
                    '1 HOUR ACCESS',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      // يفتح مباشرة صفحة الدفع القديمة
                      onPressed: () async {
                        final vipUntil =
                        await Navigator.push<DateTime>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const PaymentMethodsPage(),
                          ),
                        );

                        if (vipUntil != null && context.mounted) {
                          Navigator.pop(context, vipUntil);
                        }
                      },

                      child: const Text(
                        'UNLOCK VIP ACCESS',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'اضغط للانتقال إلى صفحة الدفع وإكمال التفعيل',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _vipLine(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0x22FFC107),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFFFC107),
            size: 22,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Text(
            text,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Payment Methods',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: const [
          PaymentMethodTile(
            title: 'VISA • Mastercard • Discover',
            provider: 'Airwallex',
            bonus: '+26%',
            icon: Icons.credit_card,
            imagePaths: [
              'assets/visa.jpg',
              'assets/mastercard.jpg',
              'assets/diners_club.jpg',
              'assets/jcb.jpg',
              'assets/discover.jpg',
            ],
          ),
          PaymentMethodTile(
            title: 'VISA • Mastercard • AMEX',
              provider: 'Checkout',
              bonus: '+26%',
              icon: Icons.credit_card,
              imagePaths: [
                'assets/visa.jpg',
                'assets/mastercard.jpg',
                'assets/american_express.jpg',
              ],
            ),
          PaymentMethodTile(
            title: 'USDT BSC (BEP20)',
            provider: 'USDT PAY',
            bonus: '+27%',
            icon: Icons.currency_bitcoin,
            imagePaths: [
              'assets/usdt.jpg',
              'assets/usd_pay.jpg',
            ],
          ),

        ],
      ),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final String title;
  final String provider;
  final String bonus;
  final IconData icon;
  final List<String>? imagePaths;

  const PaymentMethodTile({
    super.key,
    required this.title,
    required this.provider,
    required this.bonus,
    required this.icon,
    this.imagePaths,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
          if (title.startsWith('USDT')) {
            final response = await http.post(
              Uri.parse('http://localhost:3000/create-payment'),
            );
            final data = jsonDecode(response.body);

            final String paymentId = data['paymentId'].toString();
            String paymentStatus = 'waiting';
            String? paymentVipUntil;

            Future<void> checkPaymentStatus() async {
              final statusResponse = await http.get(
                Uri.parse('http://localhost:3000/payment-status/$paymentId'),
              );

              final statusData = jsonDecode(statusResponse.body);
              paymentStatus = statusData['status'].toString();
              paymentVipUntil = statusData['vipUntil']?.toString();

              debugPrint('PAYMENT STATUS: $paymentStatus');
            }
            Future<void>(() async {
              while (paymentStatus == 'waiting') {
                await checkPaymentStatus();

                if (paymentStatus == 'paid') {
                  break;
                }

                await Future.delayed(const Duration(seconds: 5));
              }
            });
            final String paymentAmount = data['amount'].toString();
            final String paymentAddress = data['address'].toString();
            final depositAddress = paymentAddress;
            final amountController =
            TextEditingController(text: paymentAmount);
            await showDialog<DateTime>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                backgroundColor: const Color(0xFF1E2734),
                title: const Text(
                  'Deposit USDT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: SizedBox(
                  width: 380,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: amountController,
                        readOnly: true,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          suffixText: 'USDT',
                          labelStyle: const TextStyle(color: Colors.grey),
                          suffixStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF273342),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          color: Colors.white,
                          child: QrImageView(
                            data: depositAddress,
                            size: 220,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Network',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'BSC',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'BNB Smart Chain (BEP20)',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const Divider(height: 30),
                      const Text(
                        'Deposit Address',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: SelectableText(
                              depositAddress,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: Colors.white),
                            onPressed: () {
                              Clipboard.setData(
                                 ClipboardData(text: depositAddress),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Address copied'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Send USDT using BSC (BEP20) network only.',
                        style: TextStyle(color: Colors.orange),
                      ),

                    const SizedBox(height: 20),
                      const SizedBox(height: 14),


                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        child: const Text('I have paid'),
                      ),
                    ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          }
        },
        child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E5E5),
          ),
        ),
      ),
      child: Row(
        children: [

      imagePaths != null && imagePaths!.isNotEmpty
        ? Row(
        mainAxisSize: MainAxisSize.min,
        children: imagePaths!
            .map(
              (path) => Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Image.asset(
              path,
              width: 48,
              height: 34,
              fit: BoxFit.contain,
            ),
          ),
        )
            .toList(),
      )
          : Icon(
      icon,
      size: 46,
      color: const Color(0xFF45B99A),
    ),
          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  provider,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF633E),
                      Color(0xFFFF20B7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  bonus,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
                size: 34,
              ),
            ],
          ),
        ],
      ),
        ),
    );
  }
}