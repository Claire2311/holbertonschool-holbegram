import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../widgets/text_field.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    searchPosts('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> searchPosts(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .get();

      List<DocumentSnapshot> filteredResults;

      if (query.isEmpty) {
        filteredResults = querySnapshot.docs.toList();
      } else {
        filteredResults = querySnapshot.docs.where((doc) {
          var data = doc.data() as Map<String, dynamic>;
          String caption = data['caption'].toString().toLowerCase();
          return caption.contains(query.toLowerCase());
        }).toList();
      }

      setState(() {
        searchResults = filteredResults;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/logo.webp'),
        title: Text(
          "Search",
          style: TextStyle(fontFamily: "Billabong", fontSize: 40),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: [
            TextFieldInput(
              controller: _searchController,
              ispassword: false,
              hintText: 'Search',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => searchPosts(_searchController.text),
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? CircularProgressIndicator()
                  : MasonryGridView.builder(
                      itemCount: searchResults.length,
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                      itemBuilder: (context, index) {
                        var data =
                            searchResults[index].data() as Map<String, dynamic>;
                        return Padding(
                          padding: EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(data['postUrl']),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
