import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingSkeleton extends StatelessWidget {
  final bool isPost;
  final bool isCarSearch; t
  final bool? isNotification;

  const LoadingSkeleton({
    Key? key,
    required this.isPost,
    required this.isCarSearch,
    this.isNotification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (isPost)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Section
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 120,
                              height: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Post Content
                        Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),

                        // Post Text
                        Container(
                          width: 150,
                          height: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  );
                },
              )
            else if (isCarSearch)
            // Car Search Result Design
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      children: [
                        // Car Image Placeholder
                        Container(
                          width: 100,
                          height: 60,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 200,
                                height: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 150,
                                height: 16,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            else if (isNotification ?? false)
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            // Notification Icon Placeholder
                            Container(
                              width: 40,
                              height: 40,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 180,
                                    height: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: 120,
                                    height: 16,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )

              else
              // Simple List Design
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 200,
                                  height: 16,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
