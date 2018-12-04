@isTest
private class AccountTriggerTest {
	
    @isTest
    public static void testInsertAccountWithPhone1234(){
        Account newAccount = new Account(Name = 'Hello');
        insert newAccount;
        Account acc4 = new Account(Name='Hello2');
        newAccount.Name = 'kuy';
        upsert new List<Account>{acc2, newAccount};
    }
}