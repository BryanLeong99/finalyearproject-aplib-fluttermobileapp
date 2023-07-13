import 'package:ap_lib/booking/discussion_room_list.dart';
import 'package:ap_lib/booking/discussion_room_schedule.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'booking_response.dart';
import 'booking_details.dart';

class RoomDataFetcher {

  List<DiscussionRoomList> parseDiscussionRoomList(String responseBody) {
    print(responseBody);
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<DiscussionRoomList>((json) => DiscussionRoomList.fromJson(json)).toList();
  }

  Future<List<DiscussionRoomList>> getAllRoom(bool availability) async {
    var url = Uri.parse(
      "https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/discussion-room/all?" +
        "availability=${availability == true ? 1 : 0}"
    );

    var response = await http.get(url,
      headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Connection': 'keep-alive',
      },
    );

    return parseDiscussionRoomList(response.body);
  }

  List<DiscussionRoomSchedule> parseDiscussionRoomSchedule(String responseBody) {
    print(responseBody);
    var parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<DiscussionRoomSchedule>((json) => DiscussionRoomSchedule.fromJson(json)).toList();
  }

  Future<List<DiscussionRoomSchedule>> getRoomSchedule(String roomId) async {
    var url = Uri.parse(
      'https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/discussion-room/schedule?' +
        'room_id=$roomId'
    );

    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return parseDiscussionRoomSchedule(response.body);
  }

  List<BookingDetails> parseBookingDetails(String responseBody) {
    print(responseBody);
    var parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<BookingDetails>((json) => BookingDetails.fromJson(json)).toList();
  }

  Future<List<BookingDetails>> getBookingDetails(String userToken) async {
    var url = Uri.parse(
        'https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/booking/details?' +
            'user_token=$userToken'
    );

    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return parseBookingDetails(response.body);
  }

  Future<BookingResponse> confirmBookingAPICall(String startingTime, String duration,
      String numOfPerson, String roomId, String description, String userToken) async {
    var url = Uri.parse('https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/booking/new?' +
      'starting_time=$startingTime' +
      '&duration=$duration' +
      '&num_of_person=$numOfPerson' +
      '&room_id=$roomId' +
      '&description=$description' +
      '&user_token=$userToken'
    );

    var response = await http.post(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );
    print(response.body);

    return BookingResponse.fromJson(jsonDecode(response.body));
  }

  Future<BookingResponse> createBooking(String startingTime, String duration,
      String numOfPerson, String roomId, String description, String userToken) async {
    BookingResponse status;
    await confirmBookingAPICall(startingTime, duration, numOfPerson, roomId, description, userToken).then((response) async => {
      status = response,
    });

    return status;
  }

  Future<String> updateBookingStatus(String bookingId, String status) async {
    String statusString;
    await updateBookingStatusAPICall(bookingId, status).then((response) async => {
      statusString = response.statusString,
    });
    return statusString;
  }

  Future<BookingResponse> updateBookingStatusAPICall(String bookingId, String status) async {
    var url = Uri.parse('https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/booking/access?'
        'booking_id=$bookingId'
        '&access=$status'
    );

    var response = await http.put(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );
    print(response.body);

    return BookingResponse.fromJson(jsonDecode(response.body));
  }
}