import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
            "Floating Action Button",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Text("Conteudo"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        // shape: BeveledRectangleBorder(
        //   borderRadius: BorderRadius.circular(10),
        // ),
          icon: Icon(Icons.add_shopping_cart),
          label: Text("Adicionar"),
          // child: Icon(Icons.add,),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          // mini: true,
          onPressed: (){
            print("Botao pressionado!");
      }
      ),
      bottomNavigationBar: BottomAppBar(
        // shape: CircularNotchedRectangle(),
        
        child: Row(
          children: [
            IconButton(
                onPressed: (){

                },
                icon: Icon(Icons.menu)
            ),
          ],
        ),
        
      ),
    );
  }
}
