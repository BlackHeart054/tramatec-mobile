import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tramatec_app/custom_widgets/version.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground({super.key, required this.backgroundColor});

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Container(
            color: Color(0xFF131A2C),
            child: SvgPicture.asset(
              'assets/images/background.svg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class BackgroundTemplate extends StatelessWidget {
  final Widget child;
  final bool showLogo;
  final bool showVersion;
  final Color? backgroundColor;

  const BackgroundTemplate({
    super.key,
    required this.child,
    this.showLogo = true,
    this.showVersion = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: Navigator.of(context).canPop(),
      child: Stack(
        children: [
          Positioned.fill(
              child: CustomBackground(
            backgroundColor: theme.primaryColor,
          )),
          Column(
            children: [
              if (showLogo)
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Image.asset(
                    'assets/images/tramatec_logo_text.png',
                    height: 120,
                    width: 250,
                  ),
                ),
              Expanded(
                child: Center(child: child),
              ),
              if (showLogo || showVersion)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _Footer(showLogo: showLogo, showVersion: showVersion),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final bool showLogo;
  final bool showVersion;

  const _Footer({required this.showLogo, required this.showVersion});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      fit: StackFit.loose,
      children: [
        if (showLogo)
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/white_logo.png',
                      height: 80,
                    ),
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('powered by',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: theme.textTheme.labelSmall?.color)),
                            Text(
                              ' Creative Inc.',
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.textTheme.labelSmall?.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (showVersion)
                          const Positioned(
                              right: 0, bottom: 0, child: VersionWidget()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
