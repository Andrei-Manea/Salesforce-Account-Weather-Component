An LWC component which will be placed on the Account Lightning Detail Page and
show the weather based on the account location

The component displays 2 fields:
Address 
Account Current Weather
 
When the Account page is up, an external API is called to
https://openweathermap.org/api/one-call-api

Populates the Account Current Weather Field with the value of
current.weather.description 

When the Address value is changed, the current weather is retrieved and displayed
 
A Batch JOB that runs each hour and updates the Account Current Weather for all
accounts
