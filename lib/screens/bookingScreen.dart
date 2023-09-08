import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../constants/config.dart';
import '../models/bookingModel.dart';

class BookingScreen extends StatefulWidget {
  final String uID;

  BookingScreen({required this.uID});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int bookingsCount = 0;
  late Future<List<Booking>> bookings;

  var formatter = NumberFormat("###,###", "en_US");

  formatNumber(String number) {
    return formatter.format(int.parse(number));
  }

  Future<List<Booking>> fetchBookings() async {
    var uID = widget.uID;
    String url = baseUrl + "/bookings.php?uID=$uID";
    final response = await http.get(
      Uri.parse(url),
    );
    List<dynamic> responseJson = json.decode(response.body);
    return responseJson.map((m) => Booking.fromJson(m)).toList();
  }

  cancelBooking(String bID) async {
    String url = baseUrl + "/bookings.php?bID=$bID";
    final response = await http.delete(
      Uri.parse(url),
    );
    bool success = json.decode(response.body);
    if (success) {
      setState(() {
        bookings = fetchBookings();
        bookings.then((bookingList) {
          setState(() {
            bookingsCount = bookingList.length;
          });
        });
      });
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Booking cancelled',
            ),
          ),
        );
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    bookings = fetchBookings();
    bookings.then((bookingList) {
      setState(() {
        bookingsCount = bookingList.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Booking', style: TextStyle(fontSize: 24)),
      Expanded(
        child: FutureBuilder<List<Booking>>(
          future: bookings,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('No data found'),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Booking item = snapshot.data![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(item.cImage!,
                                loadingBuilder: (context, child,
                                        loadingProgress) =>
                                    loadingProgress == null
                                        ? child
                                        : const CircularProgressIndicator()),
                            Text(
                              '${item.cBrand} ${item.cName}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('Car Type: ${item.cType}'),
                          const SizedBox(height: 8),
                          Text('Passengers: ${item.cPassengers}'),
                          const SizedBox(height: 4),
                          const Divider(),
                          const SizedBox(height: 4),
                          Text('User Name: ${item.uName}'),
                          const SizedBox(height: 8),
                          Text('User Telephone: ${item.uTelephone}'),
                          const SizedBox(height: 4),
                          const Divider(),
                          const SizedBox(height: 4),
                          Text(
                              'Date from ${item.uDateFrom} to ${item.uDateTo}'),
                          const SizedBox(height: 8),
                          Text('Total Price: ' +
                              formatNumber((((DateTime.parse(item.uDateTo!)
                                                  .day -
                                              DateTime.parse(item.uDateFrom!)
                                                  .day) +
                                          1) *
                                      int.parse(item.cPrice!))
                                  .toString()) +
                              ' Baht'),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              FilledButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red)),
                                child: const Text('Cancel Booking'),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Cancel Booking'),
                                        content: const Text('Are you sure?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Confirm'),
                                            onPressed: () {
                                              cancelBooking(item.bID!);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              FilledButton(
                                child: const Text('Edit Booking'),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    '/edit',
                                    arguments: item,
                                  );
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
              ;
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      )
    ]));
  }
}
