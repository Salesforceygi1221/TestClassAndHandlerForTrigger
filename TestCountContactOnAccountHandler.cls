@isTest
public class TestCountContactOnAccountHandler {
    
    //setup common data for all methods
    @testSetup static void setCommonData(){
        //Test data insert 
        Account acc = new Account(Name = 'TestAccount');
        insert acc;
        
        Contact con = new Contact(AccountId = acc.Id, LastName = 'Badoriyan');
        Contact con1 = new Contact(AccountId = acc.Id, LastName = 'bilbil');
        List<Contact> conlist = new List<Contact>();
        conlist.add(con);
        conlist.add(con1);
        insert conlist;
    }
    @isTest static void testCreateAndUpdateContactOnAccount(){
        
        List<Contact> conlist = [select Id, AccountId, Name from Contact];
        
        set<Id> accountIds = new Set<Id>();
		for(Contact contact:conlist){
            accountIds.add(contact.AccountId);
        }
        
        List<Account> accountsToUpdate = [SELECT Id, No_Of_Contact__c, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accountIds];
        
        //update Account which is the related to the inserted or updated Contact
        for (Account account : accountsToUpdate) {
            account.No_Of_Contact__c = account.Contacts.size();
            //accountsToUpdate.add(account);
        }
        update accountsToUpdate;
        
        test.startTest();
        CountContactOnAccountHandler.afterInsertUpdateContact(conlist);
        test.stopTest();
    }
    
    @isTest static void testDeleteContactOnAccount(){
        
        List<Contact> conlist = [select Id, AccountId, Name from Contact];
        
        set<Id> accountIds = new Set<Id>();
		for(Contact contact:conlist){
            accountIds.add(contact.AccountId);
        }
        
        List<Contact> deletecon = [select Id,Name from Contact where AccountId In:accountIds];
		delete deletecon;
        
        List<Account> accountsToUpdate = [SELECT Id, No_Of_Contact__c, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accountIds];
        
        //update Account which is the related to the inserted or updated Contact
        for (Account account : accountsToUpdate) {
            account.No_Of_Contact__c = account.Contacts.size();
            //accountsToUpdate.add(account);
        }
        update accountsToUpdate;
        
        test.startTest();
        CountContactOnAccountHandler.afterDeleteContact(conlist);
        test.stopTest();
    }
}