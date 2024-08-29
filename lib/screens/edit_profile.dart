import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapplication/models/ChatUser.dart';
import 'package:chatapplication/utils/firebase_instances.dart';
import 'package:chatapplication/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key, required this.currentUser});
  ChatUser currentUser;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController = TextEditingController();

  TextEditingController _aboutController = TextEditingController();

  bool _loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.currentUser.name ?? 'Null Name';
    _aboutController.text = widget.currentUser.about ?? 'Null About';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _aboutController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(width / 2),
                child: CachedNetworkImage(
                  height: width * .4,
                  width: width * .4,
                  fit: BoxFit.fill,
                  imageUrl: widget.currentUser.image ??
                      'https://cdn-icons-png.flaticon.com/128/149/149071.png',
                  placeholder: (context, url) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Icon(CupertinoIcons.person);
                  },
                ),
              ),
              SizedBox(height: height * .025),
              Text(widget.currentUser.email ?? 'noemail@gmail.com'),
              SizedBox(height: height * .025),
              TextField(
                decoration: InputDecoration(
                  label: Text('Name'),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                controller: _nameController,
              ),
              SizedBox(height: height * .025),
              TextField(
                decoration: InputDecoration(
                  label: Text('About'),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.info),
                ),
                controller: _aboutController,
              ),
              SizedBox(height: height * .025),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  await FirebaseInstances.firestore
                      .collection('users')
                      .doc(widget.currentUser.id)
                      .update(
                    {
                      'name': _nameController.text,
                      'about': _aboutController.text,
                    },
                  ).then((e) {
                    setState(() {
                      _loading = false;
                    });
                    Utils.showSnackBar(context, 'Profile Updated Successfully');
                    Navigator.pop(context);
                  }).catchError((e) {
                    setState(() {
                      _loading = false;
                    });
                    Utils.showSnackBar(context, 'An Error Occurred');
                  });
                },
                child: _loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.edit),
                            SizedBox(
                              width: width * .025,
                            ),
                            Text('Update'),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
