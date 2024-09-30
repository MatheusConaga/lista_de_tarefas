import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class ListaTarefas extends StatefulWidget {
  const ListaTarefas({super.key});

  @override
  State<ListaTarefas> createState() => _ListaTarefasState();
}

class _ListaTarefasState extends State<ListaTarefas> {
  List _listaTarefas = [];
  TextEditingController _controllerTarefa = TextEditingController();
  Map<String, dynamic> _ultimaTarefaRemovida = {};

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  _salvarTarefa() {
    String textoDigitado = _controllerTarefa.text;
    Map<String, dynamic> tarefa = {};
    tarefa["titulo"] = textoDigitado;
    tarefa["realizada"] = false;

    setState(() {
      _listaTarefas.add(tarefa);
    });

    _salvarArquivo();
    _controllerTarefa.text = "";
  }

  _salvarArquivo() async {
    var arquivo = await _getFile();
    String dados = jsonEncode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _lerArquivo().then((dados) {
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });
  }


  Widget criarItemLista(context, index){

    // final item = _listaTarefas[index]["titulo"];

    return Dismissible(
        key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (direction){

          //Recuperar o ultimo item exluído
          _ultimaTarefaRemovida = _listaTarefas[index];

          _listaTarefas.removeAt(index);
          _salvarArquivo();

          final snackbar = SnackBar(
            backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
              content: Text("Tarefa removida"),
            action: SnackBarAction(
              textColor: Colors.white,
                label: "Desfazer",
                onPressed: (){

                setState(() {
                  _listaTarefas.insert(index, _ultimaTarefaRemovida);
                });
                  _salvarArquivo();
                }
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);

        },
        background: Container(
          color: Colors.red,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete, color: Colors.white,),
            ],
          ),
        ),
        child: CheckboxListTile(
            title: Text(
                _listaTarefas[index]["titulo"] ?? "Sem titulo"
            ),
            value: _listaTarefas[index]["realizada"],
            onChanged: (valorAlterado){
              setState(() {
                _listaTarefas[index]["realizada"] = valorAlterado;
              });
              _salvarArquivo();
            }
        )

    );

  }



  @override
  Widget build(BuildContext context) {
    print("Itens: " + DateTime.now().millisecondsSinceEpoch.toString());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Lista de tarefas",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Adicionar Tarefa"),
                  content: TextField(
                    controller: _controllerTarefa,
                    decoration: InputDecoration(
                      label: Text("Digite sua tarefa"),
                    ),
                    onChanged: (text) {},
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _salvarTarefa();
                        Navigator.pop(context);
                      },
                      child: Text("Salvar"),
                    ),
                  ],
                );
              },
            );
          }),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: _listaTarefas.length,
                  itemBuilder: criarItemLista,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
