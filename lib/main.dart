import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:efficient_flutter_task/csv_loader.dart';
import 'package:efficient_flutter_task/data_model.dart';
import 'package:efficient_flutter_task/feedback_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FormData formData;
  late List<List<dynamic>> csvData;
  late List<dynamic> columnData;

  Map<String, dynamic> formDataForStore = {};

  TextEditingController widgetTypeTextEditingController =
      TextEditingController();
  TextEditingController productTypeTextEditingController =
      TextEditingController();

  late Widget filteredDataWidget;
  String selectedValue = "initialValue";
  String setWidgetState = "";

  _loadData() async {
    String jsonContent =
        await rootBundle.loadString('assets/json/response.json');
    formData = FormData.fromJson(json.decode(jsonContent));
    csvData = await CsvLoader.loadCsv('assets/csv/fruit_prices.csv');
  }

  @override
  void initState() {
    super.initState();

    formDataForStore = {};
    formData = FormData();
    widgetTypeTextEditingController = TextEditingController();
    productTypeTextEditingController = TextEditingController();
    csvData = [];
    columnData = [];
    selectedValue = "initialValue";
    setWidgetState = "";
    _loadData();
  }

  @override
  void dispose() {
    widgetTypeTextEditingController.dispose();
    productTypeTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          child: Text(formData.formName.toString()),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FeedBackPage(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: formData.sections == null
            ? SizedBox.fromSize(
                size: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: formData.sections!.map<Widget>((section) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Text(
                              section.name.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: (){
                              log("Store Data : $formDataForStore");
                            },
                          ),
                        ),
                        ...section.fields!.map<Widget>((field) {
                          return buildFormField(field);
                        }),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Widget Type",
                            ),
                            onFieldSubmitted: (value) {
                              setState(() {
                                searchFromCSV(value);
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        setWidgetState == "viewText_1" ||
                                productTypeTextEditingController.text ==
                                    "viewText_2"
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: columnData.isEmpty
                                    ? const Text("No data found")
                                    : SizedBox(
                                        height: 500,
                                        child: ListView.builder(
                                          itemCount: columnData.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                  columnData[index].toString()),
                                            );
                                          },
                                        ),
                                      ),
                              )
                            : const SizedBox.shrink(),
                        setWidgetState == "image_1"
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: columnData.isEmpty
                                    ? const Text("No data found")
                                    : SizedBox(
                                        height: 500,
                                        child: ListView.builder(
                                          itemCount: columnData.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Image.network(columnData[index]),
                                            );
                                          },
                                        ),
                                      ),
                              )
                            : const SizedBox.shrink(),
                        setWidgetState == "list_1"
                            ? List1Dropdown(
                                columnData: columnData,
                                selectedValue: selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }

  searchFromCSV(String widgetType) async {
    //print("WidgetType : $widgetType");
    if (widgetType == "list_1") {
      searchFromValueMapper("list_1");
    } else if (widgetType == "viewText_1") {
      searchFromValueMapper("viewText_1");
    } else if (widgetType == "viewText_2") {
      searchFromValueMapper("viewText_2");
    } else if (widgetType == "image_1") {
      searchFromValueMapper("image_1");
    }
  }

  //this is for row wise
  // filterData(String keyword) {
  //   setState(() {
  //     columnData = csvData
  //         .where((row) =>
  //             row.length > 1 &&
  //             row[1].toString().toLowerCase().contains(keyword.toLowerCase()))
  //         .toList();
  //     // columnData = extractColumn(csvData, 2);
  //   });
  // }

  searchFromValueMapper(String fieldKey) {
    for (int i = 0; i < formData.valueMapping!.length; i++) {
      for (int j = 0; j < formData.valueMapping![i].displayList!.length; j++) {
        if (fieldKey == formData.valueMapping![i].displayList![j].fieldKey) {
          filterColumnData(
              formData.valueMapping![i].displayList![j].dataColumn.toString(),
              fieldKey);
        }
      }
    }
  }

  void filterColumnData(String dataColumnKeyword, String fieldKey) {
    if (dataColumnKeyword == "ProductCode") {
      setState(() {
        columnData = extractColumn(csvData, 0);
        columnData.removeAt(0);
        selectedValue = columnData[0].toString();
        setWidgetState = fieldKey;
      });
    }
    if (dataColumnKeyword == "Fruit") {
      setState(() {
        columnData = extractColumn(csvData, 1);
        columnData.removeAt(0);
        selectedValue = columnData[0].toString();
        setWidgetState = fieldKey;
      });
    } else if (dataColumnKeyword == "Form") {
      setState(() {
        columnData = extractColumn(csvData, 2);
        columnData.removeAt(0);
        selectedValue = columnData[0].toString();
        setWidgetState = fieldKey;
      });
    } else if (dataColumnKeyword == "RetailPrice") {
      setState(() {
        columnData = extractColumn(csvData, 3);
        columnData.removeAt(0);
        selectedValue = columnData[0].toString();
        setWidgetState = fieldKey;
      });
    } else if (dataColumnKeyword == "RetailPriceUnit") {
      setState(() {
        columnData = extractColumn(csvData, 4);
        columnData.removeAt(0);
        selectedValue = columnData[0].toString();
        setWidgetState = fieldKey;
      });
    } else if (dataColumnKeyword == "Yield") {
      setState(() {
        columnData = extractColumn(csvData, 5);
        columnData.removeAt(0);
        selectedValue = columnData[0].toString();
        setWidgetState = fieldKey;
      });
    } else if (dataColumnKeyword == "CupEquivalentSize") {
      setState(() {
        columnData = extractColumn(csvData, 6);
        columnData.removeAt(0);
        selectedValue = columnData[0].toString();
        setWidgetState = fieldKey;
      });
    } else if (dataColumnKeyword == "CupEquivalentUnit") {
      setState(() {
        columnData = extractColumn(csvData, 7);
        columnData.removeAt(0);
        selectedValue = columnData[0].toString();
        setWidgetState = fieldKey;
      });
    } else if (dataColumnKeyword == "CupEquivalentPrice") {
      setState(() {
        columnData = extractColumn(csvData, 8);
        columnData.removeAt(0);
        selectedValue = columnData[0].toString();
        setWidgetState = fieldKey;
      });
    } else if (dataColumnKeyword == "ProductImage") {
      setState(() {
        columnData = extractColumn(csvData, 9);
        columnData.removeAt(0);
        selectedValue = columnData[0].toString();
        setWidgetState = fieldKey;
      });
    }
  }

  // List<Map<String, dynamic>> convertToMapList(List<List<dynamic>> list) {
  //   if (list.isEmpty) {
  //     return [];
  //   }
  //
  //   var header = list[0].map((e) => e.toString()).toList();
  //   var data = list.sublist(1);
  //
  //   return data.map((row) {
  //     var map = <String, dynamic>{};
  //     for (var i = 0; i < header.length && i < row.length; i++) {
  //       map[header[i]] = row[i];
  //     }
  //     return map;
  //   }).toList();
  // }

  List<dynamic> extractColumn(List<List<dynamic>> rows, int columnIndex) {
    return rows.map((row) => row[columnIndex]).toList();
  }

  Widget buildWidgetDependingOnKey(String fieldKey) {
    print("field : $fieldKey");
    switch (fieldKey) {
      case 'viewText_1':
        return viewText_1();
      case 'list_1':
        return list_1();
      case 'viewText_2':
        return viewText_1();
      case 'image_1':
        return image_1();
      default:
        return const SizedBox
            .shrink(); // Return an empty container for unknown types
    }
  }

  Widget list_1() {
    selectedValue = columnData[0];
    return List1Dropdown(
      columnData: columnData,
      selectedValue: selectedValue,
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
      },
    );
  }

  Widget viewText_1() {
    print("calling viewText_1");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: columnData.isEmpty
          ? const Text("No data found")
          : SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: columnData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(columnData[index].toString()),
                  );
                },
              ),
            ),
    );
  }

  Widget image_1() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: columnData.isEmpty
          ? const Text("No data found")
          : SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: columnData.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      size: 20.0,
                      color: Colors.redAccent,
                    ),
                    fadeInCurve: Curves.bounceOut,
                    fadeInDuration: const Duration(seconds: 3),
                    imageUrl: columnData[index],
                    fit: BoxFit.fill,
                  );
                },
              ),
            ),
    );
  }

  Widget buildFormField(Field field) {
    switch (field.properties!.type) {
      case 'text':
        return buildTextField(field);
      case 'dropDownList':
        return buildDropdownList(field);
      case 'viewText':
        return buildViewText(field);
      case 'imageView':
        return buildImageView(field);
      case 'numberText':
        return buildNumberTextField(field);
      default:
        return const SizedBox
            .shrink(); // Return an empty container for unknown types
    }
  }

  Widget buildTextField(Field field) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: field.properties!.hintText,
          labelText: field.properties!.label,
        ),
        onChanged: (value) {
          formDataForStore[field.key.toString()] = value;
        },
      ),
    );
  }

  Widget buildDropdownList(Field field) {
    List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(
        json.decode(field.properties!.listItems.toString()));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        value: items[0]['value'], // Default value
        items: items
            .map<DropdownMenuItem<int>>((item) => DropdownMenuItem<int>(
                  value: item['value'],
                  child: Text(item['name']),
                ))
            .toList(),
        onChanged: (value) {
          formDataForStore[field.key.toString()] = value;
        },
        decoration: InputDecoration(
          hintText: field.properties!.hintText,
          labelText: field.properties!.label,
        ),
      ),
    );
  }

  Widget buildViewText(Field field) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        field.properties!.defaultValue,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildImageView(Field field) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.network(
        field.properties!.defaultValue,
        height: 100,
        width: 100,
      ),
    );
  }

  Widget buildNumberTextField(Field field) {
    final defaultValue =
        TextEditingController(text: field.properties!.defaultValue.toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: defaultValue,
        keyboardType: TextInputType.number,
        minLines: field.properties!.minLength,
        maxLength: field.properties!.maxLength,
        decoration: InputDecoration(
          hintText: field.properties!.hintText,
          labelText: field.properties!.label,
        ),
        onChanged: (value) {
          formDataForStore[field.key.toString()] = int.tryParse(value) ?? 0;
        },
      ),
    );
  }

  // Widget buildDisplayField(Map<String, dynamic> displayField, Map<String, dynamic> displayData) {
  //   switch (displayField['fieldKey']) {
  //     case 'viewText_1':
  //       return Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Text(
  //           displayData[displayField['dataColumn']] ?? '',
  //           style: TextStyle(fontSize: 16),
  //         ),
  //       );
  //     case 'viewText_2':
  //       return Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Text(
  //           displayData[displayField['dataColumn']] ?? '',
  //           style: TextStyle(fontSize: 16),
  //         ),
  //       );
  //     case 'image_1':
  //       return Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Image.network(
  //           displayData[displayField['dataColumn']] ?? '',
  //           height: 100,
  //           width: 100,
  //         ),
  //       );
  //     default:
  //       return const SizedBox
  //           .shrink(); // Return an empty container for unknown types
  //   }
  // }
}

class List1Dropdown extends StatefulWidget {
  final List<dynamic> columnData;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  List1Dropdown(
      {required this.columnData,
      required this.selectedValue,
      required this.onChanged});

  @override
  _List1DropdownState createState() => _List1DropdownState();
}

class _List1DropdownState extends State<List1Dropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        items: widget.columnData.map((item) {
          return DropdownMenuItem<String>(
            value: item.toString(),
            child: Text(item.toString()),
          );
        }).toList(),
        value: widget.selectedValue,
        onChanged: (value) {
          widget.onChanged(value!);
        },
      ),
    );
  }
}
