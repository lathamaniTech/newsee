/* 
@author     : karthick.d   05/06/2025
@desc       : LoanproductEvent defines required event types by the LoanDetails Page
@params     : {}
 */
part of 'loanproduct_bloc.dart';

class LoanproductEvent {}

/* 
should be called when the loandetails page loaded at first
should loan dropdown controls with initial datasets - here Typeofloan dropdown
this event will also be called when setting data from the getLeadDetails Service

 */
class LoanproductInit extends LoanproductEvent {
  /*
    // need field to identify the lead status 
    case 1 : fresh lead
      freshlead don't have initial data so 
    case 2 : submitted lead
      leadId is available then it's a submittedLead 
      initial data will be provided , so need to set the state
    */

  final LoanproductState loanproductState;
  LoanproductInit({required this.loanproductState});
}

/* 
event for listening dropdown change 
 */
class LoanProductDropdownChange extends LoanproductEvent {}
