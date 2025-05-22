/* 

encapsulate functionalites for 

0. init - LeadInit

1.showing loadig when lead save button is clicked - loading event

2.after 10s dismiss loading - success | failure 

3.return a new lead object with id as response // LeadData

4. show completed icon in the tab bar // 

 */

part of 'savelead_sourcing_bloc.dart';

sealed class SaveLeadSourcingEvent {}

/* 

@desc     :  define the initial Sourcingdetails object 
             set the LeadStatus to init 

 */

final class SaveleadSourcingSave extends SaveLeadSourcingEvent {}
