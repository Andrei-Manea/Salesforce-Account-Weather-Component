public class BatchUpdateAccountWeatherField implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful {
    public Database.QueryLocator start (Database.BatchableContext bc)
    {
        return Database.getQueryLocator('SELECT Id, Current_Weather__c, BillingCity, BillingCountry, BillingState from Account');
    }
       public void execute(Database.BatchableContext bc, List<Account> acList)
       {
            List<Account> accountsList = new List<Account>();
            for(Account ac :acList)
            {
                WeatherServiceCallout.WeatherData weatherData = new WeatherServiceCallout.WeatherData();

                weatherData = WeatherServiceCallout.weatherCallout(ac.BillingCity, ac.BillingState, ac.BillingCountry, ac.Id, true);
                accountsList.add(weatherData.weatherAccount);
            }
            update accountsList;
       }
        
        public void finish(Database.BatchableContext bc)
        {
            System.debug('Finish');
        }
}
