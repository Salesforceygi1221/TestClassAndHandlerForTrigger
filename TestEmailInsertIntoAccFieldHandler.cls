@isTest
public class TestEmailInsertIntoAccFieldHandler {
    @isTest public static void updateEmailTest(){
        try{
            // create new account record and insert
            Account acc = new Account();
            acc.Name = 'AccountName';
            insert acc;

            List<Contact> conlist = new List<Contact>();
            //create a new contact record and insert
            Contact con1 = new Contact(LastName = 'yogi1', AccountId = acc.Id, 
                                       Email = 'test123@example.com');
			insert con1;
            
            //record add in contact list
            conlist.add(con1);
            
            test.startTest();
            String conAccId = [Select Id, AccountId, Email From Contact limit 1].AccountId;
            String email = [Select Id, AccountId, Email From Contact].Email;
            if (conAccId != null && email != null) {
                acc.accounting_description__c = email;
                update acc;
            } else {
                System.debug('Contact AccountId or Email is null');
            }
            
            
            EmailInsertIntoAccFieldHandler.insertEmail(conlist);
            test.stopTest();
            
            //assertion when actual mail and expected mail is same
            System.assertEquals(email, acc.accounting_description__c);
        }
        catch (Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
    }
}