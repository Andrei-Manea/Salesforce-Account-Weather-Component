public with sharing class AccountController {

    public static Account updateAccountCurrentWeather(Id accountId, String currentWeather, Boolean isBatchContext) {
        try {
            Account account = [
                SELECT Id, Current_Weather__c
                FROM Account
                WHERE Id =:accountId
            ][0];
            account.Current_Weather__c = currentWeather;
            if(!isBatchContext){
                update account;
            }
            return account;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
