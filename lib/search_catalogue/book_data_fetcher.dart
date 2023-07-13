import 'dart:convert';

import 'package:ap_lib/search_catalogue/book_list.dart';
import 'package:ap_lib/search_catalogue/book_model.dart';
import 'package:http/http.dart' as http;

class BookDataFetcher {

  // parse the json string to a list of BookList objects
  List<BookList> parseBookList(String responseBody) {
    // print the response body for debugging purpose
    print(responseBody);

    // parse and return the json string to a list of BookList objects
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<BookList>((json) => BookList.fromJson(json)).toList();
  }

  // return an asynchronous list of BookList objects
  Future<List<BookList>> executeSearch(String keywordCriteria, String initialIndex,
      String keyword, String collectionType, String minYear, String maxYear,
      String subject, String availability, String sort) async {
    // parse the URL for API calling
    var url = Uri.parse(
      'https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/search/' +
        '$keywordCriteria?' +
        'initial_index=$initialIndex' +
        '&keyword=$keyword' +
        '&collection=$collectionType' +
        '&min_year=$minYear' +
        '&max_year=$maxYear' +
        '&subject=$subject' +
        '&availability=$availability' +
        '&sort=$sort'
    );

    // call API to retrieve data from cloud
    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    // parse the list of BookList objects by passing the response JSON string
    return parseBookList(response.body);
  }

  Future<BookModel> getBookDetails(String itemId) async {
    var url = Uri.parse(
      'https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/book/details/?' +
        'item_id=$itemId'
    );
    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    print(jsonDecode(response.body));

    return BookModel.fromJson(jsonDecode(response.body));
  }

  Future<List<BookList>> searchWithCode(String barcode) async {
    var url = Uri.parse(
        'https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/search/code?' +
            'barcode=$barcode'
    );

    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return parseBookList(response.body);
  }
}