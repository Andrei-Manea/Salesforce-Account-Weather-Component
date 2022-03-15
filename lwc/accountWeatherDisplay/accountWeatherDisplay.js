import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import weatherCallout from '@salesforce/apex/WeatherServiceCallout.weatherCallout';
import CITY_FIELD from '@salesforce/schema/Account.BillingCity';
import COUNTRY_FIELD from '@salesforce/schema/Account.BillingCountry';
import STATE_FIELD from '@salesforce/schema/Account.BillingState';
import STREET_FIELD from '@salesforce/schema/Account.BillingStreet';

const FIELDS = [CITY_FIELD, COUNTRY_FIELD, STATE_FIELD, STREET_FIELD];

export default class AccountWeatherDisplay extends LightningElement {
    @api recordId;
    accountData;
    currentAccountCity;
    currentAccountCityState;
    currentAccountCityCountryCode;
    currentAccountAddress;
    isLoading = true;
    error = false;
    weatherTemp;
    weatherDesc;
    weatherImg;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredAccount({ error, data }) {
        if (error) {
            console.log(error);
            this.error = true;
        } else if (data) {
            this.accountData = data;
            let cityStreet = data.fields.BillingStreet.value.split(',');
            this.currentAccountCity = data.fields.BillingCity.value !== null ? data.fields.BillingCity.value : cityStreet[0] + ', ' + cityStreet[1];
            this.currentAccountCityState = data.fields.BillingState.value;
            this.currentAccountCityCountryCode = data.fields.BillingCountry.value;
            this.currentAccountAddress = this.currentAccountCityState !== null ? this.currentAccountCity + ', ' + this.currentAccountCityState : this.currentAccountCity;
            weatherCallout({ cityName: data.fields.BillingCity.value, cityState : this.currentAccountCityState, cityCountryCode: this.currentAccountCityCountryCode, accountId: this.recordId, isBatchContext: false })
            .then(data => {
                if (data) {
                    this.weatherImg = "https://openweathermap.org/img/wn/" + data.weatherIcon + "@2x.png";
                    this.weatherTemp = (data.weatherTemp - 273.15).toFixed(1) + '°С';
                    this.weatherDesc = data.weatherDesc;
                }
            }).catch(err => console.log(err))
            .finally(() => {
                this.isLoading = false;
            });
        }
    }
}