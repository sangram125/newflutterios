import 'package:dio/dio.dart';
import 'package:dor_companion/data/models/get_issue_item_model.dart';

import '../models/get_ticket_item_model.dart';

class ApiService {
  static final ApiService _singleton = ApiService._internal();

  factory ApiService() {
    return _singleton;
  }

  ApiService._internal();

  final String _apiUrlBase = 'https://prod.streamboxmedia.com/api/resource/';
  final String _authToken = '5a55c92635e76a4:341a71ee208ab13';
  final Dio _dio = Dio();

  void _setHeaders() {
    _dio.options.headers['Authorization'] = 'Token $_authToken';
  }

  Future<List<Name>> fetchTicketTypeData({String? filter}) async {
    _setHeaders();
    final String apiUrl = '${_apiUrlBase}Ticket Type';
    final Map<String, dynamic> queryParams = {
      'filters': '[["ticket_category","=","$filter"]]',
    };

    try {
      Response response = await _dio.get(apiUrl, queryParameters: queryParams);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        List<Name> itemList = data.map((json) => Name.fromJson(json)).toList();
        return itemList;
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<Name>> fetchCategoryData() async {
    _setHeaders();
    final String apiUrl = '${_apiUrlBase}Ticket%20Category';

    try {
      Response response = await _dio.get(apiUrl);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        List<Name> itemList = data.map((json) => Name.fromJson(json)).toList();
        return itemList;
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<Name>> fetchTicketItemData({String? filter}) async {
    _setHeaders();
    final String apiUrl = '${_apiUrlBase}Ticket Item';
    final Map<String, dynamic> queryParams = {
      'filters': '[["ticket_type","=","$filter"]]',
    };

    try {
      Response response = await _dio.get(apiUrl, queryParameters: queryParams);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        List<Name> itemList = data.map((json) => Name.fromJson(json)).toList();
        return itemList;
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<Issue>> getIssueList({required String mobileNumber}) async {
    _setHeaders();
    final String apiUrl = '${_apiUrlBase}Issue';
    final Map<String, dynamic> queryParams = {
      'fields': '["*"]',
      'filters': '[["customer","=","$mobileNumber"]]',
    };

    try {
      Response response = await _dio.get(apiUrl, queryParameters: queryParams);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        List<Issue> itemList =
            data.map((json) => Issue.fromJson(json)).toList();
        return itemList;
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<dynamic>> getCustomer({required String mobileNumber}) async {
    _setHeaders();
    final String apiUrl = '${_apiUrlBase}Customer';
    final Map<String, dynamic> queryParams = {
      'fields': '["*"]',
      'filters': '[["mobile_no","=","$mobileNumber"]]',
    };

    try {
      Response response = await _dio.get(apiUrl, queryParameters: queryParams);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        // List<Issue> itemList = data.map((json) => Issue.fromJson(json)).toList();
        return data;
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> createIssue({
    required String subject,
    required String customer,
    required String status,
    required String issueSource,
    required String ticketItem,
    required String description,
    required String openingDate,
    required String openingTime,
  }) async {
    _setHeaders();
    final String apiUrl = '${_apiUrlBase}Issue';
    final Map<String, dynamic> data = {
      'subject': subject,
      'customer': customer,
      'status': status,
      'custom_issue_source': issueSource,
      'custom_ticket_item': ticketItem,
      'description': description,
      'opening_date': openingDate,
      'opening_time': openingTime,
    };

    try {
      final Response response = await _dio.post(apiUrl, data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Issue created successfully');
        print(response.data);
      } else {
        print('Failed to create issue');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> closeTicket({
    required String resolutionBy,
    required String resolutionDetails,
    required String resolutionDate,
    required String resolutionTime,
    required String customerResolutionTime,
    required String subject,
    required String customer,
    required String description,
    required String ticketId,
  }) async {
    _setHeaders();
    final String apiUrl = '${_apiUrlBase}Issue';
    final Map<String, dynamic> data = {
      'resolution_by': resolutionBy,
      'resolution_details': resolutionDetails,
      'resolution_date': resolutionDate,
      'resolution_time': resolutionTime,
      'user_resolution_time': customerResolutionTime,
      'name': ticketId,
      'subject': subject,
      'customer': customer,
      'description': description,
    };

    try {
      final Response response = await _dio.post(apiUrl, data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Ticket closed successfully');
        print(response.data);
      } else {
        print('Failed to close ticket');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<Issue>> getSameIssue(
      {required String mobileNumber, required String customTicketItem}) async {
    _setHeaders();
    final String apiUrl = '${_apiUrlBase}Issue';
    final Map<String, dynamic> queryParams = {
      'fields': '["*"]',
      'filters': '[["customer","=","$mobileNumber"],["status","=","Open"],'
          '["custom_ticket_item","=","$customTicketItem"]]',
    };

    try {
      Response response = await _dio.get(apiUrl, queryParameters: queryParams);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        List<Issue> itemList =
            data.map((json) => Issue.fromJson(json)).toList();
        return itemList;
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to fetch data');
    }
  }

  Future<dynamic> getWikiArticles(
      {required String mobileNumber, required String customTicketItem}) async {
    _setHeaders();
    final String apiUrl = '${_apiUrlBase}Wiki Page';
    final Map<String, dynamic> queryParams = {
      'fields': '["*"]',
      'filters': '[["custom_ticket_item","=","$customTicketItem"]]',
    };

    try {
      Response response = await _dio.get(apiUrl, queryParameters: queryParams);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        var itemList = data.map((json) => Issue.fromJson(json)).toList();
        print("item lkst $data");
        return data;
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to fetch data');
    }
  }

  whatsAppLogin() async {
    _setHeaders();
    final String apiUrl = 'https://apis.rmlconnect.net/auth/v1/login/';
    final Map<String, dynamic> data = {
      "username": "Streambox",
      "password": "Asdfgh\$\$13"
    };

    try {
      final Response response = await _dio.post(apiUrl, data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
        print(response.data);
      } else {
        print('Failed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  sendingMessageToWhatsApp(
      String token, String userMobileNo, String userName) async {
    final Dio _dio = Dio();

    _dio.options.headers['Authorization'] = '$token';
    final String apiUrl = 'https://apis.rmlconnect.net/wba/v1/messages';
    final Map<String, dynamic> data = {
      "phone": userMobileNo,
      "media": {
        "type": "media_template",
        "template_name": "test_script",
        "lang_code": "en",
        "button": [
          {"button_no": "0", "payload": "Hi"},
          {"button_no": "1", "payload": "Help"},
          {"button_no": "2", "payload": "Call at 9088360360"}
        ],
        "body": [
          {"text": userName},
          {"text": "Greetings"},
          {"text": "Curious? Check out"},
          {"text": "FAQs"},
          {"text": "roll"},
          {"text": "hiccup"},
          {"text": "Wanna chat"},
          {"text": "Talk"},
          {"text": "Agent"}
        ]
      }
    };

    try {
      final Response response = await _dio.post(apiUrl, data: data);
      if (response.statusCode == 200 || response.statusCode == 202) {
        return response.data;
      } else {
        print('Failed to create issue');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
