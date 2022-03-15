public with sharing class WeatherServiceCallout {


    @AuraEnabled
    public static WeatherData geoLocationCallout(String cityName, String cityState, String cityCountryCode) {
        
        WeatherData geoLocation = new WeatherData();
        String geolocationApiInput;

        if(cityName != null){
            geolocationApiInput = cityName;
            if(cityCountryCode != null && cityState != null) {
                geolocationApiInput += ',' + cityState + ',' + cityCountryCode;
            }
        } else if(cityState != null) {
            geolocationApiInput = cityState;
        }

        String geolocationApi = 'https://api.openweathermap.org/geo/1.0/direct?q=' + geolocationApiInput + '&limit=1&appid=50e8afba18bdd6b3038fbdb47f1988fb';

        HttpRequest geoLocationRequest = new HttpRequest();
        geoLocationRequest.setEndpoint(geolocationApi);
        geoLocationRequest.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(geoLocationRequest);
        JSONParser parser = JSON.createParser(res.getBody());
        
        while (parser.nextToken() != null) {
            if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                parser.nextValue();
                if (parser.getCurrentName() == 'lat') 
                {
                    geoLocation.cityLat = parser.getDecimalValue();
                }
                else if (parser.getCurrentName() == 'lon') 
                {
                    geoLocation.cityLong = parser.getDecimalValue();
                }
            }
        }
        return geoLocation;
    }

    @AuraEnabled
    public static WeatherData weatherCallout(String cityName, String cityState, String cityCountryCode, Id accountId, Boolean isBatchContext) {
        WeatherData weather = geoLocationCallout(cityName, cityState, cityCountryCode);
        String weatherApi = 'https://api.openweathermap.org/data/2.5/onecall?lat=' + weather.cityLat + '&lon=' + weather.cityLong + '&exclude=minutely,hourly,daily,alerts&appid=50e8afba18bdd6b3038fbdb47f1988fb';

        HttpRequest weatherRequest = new HttpRequest();
        weatherRequest.setEndpoint(weatherApi);
        weatherRequest.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(weatherRequest);
        JSONParser parser = JSON.createParser(res.getBody());
        while (parser.nextToken() != null){
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                parser.nextValue();
                if (parser.getCurrentName() == 'description') 
                {
                    weather.weatherDesc = parser.getText();
                }
                else if (parser.getCurrentName() == 'icon') 
                {
                    weather.weatherIcon = parser.getText();
                }
                else if (parser.getCurrentName() == 'temp') 
                {
                    weather.weatherTemp = parser.getDecimalValue();
                }
            }
        }

        weather.weatherAccount = AccountController.updateAccountCurrentWeather(accountId, weather.weatherDesc, isBatchContext);

        return weather;
    }

    public class WeatherData {
        @AuraEnabled public Account weatherAccount;
        @AuraEnabled public String weatherDesc;
        @AuraEnabled public String weatherIcon;
        @AuraEnabled public Decimal weatherTemp;
        @AuraEnabled public Decimal cityLat;
        @AuraEnabled public Decimal cityLong;
    }
}
