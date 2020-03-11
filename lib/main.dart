import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_app/pokemon.dart';
import 'package:http/http.dart' as http;
import 'package:gradient_widgets/gradient_widgets.dart';
import 'dart:convert';
import './pokedetail.dart';
import './sharedPrefs.dart';
import './my_flutter_app_icons.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  title: "Pokedex",
  home: HomePage(),
));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var url = "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  PokeHub pokeHub;
  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();

    fetchData();
    print("2nd work");
  }

  fetchData() async {
    var result =  await http.get(url);
    var decodedJson = jsonDecode(result.body);
    pokeHub = PokeHub.fromJson(decodedJson);
    setState(() {

    });
  }

  fetchFavData() async {
    //var result =  await http.get(url);
    //var decodedJson = jsonDecode(result.body);
    pokeHub = await sharedPref.read("favoritePokemons");
    setState(() {

    });
  }

  final typeColors = {
    "Normal": Colors.orange[100],
    "Fire": Colors.red[700],
    "Grass": Colors.green,
    "Poison": Colors.deepPurpleAccent,
    "Water": Colors.blue,
    "Electric": Colors.yellow,
    "Bug": Colors.lightGreen,
    "Flying": Colors.lightBlueAccent,
    "Ground": Colors.brown,
    "Fighting": Colors.deepOrangeAccent,
    "Ice": Colors.cyan,
    "Psychic": Colors.pinkAccent,
    "Rock": Colors.lime[900],
    "Dragon": Colors.cyan[200],
    "Steel": Colors.blueGrey,
    "Fairy": Colors.tealAccent,
    "Ghost": Colors.grey[300],
    "Dark": Colors.grey[800]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pokedex"),
        backgroundColor: Colors.amber,
      ),
      body: pokeHub == null ? Center(
        child: CircularProgressIndicator(),
      )
      : GridView.count(crossAxisCount: 2, children: pokeHub.pokemon.map((poke) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PokeDetail(
              pokemon: poke,
              typeColors: typeColors,
            )));
          },
          child: GradientCard(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight ,stops: [0.5, 0.5] ,colors: [typeColors[poke.type[0]], poke.type.length > 1 ? typeColors[poke.type[1]] : typeColors[poke.type[0]] ]),

            elevation: 3.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AdvancedNetworkImage(poke.img, retryLimit: 2, timeoutDuration: Duration(seconds: 10),))
                  ),
                ),
                Text(poke.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0, fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 5.0,
                    color: Colors.black,
                    offset: Offset(0.5, 0.5),)]
                ),)
              ],
            ),
          ),
        ),
      )).toList()),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 90,
              child: DrawerHeader(
                child: Text('Menu', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20, ),),
                decoration: BoxDecoration(
                  color: Colors.amber,

                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Pokeball.pokeball, color: Colors.amber, size: 45,),
                title: Text('Show all', style: TextStyle(fontSize: 18),),
                onTap: () {
                  fetchData();
                  Navigator.pop(context);
                },
              ),
            ),
            Card(
                child: ListTile(
                  leading: Icon(Icons.stars, color: Colors.amber, size: 45,),
                  title: Text('Favorite list', style: TextStyle(fontSize: 18),),
                  onTap: () {
                    fetchFavData();
                    Navigator.pop(context);
                  },
                )
            ),
          ],
        ),
      ),
    );
  }
}
