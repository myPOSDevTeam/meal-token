import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jkh_mealtoken/components/widgets/loading_widget.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,


      padding: EdgeInsets.symmetric(vertical: 10),
      child: CachedNetworkImage(
        placeholder: (context,_)=> LoadingWidget(),
        imageUrl: ''),

    );
  }
}