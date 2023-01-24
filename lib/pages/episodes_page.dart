import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_graphlq/main.dart';
import 'package:rick_graphlq/pages/characters_page.dart';

class EpisodesPage extends StatefulWidget {
  const EpisodesPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<EpisodesPage> createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  List<dynamic> episodes = [];
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
          : episodes.isEmpty
              ? Center(
                  child: ElevatedButton(
                    child: const Text("ver episodios"),
                    onPressed: () {
                      episodesData();
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: episodes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                              title: Text(
                                episodes[index]['name'],
                              ),
                              subtitle: Text(
                                episodes[index]['episode'],
                              )),
                        );
                      }),
                ),
    );
  }

  void episodesData() async {
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
    episodes(){
      results{
        name
        episode
      }
    }
  
}""",
        ),
      ),
    );

    setState(() {
      episodes = queryResult.data!['episodes']['results'];
      _loading = false;
    });
  }
}
