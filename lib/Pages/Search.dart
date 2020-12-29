import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tubeleech/Bloc/videos_bloc.dart';
import 'package:tubeleech/Pages/list_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    getSuggest("top 20 şarkı");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This is handled by the search bar itself.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(child: Positioned.fill(top: 85, child: ListPage())),
          Positioned.fill(child: buildFloatingSearchBar()),
        ],
      ),
    );
  }

  List<String> suggest = [];
  FloatingSearchBarController controller=FloatingSearchBarController();
  Widget buildFloatingSearchBar() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return SizedBox(
      height: 100,
      child: FloatingSearchBar(
        controller: controller,
        hint: 'Ara...',
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        maxWidth: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        onSubmitted: (value) {
          setState(() {
            BlocProvider.of<VideosBloc>(context).add(FetchVideoEvent(searchQ: value));
            controller.close();
          });
        },

        onQueryChanged: (query)async{
          String url =
              "https://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=${query}&alt=json";
          http.Response response = await http.get(url,headers:  {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
          setState(() {
            suggest = [];
            for (var e in jsonDecode(HtmlUnescape().convert(response.body))[1]) {
              suggest.add(e[0]);
            }
          });
        },
        // Specify a custom transition to be used for
        // animating between opened and closed stated.
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.place),
              onPressed: () {},
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition) {

          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: suggest.isEmpty?SizedBox(
                height: 450.0,
                child: ListView.separated(
                    padding: const EdgeInsets.only(top: 20),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount:6,
                    itemBuilder: (BuildContext context, int index) {
                      return Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white70,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: 40.0,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      );
                  }
                ),
              ):SizedBox(
                height: 450,
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 20),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: suggest.length,
                  itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: (){
                      BlocProvider.of<VideosBloc>(context).add(FetchVideoEvent(searchQ: suggest[index]));
                      controller.close();
                    },
                    title:Text(suggest[index]),
                    trailing: IconButton(icon: Icon(Icons.create),onPressed: (){controller.query=suggest[index];},),
                  );
                },   ),
              ),
            ),
          );
        },
      ),
    );
  }

  getSuggest(String query) async {
    String url =
        "https://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=${query}&alt=json";
    http.Response response = await http.get(url,headers:  {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    setState(() {
      suggest = [];
      for (var e in jsonDecode(HtmlUnescape().convert(response.body))[1]) {
        suggest.add(e[0]);
      }
    });
  }
}
