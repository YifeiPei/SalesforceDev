public with sharing class LSSalesPanelHelper {
    public LSSalesPanelHelper() {

    }

    private static List<Lead> getLeadRecords() {
        return [Select Id,Company,Status,Due_Date__c From Lead Order by Due_Date__c ASC];
    }

    private static List<Opportunity> getOpportunityRecords() {
        return [Select Id,Account.Name,StageName,CloseDate From Opportunity Order by CloseDate ASC];
    }

    public static List<salesInfo> getRecords() {
        List<salesInfo> newResposne = new List<salesInfo> ();
        List<Lead> leadRecords = getLeadRecords();
        List<Opportunity> opportunityRecords = getOpportunityRecords();

        if (!leadRecords.isEmpty()) {
            for (Lead leadRecord : leadRecords) {
                salesInfo newRecord = new salesInfo ();
                Id leadId = leadRecord.Id;
                newRecord.id = leadRecord.Id;
                newRecord.businessName = leadRecord.Company;
                newRecord.type = leadId.getSObjectType().getDescribe().getName();
                newRecord.status = leadRecord.Status;
                newRecord.dueDate = leadRecord.Due_Date__c;
                newResposne.add(newRecord);
            }
        }

        if (!opportunityRecords.isEmpty()) {
            for (Opportunity opportunityRecord : opportunityRecords) {
                salesInfo newRecord = new salesInfo ();
                Id opportunityId = opportunityRecord.Id;
                newRecord.id = opportunityRecord.Id;
                newRecord.businessName = opportunityRecord.Account.Name;
                newRecord.type = opportunityId.getSObjectType().getDescribe().getName();
                newRecord.status = opportunityRecord.StageName;
                newRecord.dueDate = opportunityRecord.CloseDate;
                newResposne.add(newRecord);
            }
        }

        return newResposne;
    }

    public static String leadConversion (List<Id> LeadIds) {
        String response = '';

        List<Database.LeadConvert> leadConverts = new list<Database.LeadConvert>();
        LeadStatus convertedStatus = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        for(Id leadId: LeadIds) { 
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(leadId); 
            lc.setConvertedStatus(convertedStatus.MasterLabel);
            leadConverts.add(lc);
        }
        List<Database.LeadConvertResult> lcrList = Database.convertLead(leadConverts);
        for(Database.LeadConvertResult lcr : lcrList) {
            if (!lcr.isSuccess()) {
                response = lcr.errors.get(0).message;
            }
        }
        if (response == '')
            response = 'Success';
        
        return response;
    }

    public Class salesInfo {
        @AuraEnabled
        public String id;

        @AuraEnabled
        public String businessName;

        @AuraEnabled
        public String type;

        @AuraEnabled
        public String status;

        @AuraEnabled
        public Date dueDate;
    }
}