trigger ContactTrigger on Contact (before insert, after insert, before update, after update, before delete, after delete) {
    
    /*
     * Problem with the code: 
     * 1. isafter trigger cannot update the record itself
     * 2. Only the object's base fields are loaded from the database in triggers. Contact.recordtype.developername
     *    has info with related object which cannot be loaded in Trigger
     * 3. SOQL inside for loop which may cause too many SOQL 101 error
     * 4. the execution of the intended should be put in another Trigger Helper class for best practice
     */

    if(Trigger.isbefore){
        if((trigger.isInsert || Trigger.isUpdate) && Trigger.isbefore){
            // Execution explanation:
            // If Contact record type is "Australia", assign the record to "Australia" Account
            // If Contact record type is "New Zealand", assign the record to "New Zealand" Account
            ContactTriggerHelper.assignAccount(trigger.new);
        }
    }
}