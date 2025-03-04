
import 'package:flutter/material.dart';

import '../ConcretObjects/SearchElement.dart';


class CustomSearchBar extends StatefulWidget {
  final int fillColor;
  final int textColor;
  final double screenHeight;
  final double screenWidth;
  final List<SearchElement> searchList;
  final Function(double lat, double lng) moveTo;

  const CustomSearchBar({
    super.key,
    required this.fillColor,
    required this.textColor,
    required this.screenWidth,
    required this.screenHeight,
    required this.searchList,
    required this.moveTo,
  });

  @override
  State<StatefulWidget> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  TextEditingController searchController = TextEditingController();
  List<SearchElement> results = [];
  void searchElements(String searchedText) {
    setState(() {
      results = [];
      if (searchedText.isEmpty) {
        results = [];
      } else {
        for (var elem in widget.searchList) {
          if (elem.name.toLowerCase().contains(searchedText.toLowerCase())) {
            results.add(elem);
          }
        }
      }
    });
  }
  @override
  void initState() {
    super.initState();
    results = [];
  }
  @override
  Widget build(BuildContext context) {
    double barWidth = widget.screenWidth * 0.45;
    double barHeight = widget.screenHeight * 0.06;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: barWidth,
          height: barHeight,
          child:
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: .0,
                    ),
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                  filled: true,
                  fillColor: Color( widget.fillColor),
                  contentPadding: EdgeInsets.only(
                    top: barHeight * 0.03,
                    bottom: barHeight * 0.03,
                    left: barWidth * 0.03,
                    right: barWidth * 0.3,
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                  ),
                ),
                onChanged: searchElements,
              ),
        ),
        if(widget.searchList.isNotEmpty)
          Container(
            width: barWidth,
            constraints: BoxConstraints(
              maxHeight: widget.screenHeight*0.2,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: searchController.text.isNotEmpty? Border.all(color: Colors.grey.shade300) : null,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(results[index].name),
                  onTap: () {
                    searchController.text = results[index].name;
                    searchElements(results[index].name);
                    widget.moveTo(results[index].lat,results[index].lng);
                    setState(() {
                      results = [];
                    });
                  },
                );
              }
            ),
          )
      ],
    );
  }
}
