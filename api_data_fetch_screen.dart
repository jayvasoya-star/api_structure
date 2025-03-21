import 'package:api_structure/enums.dart';
import 'package:flutter/material.dart';
import 'package:api_structure/api_service.dart';
import 'package:api_structure/api_service_impl.dart';

class ApiDataFetchScreen extends StatefulWidget {
  final String endpoint;
  final String screenName;

  const ApiDataFetchScreen({
    super.key,
    required this.endpoint,
    required this.screenName,
  });

  @override
  State<ApiDataFetchScreen> createState() => _ApiDataFetchScreenState();
}

class _ApiDataFetchScreenState extends State<ApiDataFetchScreen> {
  final ApiService _apiService = ApiServiceImpl();
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final response = await _apiService.callApi<List<Map<String, dynamic>>>(
      type: ApiCallType.get,
      endpoint: widget.endpoint,
      screenName: widget.screenName,
      fromJson: (json) {
        return List<Map<String, dynamic>>.from(json['data']);
      },
    );

    response.fold(
      (error) {
        setState(() {
          _isLoading = false;
          _errorMessage = error.message;
        });
      },
      (data) {
        setState(() {
          _isLoading = false;
          _data = data;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.screenName)),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text('Error: $_errorMessage'))
              : ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  final item = _data[index];
                  return ListTile(
                    title: Text(item['title'] ?? 'No Title'),
                    subtitle: Text(item['body'] ?? 'No Body'),
                  );
                },
              ),
    );
  }
}
