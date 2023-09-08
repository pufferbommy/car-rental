import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../constants/config.dart';
import '../models/CatalogModel.dart';

class CatalogsScreen extends StatefulWidget {
  final String uID;

  CatalogsScreen({required this.uID});

  @override
  _CatalogsScreenState createState() => _CatalogsScreenState();
}

class _CatalogsScreenState extends State<CatalogsScreen> {
  String brand = 'All';

  List<String> brandOptions = ['All'];

  int catalogsCount = 0;
  late Future<List<Catalog>> catalogs;

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

  Future<List<Catalog>> fetchCatalogs() async {
    var url = "$baseUrl/catalogs.php?brand=$brand";
    final response = await http.get(
      Uri.parse(url),
    );
    List<dynamic> responseJson = json.decode(response.body);
    return responseJson.map((m) => Catalog.fromJson(m)).toList();
  }

  Future showMoreCatalogInfo(Catalog item) => showDialog(
      context: context,
      builder: (context) {
        DateTime startDate = DateTime.now();
        DateTime endDate = startDate;

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('${item.cBrand} ${item.cName}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
              FilledButton(
                child: const Text('Book'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Booking'),
                        content: const Text(
                            'Are you sure you want to book this car?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FilledButton(
                            child: const Text('Confirm'),
                            onPressed: () async {
                              const url = baseUrl + "/bookings.php";
                              var response = await http.post(Uri.parse(url),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                  body: jsonEncode(<String, String>{
                                    'uID': widget.uID,
                                    'cID': item.cID,
                                    'uDateFrom': formatDateApi(startDate),
                                    'uDateTo': formatDateApi(endDate),
                                  }));
                              bool success = json.decode(response.body);
                              if (success) {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Booking successful. Please check your booking status in the Booking tab.'),
                                    ),
                                  );
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text(
                                          'Something went wrong. Please try again later.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    item.cImage,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Name'),
                      Text(item.cName),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Brand'),
                      Text(item.cBrand),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Type'),
                      Text(item.cType),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Passengers'),
                      Text(item.cPassengers),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Price'),
                      Text('${formatNumber(item.cPrice)} Baht / Day')
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Date From'),
                      TextButton(
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
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
                              endDate = startDate.add(const Duration(days: 1));
                            });
                          }
                        },
                        child: Text(formatDate(startDate).toString()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Date To'),
                      TextButton(
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: endDate,
                            firstDate: startDate,
                            lastDate: DateTime(2101),
                          );
                          if (selectedDate != null && selectedDate != endDate) {
                            setState(() {
                              endDate = selectedDate;
                            });
                          }
                        },
                        child: Text(formatDate(endDate).toString()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Price'),
                      Text(formatNumber((((endDate.day - startDate.day) + 1) *
                                  int.parse(item.cPrice))
                              .toString()) +
                          ' Baht'),
                    ],
                  ),
                ]),
          );
        });
      });

  @override
  void initState() {
    super.initState();
    catalogs = fetchCatalogs();
    catalogs.then((catalogList) {
      setState(() {
        for (var item in catalogList) {
          if (!brandOptions.contains(item.cBrand)) {
            brandOptions.add(item.cBrand);
          }
        }
        catalogsCount = catalogList.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('Catalogs', style: TextStyle(fontSize: 24)),
          const Spacer(),
          Chip(
            label: Text('$catalogsCount items'),
          )
        ],
      ),
      const SizedBox(height: 16),
      Row(children: <Widget>[
        for (var item in brandOptions)
          GestureDetector(
            onTap: () {
              setState(() {
                brand = item;
                catalogs = fetchCatalogs();
                catalogs.then((catalogList) {
                  setState(() {
                    for (var item in catalogList) {
                      if (!brandOptions.contains(item.cBrand)) {
                        brandOptions.add(item.cBrand);
                      }
                    }
                    catalogsCount = catalogList.length;
                  });
                });
              });
            },
            child: Chip(
              label: Text(item),
              backgroundColor: brand == item ? Colors.blue : Colors.grey,
              labelStyle:
                  TextStyle(color: brand == item ? Colors.white : Colors.black),
            ),
          ),
      ]),
      const SizedBox(height: 16),
      Expanded(
        child: FutureBuilder<List<Catalog>>(
          future: catalogs,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data![index];
                  return GestureDetector(
                    onTap: () => showMoreCatalogInfo(item),
                    child: Card(
                      child: ListTile(
                        leading: Image.network(
                          item.cImage,
                          loadingBuilder: (context, child, loadingProgress) =>
                              loadingProgress == null
                                  ? child
                                  : const CircularProgressIndicator(),
                        ),
                        title: Text(item.cName),
                        subtitle: Text(item.cBrand),
                        trailing:
                            Text('${formatNumber(item.cPrice)} Baht / Day'),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    ]));
  }
}
