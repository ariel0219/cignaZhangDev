import { LightningElement, wire, track, api } from 'lwc';
import getFutureAppoints from '@salesforce/apex/FutureAppointmentsController.getFutureAppoints';

export default class GetFutureAppointments extends LightningElement {

    showSpinner;
    error;
    _fireId;
    futureAppointmentList=[];
    
    @api
    get fireId() {
        return this._fireId;
    }

    // Setter for the public property 'startDate'
    set fireId(value) {
        this._fireId = value;

        console.log('===this._fireId=='+this._fireId)
        this.getFutureAppointmentFromEpic();
    }


     getFutureAppointmentFromEpic() {
        this.showSpinner = true;

        getFutureAppoints({ fireId: this._fireId })
            .then(result => {
                if (result) {
                    console.log('========result========', result);
                    this.futureAppointmentList = result;
                }
            })
            .catch(error => {
                console.log('========error========', error);
            }).finally(() => {
                this.showSpinner = false;
            });
    }

}