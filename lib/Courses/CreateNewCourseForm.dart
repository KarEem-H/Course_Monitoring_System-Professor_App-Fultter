import 'package:flutter/material.dart';
import 'Course.dart';
import 'Major.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  var course = new Course();
  // ----------------------------------------------------------
  File image ;
String URL="";

pickGallery() async{

      File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    // File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if(img != null){
      //image = img;
      setState(() {
       image = img;
       // filename = basename(image.path);
      });
    }
  }
  pickCamera() async{

    //  File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
      if(img != null){
      //image = img;
      setState(() => image = img);
    }
  }
  
Future uploadPic() async{
    
  final String filename = basename(image.path);
  final FirebaseStorage storage =FirebaseStorage(storageBucket: 'gs://coursati.appspot.com/');
  // StorageReference reference = FirebaseStorage.instance.ref().child(filename);  
  StorageReference reference = storage.ref()./*child('giftShopItems').*/child(filename);
  StorageUploadTask upload = reference.putFile(image);

  var downurl = await (await upload.onComplete).ref.getDownloadURL();
  setState(() {
    this.URL = downurl.toString();
    print(this.URL);
    print(filename);
  });   
}

  // ====================== DropdownMenuItem =========================
  List<Major> _majors = Major.getMajors();
  List<DropdownMenuItem<Major>> _dropdownMenuItems;
  Major _selectedMajor;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_majors);
    _selectedMajor = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Major>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Major>> items = List();
    for (Major major in companies) {
      items.add(
        DropdownMenuItem(
          value: major,
          child: Text(major.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Major selectedMajor) {
    setState(() {
      _selectedMajor = selectedMajor;
    });
  }
  // ===============================================

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.title),
              hintText: 'a new courses title',
              labelText: 'Title  *',
            ),
            onSaved: (String value) {
              // This optional block of code can be used to run
              // code when the user saves the form.
            },
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter Title';
              }
              return value.contains('@') ? 'Do not use the @ char.' : null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.description),
              hintText: 'a courses description',
              labelText: 'Description *',
            ),
            onSaved: (String value) {
              // This optional block of code can be used to run
              // code when the user saves the form.
            },
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter a courses description';
              }
              return value.contains('@') ? 'Do not use the @ char.' : null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.timelapse),
              hintText: 'a courses Hours',
              labelText: 'Hours *',
            ),
            keyboardType: TextInputType.number,
            onSaved: (String value) {
              // This optional block of code can be used to run
              // code when the user saves the form.
            },
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter a courses description';
              }
              return value.contains('@') ? 'Do not use the @ char.' : null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.people),
              hintText: 'a  limited number of students',
              labelText: 'Limited number of students *',
            ),
            keyboardType: TextInputType.number,
            onSaved: (String value) {
              // This optional block of code can be used to run
              // code when the user saves the form.
            },
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter a limited number of students';
              }
              return value.contains('@') ? 'Do not use the @ char.' : null;
            },
          ),
//------------------------------------------
          Card(
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Select Major'),
                        ),
                        Spacer(),
                        DropdownButton(
                          value: _selectedMajor,
                          items: _dropdownMenuItems,
                          onChanged: onChangeDropdownItem,
                        ),
                        Spacer(),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text('${_selectedMajor.name}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // --------------------------------------
          RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    'Pick From Gallery',
                    style: TextStyle(color: Colors.white)
                    ),
                  onPressed: pickGallery(),
                ),
                RaisedButton(
                  color: Colors.red,
                  child: Text(
                    'Pick From Camera',
                    style: TextStyle(color: Colors.white)
                    ),
                  onPressed: pickCamera(),
                ),
          // ----------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
