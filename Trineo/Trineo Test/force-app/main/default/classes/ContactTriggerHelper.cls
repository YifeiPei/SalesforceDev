/*
 * ContactTriggerHelper
 * Author: Yifei Pei
 * Date: 13/11/2019
 */

public class ContactTriggerHelper {
    
    // Constant definition
    private static final String AUSTRALIA = 'Australia';
    private static final String New_Zealand = 'New Zealand';
    
    /*
     * Method explanation: assign account Id to the proper contact record
     * Param: passed by Contact Trigger Trigger.new
     */
    public static void assignAccount (List<Contact> newContactList) {
        Id defaultAccountIdAU = getDefaultAccountIdAU();
        Id defaultAccountIdNZ = getDefaultAccountIdNZ();
        for (Contact c : newContactList) {
              if (c.AccountId == null || c.AccountId == ''){
                if (c.RecordtypeId == Schema.SObjectType.Contact.getRecordTypeInfosByName().get('New Zealand').getRecordTypeId()) {
                    c.AccountId = defaultAccountIdNZ;
                } else {
                    c.AccountId = defaultAccountIdAU;
                }
            }
        }
    }
    
    /*
     * Method: get "Australia" Account Id
     */
    private static Id getDefaultAccountIdAU(){
        return [SELECT Id FROM Account WHERE Name = :AUSTRALIA LIMIT 1].Id;
    }

    /*
     * Method: get "New Zealand" Account Id
     */
    private static Id getDefaultAccountIdNZ(){
        return [select Id from Account where Name = :New_Zealand limit 1].Id;
    }
}