import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PortfolioListScreen extends StatefulWidget {
  final String authToken; // 추가
  const PortfolioListScreen({super.key, required this.authToken});

  @override
  State<PortfolioListScreen> createState() => _PortfolioListScreenState();
}

class _PortfolioListScreenState extends State<PortfolioListScreen> {
  List<dynamic> _portfolios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPortfolios();
  }

  Future<void> _fetchPortfolios() async {
    try {
      final url = Uri.parse('http://13.54.117.136:3000/portfolio'); // <-- 여기 IP 수정!
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.authToken}', // 헤더에 토큰 추가
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // 이거 추가!

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _portfolios = data;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load portfolios');
      }
    } catch (e) {
      print('Error fetching portfolios: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio List'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _portfolios.isEmpty
          ? const Center(child: Text('No portfolios found'))
          : ListView.builder(
        itemCount: _portfolios.length,
        itemBuilder: (context, index) {
          final portfolio = _portfolios[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(portfolio['title'] ?? 'No Title'),
              subtitle: Text(portfolio['description'] ?? 'No Description'),
            ),
          );
        },
      ),
    );
  }
}
