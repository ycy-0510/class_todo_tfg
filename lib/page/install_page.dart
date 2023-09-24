import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum OS { android, iOS, other }

class InstallPage extends ConsumerWidget {
  const InstallPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('安裝共享聯絡簿'),
      ),
      body: Center(
        child: Builder(builder: (context) {
          OS os = getOSInsideWeb();
          if (os == OS.iOS) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox()),
                Image.asset(
                  'assets/img/logo.png',
                  width: 100,
                  height: 100,
                ),
                const Text(
                  '共享聯絡簿',
                  style: TextStyle(fontSize: 18),
                ),
                const Expanded(child: SizedBox()),
                const Wrap(
                  children: [
                    Text(
                      '按下下方',
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(
                      Icons.ios_share,
                      color: Colors.blue,
                    ),
                    Text(
                      '按鈕並加入主畫面',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_downward,
                  size: 50,
                )
              ],
            );
          } else if (os == OS.android) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  children: [
                    Expanded(child: SizedBox()),
                    Wrap(
                      children: [
                        Text(
                          '按下右上角',
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(
                          Icons.more_vert,
                        ),
                        Text(
                          '按鈕並安裝',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_outward,
                      size: 50,
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Image.asset(
                  'assets/img/logo.png',
                  width: 100,
                  height: 100,
                ),
                const Text(
                  '共享聯絡簿',
                  style: TextStyle(fontSize: 18),
                ),
                const Expanded(child: SizedBox()),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox()),
                Image.asset(
                  'assets/img/logo.png',
                  width: 100,
                  height: 100,
                ),
                const Text(
                  '共享聯絡簿',
                  style: TextStyle(fontSize: 18),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '這部裝置看似不需安裝！',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text(
                      '開始使用',
                      style: TextStyle(fontSize: 18),
                    )),
                const Expanded(child: SizedBox()),
              ],
            );
          }
        }),
      ),
    );
  }

  OS getOSInsideWeb() {
    final userAgent = window.navigator.userAgent.toString().toLowerCase();
    if (userAgent.contains("iphone")) return OS.iOS;
    if (userAgent.contains("ipad")) return OS.iOS;
    if (userAgent.contains("android")) return OS.android;
    return OS.other;
  }
}
