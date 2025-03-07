import 'package:flutter/material.dart';
import 'package:listify/constants/colors.dart';

Widget searchBox(void Function(String) onToDoChange) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: TextField(
      onChanged: onToDoChange,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(0),
        prefixIcon: Icon(
          Icons.search,
          color: tdBlack,
          size: 20,
        ),
        prefixIconConstraints: BoxConstraints(
          maxHeight: 20,
          minWidth: 25,
        ),
        border: InputBorder.none,
        hintText: "Search",
        hintStyle: TextStyle(
          color: tdGrey,
        ),
      ),
    ),
  );
}
