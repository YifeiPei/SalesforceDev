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
}