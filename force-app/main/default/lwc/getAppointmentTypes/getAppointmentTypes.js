import { LightningElement, api, track} from 'lwc';
import getApointmentTypes from '@salesforce/apex/getAppointmentTypesController.getAppointmentTypes';

export default class getAppointmentTypes extends LightningElement {

  @api selectedVisitType;
  @api selectedApointmentType;
  @track getAppointmentTypesOptions = [];
  

  message;
  connectedCallback() {
    getApointmentTypes({ visitType: this.selectedVisitType})
        .then(result => {
          this.getAppointmentTypesOptions = this.processList(result);

            console.log(result); // Handle the response
        })
        .catch(error => {
            console.error(error); // Handle any errors
        });
 }

 processList(list) {
  return list.map(appointment => ({
      label: appointment,
      value: appointment
  }));
 }

 handleRadioSelectionChange(event) {
  this.selectedApointmentType = event.detail.value;
 }

}