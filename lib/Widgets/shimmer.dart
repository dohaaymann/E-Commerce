import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
// return
// child:
// ),
Widget shimmer(var count) {
  return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
   crossAxisSpacing: 10,
    crossAxisCount: 2,
      mainAxisExtent:270,
     ),
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (BuildContext ctx, i) {
        return Column(
      children: [
        SkeletonAvatar(
          style: SkeletonAvatarStyle(
            width: double.infinity,
            height: 180,
            shape: BoxShape.rectangle,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
          ),
          padding: EdgeInsets.all(7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 20,
                  // width: MediaQuery.of(context).size.width * 0.6,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 18,
                    width: 80,
                    borderRadius: BorderRadius.circular(8),
                    // color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Align(alignment: Alignment.topRight,
                child: SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    width: 20,
                    height: 20,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );}
  );
}
