import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_graphlq/main.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  List<dynamic> characters = [];
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
          : characters.isEmpty
              ? Center(
                  child: ElevatedButton(
                    child: const Text("ver personajes"),
                    onPressed: () {
                      fetchData();
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                              leading: Image(
                                image: NetworkImage(
                                  characters[index]['image'],
                                ),
                              ),
                              title: Text(
                                characters[index]['name'],
                              ),
                              subtitle: Text(
                                characters[index]['status'],
                              )),
                        );
                      }),
                ),
    );
  }

  void fetchData() async {
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
  characters() {
    results {
      name
      image 
      status
    }
  }
  
}""",
        ),
      ),
    );

    setState(() {
      characters = queryResult.data!['characters']['results'];

      _loading = false;
    });
  }
}
