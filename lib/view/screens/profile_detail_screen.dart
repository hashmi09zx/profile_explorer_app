import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/user_model.dart';
import '../../viewmodel/profile_viewmodel.dart';

class ProfileDetailScreen extends StatelessWidget {
  final UserModel user;
  const ProfileDetailScreen({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    final size = MediaQuery.of(context).size;

    // Relative sizing
    final topPadding = size.height * 0.03;
    final horizontalPadding = size.width * 0.05;
    final handleWidth = size.width * 0.15;
    final dipWidth = size.width * 0.15;
    final dipDepth = size.height * 0.009;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Full-screen image
            Positioned.fill(
              child: Hero(
                tag: '${user.imageUrl}-${user.name}',
                child: Image.network(user.imageUrl, fit: BoxFit.cover),
              ),
            ),

            // Top buttons
            Positioned(
              top: topPadding,
              left: horizontalPadding,
              right: horizontalPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: size.width * 0.07,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: size.width * 0.07,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Bottom info section
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipPath(
                    clipper: SharpDipClipper(
                      dipWidth: dipWidth,
                      dipDepth: dipDepth,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(size.width * 0.08),
                          topRight: Radius.circular(size.width * 0.08),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.05,
                          left: horizontalPadding,
                          right: horizontalPadding,
                          bottom: size.height * 0.03,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${user.name}, ${user.age}",
                                    style: TextStyle(
                                      fontSize: size.width * 0.07,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.015),
                                  Text(
                                    "Location",
                                    style: TextStyle(
                                      fontSize: size.width * 0.035,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.005),
                                  Text(
                                    "${user.city}, ${user.country}",
                                    style: TextStyle(
                                      fontSize: size.width * 0.035,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            AnimatedHeart(
                              isLiked: user.isLiked,
                              onTap: () => viewModel.toggleLike(user),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Handle bar
                  Positioned(
                    top: -6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: handleWidth,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sharp dip clipper that adapts to screen size
class SharpDipClipper extends CustomClipper<Path> {
  final double dipWidth;
  final double dipDepth;

  SharpDipClipper({required this.dipWidth, required this.dipDepth});

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 24);
    path.quadraticBezierTo(0, 0, 24, 0);

    final double startX = (size.width - dipWidth) / 2;

    path.lineTo(startX - 15, 0);
    path.lineTo(startX, dipDepth);
    path.lineTo(startX + dipWidth, dipDepth);
    path.lineTo(startX + dipWidth + 15, 0);

    path.lineTo(size.width - 24, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 24);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class AnimatedHeart extends StatefulWidget {
  final bool isLiked;
  final VoidCallback onTap;

  const AnimatedHeart({required this.isLiked, required this.onTap, super.key});

  @override
  _AnimatedHeartState createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant AnimatedHeart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLiked && !oldWidget.isLiked) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: Icon(
            widget.isLiked ? Icons.favorite : Icons.favorite_border,
            color: widget.isLiked ? Colors.red : Colors.black54,
            size: MediaQuery.of(context).size.width * 0.08,
          ),
        ),
      ),
    );
  }
}
