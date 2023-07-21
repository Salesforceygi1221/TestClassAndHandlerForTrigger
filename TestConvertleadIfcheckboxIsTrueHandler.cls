@isTest
public class TestConvertleadIfcheckboxIsTrueHandler {
    @isTest static void leadConvertsTest(){
        try{
            //test lead data
            Lead lead = new Lead();
            lead.LastName = 'testLead';
            lead.Company = 'newCompany';
            lead.MobilePhone = '9876543210';
            lead.Status = 'Open - Not Contacted';
            lead.LeadSource = 'Web';
            insert lead;
            
            List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            if (( lead.LeadSource == 'web') && lead.IsConverted == False) {
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setConvertedStatus(convertStatus.MasterLabel);
                lc.setLeadId(lead.Id);
                lc.setDoNotCreateOpportunity(true);
                leadConverts.add(lc);
            }
            
            //if leadConverts list is not empty so print AccountId and contactId
            if(!leadConverts.isEmpty()){
                List<Database.LeadConvertResult> results = Database.convertLead(leadConverts, false);
                for(Database.LeadConvertResult result:results){
                    if(result.isSuccess()){
                        System.debug('Lead conversion succeeded. Account Id: '+result.getAccountId()+' Contact Id: '+result.getContactId());
                    }else{
                        System.debug('Lead conversion failed. Lead Id: '+ result.getLeadId() +' Error: '+result.getErrors());
                    }
                }  
            }
            //assertion
            Boolean checkIsConverted = [Select Id from Lead where IsConverted=true LIMIT 1].IsConverted;
            System.assertEquals(true, checkIsConverted);
        }
        catch(Exception e){
            System.debug('Exception is:  '+e.getMessage());
        }
    }
}