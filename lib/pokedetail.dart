import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pokemon.dart';
import './sharedPrefs.dart';


class PokeDetail extends StatefulWidget{
  final Pokemon pokemon;
  final typeColors;
  SharedPref sharedPref = SharedPref();


  PokeDetail({this.pokemon, this.typeColors});

  @override
  _PokeDetailState createState() => _PokeDetailState();

}

class _PokeDetailState extends State<PokeDetail> {
  var ic = {
    true: Icons.star,
    false: Icons.star_border,
    null: Icons.access_time
  };
  PokeHub favoritePokemons;
  var currentPokemon;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      loadFavorites();
      print("3rd work");
    });
  }
  loadFavorites() async {
    favoritePokemons = await widget.sharedPref.read("favoritePokemons");
    var favPokemon = favoritePokemons.pokemon.firstWhere((poke) => poke.name == widget.pokemon.name, orElse: () => null);
    currentPokemon = favPokemon == null ? false : true;
    print(currentPokemon);
    setState(() {

    });
  }
  bodyWidget(BuildContext context) => Stack(
    children: <Widget>[
      Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter ,stops: [0.5, 0.5],colors: [Colors.red, Colors.white])),),
      Positioned(
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width - 20,
        left: 10.0,
        top: MediaQuery.of(context).size.height * 0.1,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(15.0),
          ),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:<Widget>[
              SizedBox(
                height: 70.0,
              ),
              Text(widget.pokemon.name, style:TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold ),),
              Text("Height: ${widget.pokemon.height}"),
              Text("Weight: ${widget.pokemon.weight}"),
              //----------------------------------------------------------
              Text("Types",style:TextStyle(fontWeight: FontWeight.bold),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:widget.pokemon.type.map((t) =>
                    FilterChip( backgroundColor:widget.typeColors[t], label:Text(t, style: TextStyle(color: Colors.white),), onSelected:(b){})).toList(),
              ),
              //----------------------------------------------------------
              Text("Weakness", style:TextStyle(fontWeight: FontWeight.bold),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:widget.pokemon.weaknesses.map((t) =>
                    FilterChip( backgroundColor:widget.typeColors[t], label: Text(t, style: TextStyle(color: Colors.white),), onSelected:(b){})).toList(),
              ),
              //------------------------------------------------------------
              Text("Next Evolution", style: TextStyle(fontWeight: FontWeight.bold),),
              widget.pokemon.nextEvolution == null ? Text('Does not have evolution') : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.pokemon.nextEvolution.map((n) =>
                    FilterChip( backgroundColor:Colors.amber ,label: Text(n.name, style: TextStyle(color: Colors.white) ), onSelected:(b){})).toList(),
              ),
              //----------------------------------------------------------------
            ],
          ),
        ),
      ),
      Align(
        alignment:Alignment.topCenter,
        child: Hero(tag: widget.pokemon.img, child: Container(
          height:160.0,
          width:160.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit:BoxFit.cover, image: NetworkImage(widget.pokemon.img) )
          ),
        ),
        ),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: Text(widget.pokemon.name),
      ),
      body: bodyWidget(context),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.pokemon.isFavorite ? currentPokemon = false : currentPokemon = true;
          widget.pokemon.isFavorite ? widget.pokemon.isFavorite = false : widget.pokemon.isFavorite = true;
          widget.pokemon.isFavorite ? favoritePokemons.pokemon.add(widget.pokemon) : favoritePokemons.pokemon.removeWhere((item) => item.name == widget.pokemon.name);
          widget.sharedPref.save("favoritePokemons", favoritePokemons);
          setState(() {

          });
        },
        child: Icon(ic[currentPokemon]),
        backgroundColor: Colors.amber,
      ),
    );
  }
}