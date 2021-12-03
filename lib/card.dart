import 'package:flutter/material.dart';
import 'datamodel.dart';
class card extends StatelessWidget
{
  const card({Key? key,required this.data,required this.edit,required this.index,required this.delete}) : super(key: key);
  final DataModel data;
  final Function edit;
  final int index;
  final Function delete;
  @override
  Widget build(BuildContext context) {
    return Card(
      child:ListTile(
        leading: CircleAvatar(
          child:IconButton( onPressed: ()
          {
            edit(index);
             }, icon:const Icon(Icons.edit),),
        ),
        title: Text(data.title),
        subtitle: Text(data.subtitle),
        trailing:  CircleAvatar(
          child:IconButton( onPressed: (){
            delete(index);
          }, icon:const Icon(Icons.delete),),
        ),
      ),
    );
  }
}
