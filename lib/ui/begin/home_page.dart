// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:expansion/ui/begin/bloc/begin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BeginPage extends StatefulWidget {
  const BeginPage({Key? key}) : super(key: key);

  @override
  State<BeginPage> createState() => _BeginPageState();
}

class _BeginPageState extends State<BeginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const PreferredSize(
      //   preferredSize: Size.fromHeight(60.0),
      //   child: AppBarWithIcon(),
      // ),
      body:
          BlocConsumer<BeginBloc, BeginState>(listener: (context, state) async {
        // if (state is SuccessHome) {
        //   Navigator.of(context).push(MaterialPageRoute(
        //       builder: (BuildContext context) => BlocProvider(
        //             create: (_) => ProjectBloc(),
        //             child: const ProjectPage(),
        //           )));
        // }
      }, builder: (context, state) {
        return Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/splash.png',
                fit: BoxFit
                    .fill, // I thought this would fill up my Container but it doesn't
              ),
            ),

            // Center(
            //   child: state.isLoading
            //       ? const CircularProgressIndicator()
            //       : const SizedBox.shrink(),
            // ),
          ],
        );
      }),
    );
  }
}
