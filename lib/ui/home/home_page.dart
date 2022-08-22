// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/ui/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: BlocConsumer<HomeBloc, HomeState>(listener: (context, state) async {
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
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              height: double.infinity,
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
