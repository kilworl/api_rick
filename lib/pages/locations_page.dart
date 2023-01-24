import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_graphlq/main.dart';
import 'package:rick_graphlq/pages/characters_page.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  List<dynamic> locations = [];
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: _loading
          ? const CircularProgressIndicator()
          : locations.isEmpty
              ? Center(
                  child: ElevatedButton(
                    child: const Text("ver ubicaciones"),
                    onPressed: () {
                      locationsData();
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                              title: Text(
                                locations[index]['name'],
                              ),
                              subtitle: Text(
                                locations[index]['dimension'],
                              )),
                        );
                      }),
                ),
    );
  }

  void locationsData() async {
    setState(() {
      _loading = true;
    });
    HttpLink link = HttpLink("https://rickandmortyapi.com/graphql");
    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );
    QueryResult queryResult = await qlClient.query(
      QueryOptions(
        document: gql(
          """query {
    locations(){
      results{
        name
        dimension
      
      }
    }
  
}""",
        ),
      ),
    );

    setState(() {
      locations = queryResult.data!['locations']['results'];
      _loading = false;
    });
  }
}
