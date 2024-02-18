/**
 * @author Saransh Bharadwaj
 * @description This file contains the implementation of the getSlotsServiceAPIComponent Lightning Web Component.
 * The component fetches time slots based on the selected day and displays them to the user.
 * It also handles user interactions such as selecting a time slot and dispatching events.
 * The component uses Apex methods and wire service to fetch data from CustomMetaData - Time_Slots__mdt.
 */

// Import the necessary modules from the 'lwc' library
// LightningElement: Base class for Lightning Web Components
// wire: A decorator to wire an Apex method or get data from Salesforce
// api: A decorator to expose public properties and methods
// track: A decorator to track changes in properties and re-render the component when they change
import { LightningElement, wire, api, track } from 'lwc';

// Import the ShowToastEvent module from the 'lightning/platformShowToastEvent' library
// ShowToastEvent: Used to display a toast notification for error messages
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Import the 'getTimeSlots' method from the 'getTimeSlotFromCustomMetaData.getTimeSlots' Apex class
import getTimeSlots from '@salesforce/apex/getTimeSlotFromCustomMetaData.getTimeSlots';

export default class getSlotsServiceAPIComponent extends LightningElement {
    @api recordId; // Public property to store the record ID
    @api providerId;
    @api startDate; // Public property to store the start date
    @api endDate; // Public property to store the end date
    @track data; // Private property to store the fetched data 
    @track isLoading = false; // Private property to track the loading state
    @track error; // Private property to store any error that occurs

    selectedSlot = '';
    @track timeSlots = [];
    @track privateSelectedSlotDay;


    // Setter for the public property 'selectedSlotDay'
    @api
    set selectedSlotDay(value) {
        // Store the value in a private property '_selectedSlotDay'
        this._selectedSlotDay = value;
        // Also store the value in a private reactive property 'privateSelectedSlotDay' to trigger the wire service
        this.privateSelectedSlotDay = value;
        console.log('=========providerId======' + this.providerId);
        console.log('=========selectedSlotDay======' + this.selectedSlotDay);
        if (this.providerId) {
            this.getSelectedDateTimeSlots();
        }
    }

    getSelectedDateTimeSlots() {
        this.isLoading = true;

        getTimeSlots({ startDate: this.selectedSlotDay, endDate: this.selectedSlotDay, providerId: this.providerId })
            .then(result => {
                if (result) {
                    console.log('========result========', result);
                    this.timeSlots = result;
                }
            })
            .catch(error => {
                console.log('========error========', error);
            }).finally(() => {
                this.isLoading = false;
            });
    }

    // Getter for the public property 'selectedSlotDay'
    get selectedSlotDay() {
        // Log the value of '_selectedSlotDay'
        console.log('get._selectedSlotDay: ');
        // Return the value of '_selectedSlotDay'
        return this._selectedSlotDay;
    }

    // Event handler for the click event
    handleClick(event) {
        console.log('I am here1');
        const slotId = event.currentTarget.dataset.id;
        console.log('I am here2',slotId);
        const selectedSlot = this.timeSlots.timeSlotsWrapperList.find(slot => slot.slotId == slotId);
        console.log('I am here3',selectedSlot);

        // Store the time and endTime values in the component's properties
        this.time = selectedSlot.startTime;
        this.endTime = selectedSlot.endTime;

        // Remove the selected class from all boxes
        this.template.querySelectorAll('.time-slot').forEach(box => {
            box.classList.remove('selected');
        });


        console.log('this.startTimeAPI_JS: ' + this.time);
        console.log('this.endTime:API_JS ' + this.endTime);

        // Add the selected class to the clicked box
        event.currentTarget.classList.add('selected');

        this.handleDateSelection();
    }

    // Getter for the CSS class of the time slot because '===' is not supported in HTML, so we need to use a getter
    get timeSlotClass() {
        // If the id of the slot is equal to 'selectedSlot', return 'time-slot selected', otherwise return 'time-slot'
        return this.selectedSlot === this.slot.slotId ? 'time-slot selected' : 'time-slot';
    }

    // Dispatch a custom event with the start date and end date
    handleDateSelection() {

        console.log('========handleDateSelection this.selectedSlotDay=========',this.selectedSlotDay);

        // Dispatch the custom event with the additional detail
        this.dispatchEvent(new CustomEvent('dateselected', {
            detail: {
                startDate: this.startDate,
                endDate: this.endDate,
                selectedSlotDay: this.selectedSlotDay,
                time: this.time,
                endTime: this.endTime
            }
        }));
    }

    //TEST DATA coming from Custom Metadata -> "timeSlots__mdt"
    // Wire an Apex method. This method is invoked whenever the value of 'privateSelectedSlotDay' changes.
    /*@wire(getTimeSlots, { startDate: this.startDate, endDate: this.endDate, providerId: this.providerId })
    wiredTimeSlots({ error, data }) {
        // Check if the wire service returned data
        if (data) {
            console.log('========data========', data);
            // If data is returned, filter the time slots based on the selected day
            //this.timeSlots = data.filter(record => record.Selected_Date__c === this.selectedSlotDay);
        }
        // Check if the wire service returned an error
        else if (error) {
            // If an error is returned, store the error
            this.error = error;
            console.log('========error========', error);
            // Dispatch a toast event to display the error message
            // this.dispatchEvent(
            //     new ShowToastEvent({
            //         title: 'Error loading time slots', // Title of the toast
            //         message: error.body.message, // Message of the toast, which is the error message
            //         variant: 'error', // Variant of the toast, which is 'error'
            //     }),
            // );
        }
    }*/

}