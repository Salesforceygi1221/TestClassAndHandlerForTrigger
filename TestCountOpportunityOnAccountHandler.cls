@isTest
public class TestCountOpportunityOnAccountHandler {
	@isTest static void testCreateAndUpdateOpporOnAccount(){
        
        //Test data insert 
        Account acc = new Account(Name = 'TestAccount');
        insert acc;
        
        Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Badoriyan',
                                         StageName = 'Prospecting',  CloseDate = Date.newInstance(2023,07,20));
        Opportunity opp1 = new Opportunity(AccountId = acc.Id, Name = 'bilbil',
                                          StageName = 'Qualification',  CloseDate = Date.newInstance(2023,07,29));
        List<Opportunity> opplist = new List<Opportunity>();
        opplist.add(opp);
        opplist.add(opp1);
        insert opplist;
        
        set<Id> accountIds = new Set<Id>();
		for(Opportunity opportunity:opplist){
            accountIds.add(opportunity.AccountId);
        }
        
        List<Account> accountsToUpdate = [SELECT Id, No_Of_Opportunity__c, (SELECT Id FROM Opportunities) FROM Account WHERE Id IN :accountIds];
        
        //update Account which is the related to the inserted or updated Contact
        for (Account account : accountsToUpdate) {
            account.No_Of_Opportunity__c = account.Opportunities.size();
            //accountsToUpdate.add(account);
        }
        update accountsToUpdate;
        
        test.startTest();
        CountOpportunityOnAccountHandler.afterInsertUpdateOppor(opplist);
        test.stopTest();
    }
    
    @isTest static void testDeleteOpportunityOnAccount(){
        //Test data insert 
        Account acc = new Account(Name = 'TestAccount');
        insert acc;
        
        Opportunity opp = new Opportunity(AccountId = acc.Id, Name = 'Badoriyan',
                                         StageName = 'Qualification',  CloseDate = Date.newInstance(2023,07,27));
        Opportunity opp1 = new Opportunity(AccountId = acc.Id, Name = 'bilbil',
                                          StageName = 'Prospecting',  CloseDate = Date.newInstance(2023,07,30));
        List<Opportunity> opplist = new List<Opportunity>();
        opplist.add(opp);
        opplist.add(opp1);
        insert opplist;
        
        set<Id> accountIds = new Set<Id>();
		for(Opportunity opportunity:opplist){
            accountIds.add(opportunity.AccountId);
        }
        
        List<Opportunity> deleteopp = [select Id,Name from Opportunity where AccountId In:accountIds];
		delete deleteopp;
        
        List<Account> accountsToUpdate = [SELECT Id, No_Of_Opportunity__c, (SELECT Id FROM Opportunities) FROM Account WHERE Id IN :accountIds];
        
        //update Account which is the related to the inserted or updated Contact
        for (Account account : accountsToUpdate) {
            account.No_Of_Opportunity__c = account.Opportunities.size();
            //accountsToUpdate.add(account);
        }
        update accountsToUpdate;
        
        test.startTest();
        CountOpportunityOnAccountHandler.afterDeleteOppor(opplist);
        test.stopTest();
    }
}