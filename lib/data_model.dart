// To parse this JSON data, do
//
//     final formData = formDataFromJson(jsonString);

import 'dart:convert';

FormData formDataFromJson(String str) => FormData.fromJson(json.decode(str));

String formDataToJson(FormData data) => json.encode(data.toJson());

class FormData {
  String? formName;
  List<Section>? sections;
  List<ValueMapping>? valueMapping;

  FormData({
    this.formName,
    this.sections,
    this.valueMapping,
  });

  FormData copyWith({
    String? formName,
    List<Section>? sections,
    List<ValueMapping>? valueMapping,
  }) =>
      FormData(
        formName: formName ?? this.formName,
        sections: sections ?? this.sections,
        valueMapping: valueMapping ?? this.valueMapping,
      );

  factory FormData.fromJson(Map<String, dynamic> json) => FormData(
        formName: json["formName"],
        sections: json["sections"] == null
            ? []
            : List<Section>.from(
                json["sections"]!.map((x) => Section.fromJson(x))),
        valueMapping: json["valueMapping"] == null
            ? []
            : List<ValueMapping>.from(
                json["valueMapping"]!.map((x) => ValueMapping.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "formName": formName,
        "sections": sections == null
            ? []
            : List<dynamic>.from(sections!.map((x) => x.toJson())),
        "valueMapping": valueMapping == null
            ? []
            : List<dynamic>.from(valueMapping!.map((x) => x.toJson())),
      };
}

class Section {
  String? name;
  String? key;
  List<Field>? fields;

  Section({
    this.name,
    this.key,
    this.fields,
  });

  Section copyWith({
    String? name,
    String? key,
    List<Field>? fields,
  }) =>
      Section(
        name: name ?? this.name,
        key: key ?? this.key,
        fields: fields ?? this.fields,
      );

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        name: json["name"],
        key: json["key"],
        fields: json["fields"] == null
            ? []
            : List<Field>.from(json["fields"]!.map((x) => Field.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "key": key,
        "fields": fields == null
            ? []
            : List<dynamic>.from(fields!.map((x) => x.toJson())),
      };
}

class Field {
  int? id;
  String? key;
  Properties? properties;

  Field({
    this.id,
    this.key,
    this.properties,
  });

  Field copyWith({
    int? id,
    String? key,
    Properties? properties,
  }) =>
      Field(
        id: id ?? this.id,
        key: key ?? this.key,
        properties: properties ?? this.properties,
      );

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        id: json["id"],
        key: json["key"],
        properties: json["properties"] == null
            ? null
            : Properties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "properties": properties?.toJson(),
      };
}

class Properties {
  String? type;
  dynamic defaultValue;
  String? hintText;
  int? minLength;
  int? maxLength;
  String? label;
  String? listItems;

  Properties({
    this.type,
    this.defaultValue,
    this.hintText,
    this.minLength,
    this.maxLength,
    this.label,
    this.listItems,
  });

  Properties copyWith({
    String? type,
    dynamic defaultValue,
    String? hintText,
    int? minLength,
    int? maxLength,
    String? label,
    String? listItems,
  }) =>
      Properties(
        type: type ?? this.type,
        defaultValue: defaultValue ?? this.defaultValue,
        hintText: hintText ?? this.hintText,
        minLength: minLength ?? this.minLength,
        maxLength: maxLength ?? this.maxLength,
        label: label ?? this.label,
        listItems: listItems ?? this.listItems,
      );

  factory Properties.fromJson(Map<String, dynamic> json) {

    final dynamic listItemsStr = json['listItems'];
    final String listItemsResult = listItemsStr ?? '';

    final dynamic hintTextStr = json['hintText'];
    final String hintTextResult = hintTextStr ?? '';

    return Properties(
      type: json["type"],
      defaultValue: json["defaultValue"],
      hintText: hintTextResult,
      minLength: json["minLength"],
      maxLength: json["maxLength"],
      label: json["label"],
      listItems: listItemsResult,
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "defaultValue": defaultValue,
        "hintText": hintText,
        "minLength": minLength,
        "maxLength": maxLength,
        "label": label,
        "listItems": listItems,
      };
}

class ValueMapping {
  List<DisplayListElement>? searchList;
  List<DisplayListElement>? displayList;

  ValueMapping({
    this.searchList,
    this.displayList,
  });

  ValueMapping copyWith({
    List<DisplayListElement>? searchList,
    List<DisplayListElement>? displayList,
  }) =>
      ValueMapping(
        searchList: searchList ?? this.searchList,
        displayList: displayList ?? this.displayList,
      );

  factory ValueMapping.fromJson(Map<String, dynamic> json) => ValueMapping(
        searchList: json["searchList"] == null
            ? []
            : List<DisplayListElement>.from(
                json["searchList"]!.map((x) => DisplayListElement.fromJson(x))),
        displayList: json["displayList"] == null
            ? []
            : List<DisplayListElement>.from(json["displayList"]!
                .map((x) => DisplayListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "searchList": searchList == null
            ? []
            : List<dynamic>.from(searchList!.map((x) => x.toJson())),
        "displayList": displayList == null
            ? []
            : List<dynamic>.from(displayList!.map((x) => x.toJson())),
      };
}

class DisplayListElement {
  String? fieldKey;
  String? dataColumn;

  DisplayListElement({
    this.fieldKey,
    this.dataColumn,
  });

  DisplayListElement copyWith({
    String? fieldKey,
    String? dataColumn,
  }) =>
      DisplayListElement(
        fieldKey: fieldKey ?? this.fieldKey,
        dataColumn: dataColumn ?? this.dataColumn,
      );

  factory DisplayListElement.fromJson(Map<String, dynamic> json) =>
      DisplayListElement(
        fieldKey: json["fieldKey"],
        dataColumn: json["dataColumn"],
      );

  Map<String, dynamic> toJson() => {
        "fieldKey": fieldKey,
        "dataColumn": dataColumn,
      };
}
