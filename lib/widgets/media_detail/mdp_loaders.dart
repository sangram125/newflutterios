import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class MDPBodyLoader extends StatelessWidget {
  const MDPBodyLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).highlightColor;
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SingleChildScrollView(
        child: SkeletonGridLoader(
          builder: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                color: color,
              )),
              const SizedBox(height: 10),
              Container(
                width: 100,
                height: 10,
                color: color,
              ),
              const SizedBox(height: 10),
              Container(
                width: 70,
                height: 10,
                color: color,
              ),
            ],
          ),
          items: 9,
          itemsPerRow: 3,
          period: const Duration(seconds: 2),
          highlightColor:
              Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          baseColor: Theme.of(context).highlightColor,
          direction: SkeletonDirection.ltr,
          childAspectRatio: 0.66,
        ),
      ),
    );
  }
}

class MDPHeaderLoader extends StatelessWidget {
  const MDPHeaderLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).highlightColor;
    return SkeletonLoader(
      builder: Container(
        height: 200,
        color: color,
      ),
      items: 1,
      period: const Duration(seconds: 2),
      highlightColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
      baseColor: color,
    );
  }
}

class MDPLoader extends StatelessWidget {
  const MDPLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MDPHeaderLoader(),
          SizedBox(height: 20),
          MDPBodyLoader(),
        ],
      ),
    );
  }
}
