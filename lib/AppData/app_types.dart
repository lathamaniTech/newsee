/* 
define App's custom types here
 */
typedef RouteProps = Map<String, String>;

class MasterReqItem {
  final String id;
  final String masterfor;

  MasterReqItem({required this.masterfor, required this.id});
  Map<String, dynamic> toJson() {
    return {'masterfor': masterfor, 'id': id};
  }
}
