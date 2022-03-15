public with sharing class AccountCurrentWeatherInvocable {

    @InvocableMethod(label='Update Account Current Weather' description='updates the current weather for the given accounts')
    public static void updateAccountCurrentWeatherInvocable(List<Account> accounts) {
        for(Account account : accounts) {
            WeatherServiceCallout.weatherCallout(account.BillingCity, account.BillingState, account.BillingCountry, account.Id);
        }
    }
}
