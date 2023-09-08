import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/bookingModel.dart';

import 'package:intl/intl.dart';

import '../constants/config.dart';

import 'package:http/http.dart' as http;

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  var formatter = NumberFormat("###,###", "en_US");

  formatNumber(String number) {
    return formatter.format(int.parse(number));
  }

  formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  formatDateApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    Booking item = ModalRoute.of(context)?.settings.arguments as Booking;
    DateTime startDate = DateTime.parse(item.uDateFrom!);
    DateTime endDate = DateTime.parse(item.uDateTo!);
    return StatefulBuilder(builder: (context, setState) {
      return Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Edit Booking', style: TextStyle(fontSize: 24)),
                    Expanded(
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      const Divider(),
                                      const SizedBox(height: 8),
                                      Text('Car Type: ${item.cType}'),
                                      const SizedBox(height: 8),
                                      Text('Passengers: ${item.cPassengers}'),
                                      const SizedBox(height: 8),
                                      Text(
                                          'Price: ${formatNumber(item.cPrice!)} Baht / Day'),
                                      const SizedBox(height: 4),
                                      const Divider(),
                                      const SizedBox(height: 4),
                                      Text('User Name: ${item.uName}'),
                                      const SizedBox(height: 8),
                                      Text(
                                          'User Telephone: ${item.uTelephone}'),
                                      const SizedBox(height: 4),
                                      const Divider(),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Date From'),
                                          TextButton(
                                            onPressed: () async {
                                              final selectedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: startDate,
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2101),
                                              );
                                              if (selectedDate != null &&
                                                  selectedDate != startDate) {
                                                setState(() {
                                                  startDate = selectedDate;
                                                });
                                              }
                                              if (startDate.isAfter(endDate)) {
                                                setState(() {
                                                  endDate = startDate.add(
                                                      const Duration(days: 1));
                                                });
                                              }
                                            },
                                            child: Text(formatDate(startDate)
                                                .toString()),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Date To'),
                                          TextButton(
                                            onPressed: () async {
                                              final selectedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: endDate,
                                                firstDate: startDate,
                                                lastDate: DateTime(2101),
                                              );
                                              if (selectedDate != null &&
                                                  selectedDate != endDate) {
                                                setState(() {
                                                  endDate = selectedDate;
                                                });
                                              }
                                            },
                                            child: Text(
                                                formatDate(endDate).toString()),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      const SizedBox(height: 8),
                                      Center(
                                        child: Text(
                                            'Total Price: ' +
                                                formatNumber(((endDate
                                                                .difference(
                                                                    startDate)
                                                                .inDays +
                                                            1) *
                                                        int.parse(item.cPrice!))
                                                    .toString()) +
                                                ' Baht',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FilledButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.red)),
                                              child: const Text('Cancel')),
                                          const SizedBox(width: 8),
                                          FilledButton(
                                              onPressed: () async {
                                                var url = baseUrl +
                                                    "/update-range-date.php?bID=" +
                                                    item.bID!;
                                                var response = await http.patch(
                                                    Uri.parse(url),
                                                    headers: <String, String>{
                                                      'Content-Type':
                                                          'application/json; charset=UTF-8',
                                                    },
                                                    body: jsonEncode(<String,
                                                        String>{
                                                      'uDateFrom':
                                                          formatDateApi(
                                                              startDate),
                                                      'uDateTo': formatDateApi(
                                                          endDate),
                                                    }));
                                                bool success =
                                                    json.decode(response.body);
                                                if (success) {
                                                  ScaffoldMessenger.of(context)
                                                    ..hideCurrentSnackBar()
                                                    ..showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Booking updated successfully.'),
                                                      ),
                                                    );
                                                  var uID = item.uID.toString();
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context, '/',
                                                          arguments: uID);
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title:
                                                            const Text('Error'),
                                                        content: const Text(
                                                            'Something went wrong. Please try again later.'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                'OK'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: const Text('Save')),
                                        ],
                                      )
                                    ]),
                              ]),
                        ),
                      ),
                    ),
                  ])));
    });
  }
}
