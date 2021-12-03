import 'package:flutter/material.dart';
import 'card.dart';
import 'databases.dart';
import 'datamodel.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      theme: ThemeData(
       primarySwatch: Colors.orange,
        primaryColor: Colors.orangeAccent,
      ),
      home: const MyHomePage(title: 'ToDo App'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  TextEditingController titleController  = TextEditingController();
  TextEditingController subtitleController  = TextEditingController();
  List <DataModel> datas =[];
  bool fetching = true;
  int currentIndex =0;
  late DataBase db;
  @override
  void initState()
  {
    super.initState();
    db= DataBase();
    getData();
}
void getData() async{
    datas=await db.getData();
    setState((){
    fetching = false;
    });
}
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

       centerTitle: true,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
        ()
        {
          showMyDialog();
        },
        tooltip: 'Make Your List',
        child: const Icon(Icons.add),
      ),
      body:fetching ?const Center(child:CircularProgressIndicator()):
      ListView.builder(
        itemCount: datas.length,
        itemBuilder: (context,index)=>card(data:datas[index],index:index,delete:delete, edit:edit,),

      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void showMyDialog() async{
    return showDialog(
        context: context,
        builder: (BuildContext context)
    {
      return AlertDialog(
        content: SizedBox(
        height:180,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText:"What Will You Do",hintText: "Example : Gym,Swimming...",),
              ),
              TextFormField(
                controller: subtitleController,
                decoration: const InputDecoration(labelText:"Time",hintText: "Example : at 10.30...."),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: ()
            {
              DataModel local = DataModel (title:titleController.text, subtitle: subtitleController.text);
              db.insertData(local);
              local.id=datas[datas.length-1].id!+1;
              setState(()
              {
                datas.add(local);
              });
              titleController.clear();
              subtitleController.clear();
              Navigator.pop(context);
            },
            child:Text("Save")
          )
        ],
      );
    });
  }

  void updateDialog() async{
    return showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            content: SizedBox(
              height:180,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText:"What Will You Do",hintText: "Example : Gym,Swimming...",),
                  ),
                  TextFormField(
                    controller: subtitleController,
                    decoration: const InputDecoration(labelText:"Time",hintText: "Example : at 10.30...."),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: ()
                  {
                    DataModel newData = datas[currentIndex];
                    newData.subtitle=subtitleController.text;
                    newData.title=titleController.text;
                    db.update(newData,newData.id!);
                    setState((){});
                    Navigator.pop(context);
                  },
                  child:const Text("Update")
              )
            ],
          );
        });
  }
  void edit(index)
  {
    currentIndex = index;
    titleController.text=datas[index].title;
    subtitleController.text=datas[index].subtitle;
   updateDialog();
  }
  void delete(index){
    db.delete(datas[index].id!);
    setState((){
    datas.removeAt(index);
    });
  }
}
