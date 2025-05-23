import 'package:dio/dio.dart';

class HuggingFaceAPI {
  final Dio _dio;
  final String _baseUrl = 'https://api-inference.huggingface.co/models';
  
  HuggingFaceAPI({String? apiKey}) : _dio = Dio() {
    _dio.options.headers['Authorization'] = 'Bearer ${apiKey ?? const String.fromEnvironment('HUGGINGFACE_API_KEY')}';
  }

  Future<Map<String, dynamic>> textClassification(String text, {String model = 'facebook/bart-large-mnli'}) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/$model',
        data: {'inputs': text},
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to classify text: $e');
    }
  }

  Future<Map<String, dynamic>> imageToText(List<int> imageBytes, {String model = 'Salesforce/blip-image-captioning-base'}) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/$model',
        data: imageBytes,
        options: Options(
          headers: {'Content-Type': 'application/octet-stream'},
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to process image: $e');
    }
  }

  Future<List<Map<String, dynamic>>> extractEntities(String text, {String model = 'dslim/bert-base-NER'}) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/$model',
        data: {'inputs': text},
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw Exception('Failed to extract entities: $e');
    }
  }
} 