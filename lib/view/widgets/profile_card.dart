import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/user_model.dart';
import '../../viewmodel/profile_viewmodel.dart';

class ProfileCard extends StatelessWidget {
  final UserModel user;
  const ProfileCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Scale values based on card width
        double cardWidth = constraints.maxWidth;
        double padding = cardWidth * 0.05; // 5% of width
        double nameFontSize = cardWidth * 0.12; // 12% of width
        double cityFontSize = cardWidth * 0.08; // 8% of width
        double iconSize = cardWidth * 0.12; // 12% of width
        double spacing = cardWidth * 0.02; // 2% of width

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cardWidth * 0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: cardWidth * 0.04,
                offset: Offset(0, cardWidth * 0.02),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(cardWidth * 0.1),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                Hero(
                  tag: '${user.imageUrl}-${user.name}',
                  child: Image.network(user.imageUrl, fit: BoxFit.cover),
                ),

                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: [0.5, 1.0],
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              user.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: nameFontSize,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(1, 1),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => viewModel.toggleLike(user),
                            child: Icon(
                              user.isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.white,
                              size: iconSize,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: spacing),
                      Text(
                        user.city,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: cityFontSize,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(1, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
