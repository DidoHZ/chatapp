import 'package:chatapp/core/Storage.dart';
import 'package:chatapp/logic/cubit/profile/profile_cubit.dart';
import 'package:chatapp/logic/fromSubmissionStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Future<void> rebuild () async {
    setState(() {});
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.cyan),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column( children: [
            BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if(state.status is SubmissionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profile image updated"),backgroundColor: Colors.greenAccent,)
                  );
                }else if(state.status is SubmissionFailed){
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profile image not updated"),backgroundColor: Colors.greenAccent,)
                  );
                }
              },
              builder: (context, state) {
                return FutureBuilder(
                    future: Storage.instance.getMyProfileImage(cache: state.loadFromCache),
                    builder: (context, AsyncSnapshot<Image> snapshot) {
                      return CircleAvatar(
                        radius: 70,
                        backgroundImage: snapshot.data?.image,
                        child: GestureDetector(
                            child: state.status is FormSubmitting
                                ? const CircularProgressIndicator()
                                : null,
                            onTap: () => state.status is FormSubmitting
                                ? null
                                : BlocProvider.of<ProfileCubit>(context)
                                    .uploadProfileImage()),
                      );
                    });
              },
            )
          ]),
        ),
      ),
    );
  }
}
