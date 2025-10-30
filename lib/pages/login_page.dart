import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:task_manager_app/pages/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _TapWaterPasswordPageState();
}

class _TapWaterPasswordPageState extends State<LoginPage>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;
  late AnimationController _tapController;
  String password = "";

  double getPasswordStrength(String pass) {
    if (pass.isEmpty) return 0;
    if (pass.length < 4) return 0.3;
    if (pass.length < 6) return 0.6;
    if (pass.length < 8) return 0.8;
    return 1.0;
  }

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void onPasswordChanged(String value) {
    setState(() => password = value);

    double strength = getPasswordStrength(value);

    if (strength >= 0.8) {
      // strong password → stop water, close tap
      _lottieController.stop();
      _tapController.forward();
    } else {
      // weak password → water flows, tap opens
      _lottieController.repeat();
      _tapController.reverse();
    }
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stack tap and water animation
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  AnimatedBuilder(
                    animation: _tapController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: -_tapController.value * 0.3,
                        child: Image.asset(
                          'assets/images/icons8_faucet_96.png',
                          height: 100,
                          color: Colors.blue,
                        ),
                      );
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: Lottie.asset(
                      'assets/animation/water drop.json',
                      controller: _lottieController,
                      height: 150,
                      onLoaded: (composition) {
                        _lottieController
                          ..duration = composition.duration
                          ..repeat();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              TextField(
                obscureText: true,
                onChanged: onPasswordChanged,
                decoration: const InputDecoration(
                  labelText: 'Enter password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Leaking faucet indicates passord is not strong enough',
                style: TextStyle(fontFamily: 'roboto', fontSize: 15),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Homepage();
                      },
                    ),
                  );
                },
                child: Text('Login', style: TextStyle(fontFamily: 'roboto')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
