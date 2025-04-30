import 'package:flutter/material.dart';
import 'package:porfyouapp/screens/portfolio_list_screen.dart'; // import 수정
import 'package:porfyouapp/screens/home_screen.dart'; // import 수정
import 'package:porfyouapp/styles/text_styles.dart';
import 'package:porfyouapp/styles/colors.dart';
import 'package:porfyouapp/widgets/auth/login_form.dart';
import 'package:porfyouapp/widgets/common/app_logo.dart';

import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON 인코딩/디코딩

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _authToken; // 로그인 성공 후 토큰 저장용

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://13.54.117.136:3000/auth/signin'); // <-- 수정할 부분
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      // 로그인 성공
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(response.body);
      _authToken = responseData['accessToken']; // 토큰 저장

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(authToken: _authToken!),
        ),
      );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => PortfolioListScreen(authToken: _authToken!)),
      // );
    } else {
      // 로그인 실패
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: Text('Error: ${response.statusCode} ${response.reasonPhrase}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // 배경 밝게
        body: Center(
            child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
            child: Column(
              children: [
                const AppLogo(),
                const SizedBox(height: 32),
                LoginForm(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  isLoading: _isLoading,
                  onLogin: _login,
                ),
              ],
            ),
          ),
        ),
    );
  }
}
