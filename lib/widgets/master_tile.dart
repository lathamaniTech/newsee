import 'package:flutter/material.dart';

class MasterTile extends StatelessWidget {
  final String label;
  final String type;
  final bool loading;
  final bool done;
  final VoidCallback onTap;

  const MasterTile({
    super.key,
    required this.label,
    required this.type,
    required this.loading,
    required this.done,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget trailing;
    if (loading) {
      trailing = const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (done) {
      trailing = const Icon(Icons.check_circle, color: Colors.green);
    } else {
      trailing = const Icon(Icons.cloud_download);
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: loading ? 1.03 : 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Card(
        elevation: 4,
        child: ListTile(title: Text(label), trailing: trailing, onTap: onTap),
      ),
    );
  }
}
