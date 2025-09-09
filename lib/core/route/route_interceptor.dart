import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/feature/leadInbox/lead_cache_service.dart';

/* 
@author   : karthick.d 04/06/2025
@desc     : helper class intercepts hardware backbutton action 
            and determines Navigation pop behavior implemented 
            in didPopRoute() functon

 */
class CustomBackButtonDispatcher extends RootBackButtonDispatcher {
  // router instance required to call pop and push pages
  final GoRouter _router;
  final BuildContext context;
  CustomBackButtonDispatcher(this.context, this._router);
  @override
  Future<bool> didPopRoute() async {
    // current route path is required to make Navigate.pop decision
    // get context referece from GorouterDelegate object
    final currentRoute = '/login';
    print(
      'CustomBackButtonDispatcher::didPopRoute => currentRoute $currentRoute',
    );
    if (currentRoute.contains('login')) {
      bool? confirm = await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Confirm Exit'),
              content: Text('Do you want to Exit App ?'),
              actions: [
                TextButton(
                  onPressed: () => _router.pop(false),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    await LeadCacheService.clearCache();
                    _router.pop(true);
                  },
                  child: Text('Yes'),
                ),
              ],
            ),
      );
      if (confirm == true) {
        _router.pop();
        return true;
      }
      return true;
    }
    return true;
  }
}
