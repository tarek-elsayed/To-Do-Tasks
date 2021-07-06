import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/shared/cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  double radius = 0.0,
  bool isUpperCase = true,
  @required String text,
  @required Function function,
}) {
  return Container(
    height: 40.0,
    width: width,
    child: MaterialButton(
      onPressed: function,
      child: Text(
        isUpperCase ? text.toUpperCase() : text,
        style: TextStyle(color: Colors.white),
      ),
    ),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(
        radius,
      ),
    ),
  );
}

Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  @required Function validation,
  @required String labelText,
  @required IconData prefix,
  Function onTap,
  IconData suffixIcon,
  bool obscureText = false,
  Function suffixIconPress,
  bool isClickable = true,
}) =>
    TextFormField(
      enabled: isClickable,
      validator: validation,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon:
            IconButton(icon: Icon(suffixIcon), onPressed: suffixIconPress),
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      keyboardType: type,
      obscureText: obscureText,
      onTap: onTap,
    );

Widget buildTaskItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child:Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 38.0,
              child: Text(
                "${model['time']}",
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model['title']}",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${model['date']}",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(status: "done", id: model['id']);
              },
              icon: Icon(
                Icons.check_box,
                color: Colors.blue,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: "archive", id: model['id']);
              },
              icon: Icon(
                Icons.archive_outlined,
                color: Colors.black45,
              ),
            )
          ],
        ),
      ),
   onDismissed: (direction){
     AppCubit.get(context).deleteData(id: model['id']);
   },
);


Widget tasksBuilder({
  @required List<Map> tasks,
})=>ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) =>
        buildTaskItem(tasks[index], context),
    separatorBuilder: (context, index) => Divider(
      height: 1.0,
      color: Colors.amber,
      thickness: 2.0,
    ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 80.0,
          color: Colors.black45,
        ),
        Text(
          "No Tasks Yet, Please Add Some Tasks ",
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500
          ),
        ),
      ],
    ),
  ),
);



Widget buildArticleItem()=>Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(
                'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: Container(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '2021-07-07T11:22:00Z',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      )
    ],
  ),
);

Widget myDivider()=>Divider(
  height: 1.0,
  color: Colors.amber,
  thickness: 2.0,
);