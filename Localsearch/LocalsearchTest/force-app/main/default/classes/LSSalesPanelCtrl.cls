public with sharing class LSSalesPanelCtrl {
    public LSSalesPanelCtrl() {

    }

    @AuraEnabled(cacheable = true)
    public static List<LSSalesPanelHelper.salesInfo> getData(){
        List<LSSalesPanelHelper.salesInfo> response = new List<LSSalesPanelHelper.salesInfo> ();
        try {
            response = LSSalesPanelHelper.getRecords();
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage() + ' ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        return response;
    }

    @AuraEnabled
    public static string convertLeads(String LeadIds){
        System.debug('Parameter LeadIds: ' + LeadIds);
        List<Id> newLeadIds = (List<Id>)JSON.deserialize(LeadIds,List<Id>.class);
        System.debug('newLeadIds: ' + newLeadIds);
        String response = '';
        try {
            response = LSSalesPanelHelper.leadConversion(newLeadIds);
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage() + ' ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        return JSON.serialize(response);
    }

    @AuraEnabled
    public static string cloneRecords(String RecordIds){
        System.debug('Parameter RecordIds: ' + RecordIds);
        List<Id> newReadIds = (List<Id>)JSON.deserialize(RecordIds,List<Id>.class);
        System.debug('newReadIds: ' + newReadIds);
        String response = '';
        try {
            response = LSSalesPanelHelper.recordsClone(newReadIds);
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage() + ' ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        return JSON.serialize(response);
    }
}