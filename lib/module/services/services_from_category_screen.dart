import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_products/constance/component.dart';
import 'package:sky_products/constance/constants.dart';
import 'package:sky_products/model/category_model.dart';
import 'package:sky_products/shared/app_cubit/cubit.dart';
import 'package:sky_products/shared/app_cubit/states.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicesByCategoryScreen extends StatelessWidget {
  final CategoryModel categoryModel;

  const ServicesByCategoryScreen({required this.categoryModel, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: customAppBar(title:lang=='ar'?categoryModel.titleAr.toString():categoryModel.titleEn.toString()),
          body: getData(categoryModel.idCategory.toString(),context),
          // body: Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: GridView.builder(
          //     physics: const ScrollPhysics(),
          //     shrinkWrap: true,
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //         //  childAspectRatio: 2 / 2.4,
          //         crossAxisSpacing: 10,
          //         mainAxisSpacing: 10,
          //         crossAxisCount: 4,
          //         mainAxisExtent: 115),
          //     itemBuilder: (context, index) {
          //       return buildServicesItems(
          //           context, AppCubit.get(context).servicesModel[index]);
          //     },
          //     itemCount: AppCubit.get(context).servicesModel.length,
          //   ),
          // ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget getData(String idCategory,context) {
    return FirestorePagination(
      initialLoader: const Center(child: CircularProgressIndicator()),
      padding: const EdgeInsets.all(16.0),
      bottomLoader: const Center(child: CircularProgressIndicator()),
      limit: 50,
      // Defaults to 10.
      viewType: ViewType.grid,
      onEmpty: Center(
        child: noData(context),
      ),
      query: FirebaseFirestore.instance
          .collection('services')
          .orderBy('date',descending: true)
          .where('idCategory', isEqualTo: idCategory),
      itemBuilder: (context, documentSnapshot, index) {
        final data = documentSnapshot.data() as Map<String, dynamic>?;
        print(data!.length);
        //  if (data == null) return Container();

        return InkWell(
          onTap: () {
            launchUrl(Uri.parse(data['urlServices'].toString()));
          },
          child: Container(
            color: Colors.grey.withOpacity(0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  height: 80.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: data['imageServices'].toString(),
                  // placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fadeOutDuration: const Duration(seconds: 1),
                  fadeInDuration: const Duration(seconds: 2),
                ),
                Center(
                  child: Text(
                    lang=='ar'? data['titleServicesAr'].toString():  data['titleServicesEn'].toString(),
                    style: const TextStyle(
                      fontSize: 12.0, fontWeight: FontWeight.w500),maxLines: 2,overflow: TextOverflow.ellipsis,),
                  ),
              ],
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          mainAxisExtent: 120),
    );
  }
}
