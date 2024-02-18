/**
 * @author Saransh Bharadwaj
 * @description This file contains the implementation of the 'GetSlots' Lightning Web Component.
 * The component is responsible for displaying a calendar with available time slots for booking appointments.
 * It allows the user to select a date and time slot, and provides the selected values to the parent component or flow.
 * The component also handles navigation to the next screen in the flow.
 */

// Importing necessary modules from the Lightning Web Components (LWC) library
import { LightningElement, track, api } from 'lwc';

// Importing the 'getSlotsServiceAPIComponent' component from the 'c' namespace
import getSlotsServiceAPIComponent from 'c/getSlotsServiceAPIComponent';

// Importing the 'FlowAttributeChangeEvent' and 'FlowNavigationNextEvent' modules from the 'lightning/flowSupport' library
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';

// Defining a new LWC named 'GetSlots'
export default class GetSlots extends LightningElement {
    // Public property 'providerId'
    @api providerId;
    // Public property 'selectedSlot'
    @api selectedSlot;
    // Public property 'day'
    @api day;
    // Tracked property 'endDate'
    @api endDate;
    // Tracked property 'weekDays', initialized with an empty array
    @track weekDays = [];
    // Tracked property 'prevButtonDisabled', initialized with false
    @track prevButtonDisabled = false;
    // Tracked property 'nextButtonDisabled', initialized with false
    @track nextButtonDisabled = false;
    // Tracked property 'selectedDate'
    @api selectedDate;
    // Tracked property 'today'
    @track today;

    // Store time Prefrence
    @api TimePreference; 

    @api startTime;
    @api endTime;


    // Initialize _startDate with today's date in YYYY-MM-DD format
    _startDate = new Date().toISOString().slice(0,10);

// Getter for the public property 'startDate'
@api
get startDate() {
    // Return the value of '_startDate'
    return this._startDate;
}

// Setter for the public property 'startDate'
set startDate(value) {
    // Store the value in '_startDate'
    this._startDate = value;
    // Calculate the end date based on the start date
    this.calculateEndDate();
    // Generate the weekdays based on the start date
    this.generateWeekDays();
}

// Getter for the CSS class of the day
get computedClass() {
    // If the date of the day is equal to 'selectedDate', return 'block selected', otherwise return 'block'
    return this.day && this.day.date === this.selectedDate ? 'block selected' : 'block';
}

// Getter for the CSS class of the selected date
get selectedClass() {
    // If 'selectedDate' is set, return 'block selected', otherwise return 'block'
    return this.selectedDate ? 'block selected' : 'block';
}

// Event handler for the click event on Time preference
StoreTimePreference(event) {
    // Store the time preference value
    this.TimePreference = event.target.value;
    console.log('======this.TimePreference=====',this.TimePreference);
}

// This method is an event handler for the 'dateselected' event dispatched from the child component.
handleDateSelected(event) {
    // Extract the start date from the event detail and store it in a property.
    this.startDate = event.detail.startDate;
    // Extract the end date from the event detail and store it in a property.
    this.endDate = event.detail.endDate;
    // Extract the selected slot day from the event detail and store it in a property.
    this.selectedSlot = event.detail.selectedSlotDay;

    this.startTime = this.getTimeAsDate(this.selectedSlot, event.detail.time);

    this.endTime = this.getTimeAsDate(this.selectedSlot, event.detail.endTime);
    
    // Now you can use this.startDate, this.endDate, and this.selectedSlot as input variables for the next Flow screen.
    console.log('this.startDate: ' + this.startDate);
    console.log('this.endDate: ' + this.endDate);
    console.log('this.selectedSlot: ' + this.selectedSlot);
    console.log('this.startTime: ' + this.startTime);
    console.log('this.endTime: ' + this.endTime);

    this.dispatchEvent(new FlowAttributeChangeEvent('startDate', this.startDate));
    this.dispatchEvent(new FlowAttributeChangeEvent('endDate', this.endDate));
    this.dispatchEvent(new FlowAttributeChangeEvent('selectedSlot', this.selectedSlot));
    this.dispatchEvent(new FlowAttributeChangeEvent('startTime', this.startTime));
    this.dispatchEvent(new FlowAttributeChangeEvent('endTime', this.endTime));
}

// Event handler for the click event on a day
selectDay(event) {
    // Store the date of the clicked day in 'selectedDate'
    this.selectedDate = event.target.dataset.date;
    // Also store the date in 'selectedDay'
    this.selectedDay = this.selectedDate;
    console.log('======this.selectedDay=====',this.selectedDay);
}

// Method to calculate the end date based on the start date
calculateEndDate() {
    // Create a new Date object from '_startDate'
    let endDate = new Date(this._startDate);
    // Add 7 days to the date
    endDate.setDate(endDate.getDate() + 6);
    // Store the date in 'endDate' in YYYY-MM-DD format
    this.endDate = endDate.toISOString().slice(0,10);
}

// Lifecycle hook that is called when the component is inserted into the DOM
connectedCallback() {
    // Get today's date
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0'); // Months are 0-indexed in JavaScript
    const day = String(today.getDate()).padStart(2, '0');
    // Store today's date in 'today' in YYYY-MM-DD format
    this.today = `${year}-${month}-${day}`;
    
    // If '_startDate' is not set, set it to today's date
    if (!this._startDate) {
        this._startDate = new Date().toISOString().slice(0,10);
    }
    // Calculate the end date based on the start date
    this.calculateEndDate();
    // Generate the weekdays based on the start date
    this.generateWeekDays();
}

    // Event handler for the click event on a day
handleDayClick(event) {
    // Store the date of the clicked day in 'selectedDate'
    this.selectedDate = event.currentTarget.dataset.day;
}

// Event handler for the selection of a time slot
handleSlotSelect(event) {
    // Store the value of the selected slot in 'selectedSlot'
    this.selectedSlot = event.detail.value;
    // Dispatch a 'FlowAttributeChangeEvent' with the name of the attribute ('selectedSlot') and its new value
    const attributeChangeEvent = new FlowAttributeChangeEvent('selectedSlot', this.selectedSlot);
    this.dispatchEvent(attributeChangeEvent);
    // Dispatch a 'FlowNavigationNextEvent' to navigate to the next screen in the flow
    this.dispatchEvent(new FlowNavigationNextEvent());
}

// Event handler for the change of the start date
handleStartDateChange(event) {
    // Store the value of the start date in 'startDate'
    this.startDate = event.target.value;
    // Create a new Date object from 'startDate'
    let startDate = new Date(this.startDate);
    // Add 7 days to the date
    startDate.setDate(startDate.getDate() + 7);
    // Store the date in 'endDate' in YYYY-MM-DD format
    this.endDate = startDate.toISOString().slice(0,10);

    // Check if 'startDate' is not set
    if (!this.startDate) {
        // If 'startDate' is not set, dispatch a toast event with an error message
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error', // Title of the toast
                message: 'Start date is required', // Message of the toast
                variant: 'error', // Variant of the toast, which is 'error'
            }),
        );
    }
}


    // Handle the change of the selected date
    handleDateChange(event) {
        this.selectedDate = event.detail.value;
    }

    // This method is used to display the weekdays based on the start and end dates.
showWeekdays() {
    // The calculateWeekdays method is called with the start and end dates as arguments.
    // This method is responsible for calculating the weekdays and updating the weekDays array.
    this.calculateWeekdays(this.startDate, this.endDate);
}

// This method is used to format a date object as a string.
formatDate(date) {
    // The toISOString method is called on the date object to convert it to a string in the ISO 8601 format (yyyy-mm-ddTHH:MM:SS.sssZ).
    // The split method is then called on the resulting string with 'T' as the separator to split it into an array of two strings: the date and the time.
    // The first element of the array (the date) is returned.
    return date.toISOString().split('T')[0];
}

showPreviousWeek() {
    // Create a new date object from the start date
    let newEndDate = new Date(this.startDate);
    // Subtract 1 day to get the end of the previous week
    newEndDate.setDate(newEndDate.getDate() - 1);
    // Create a new date object from the new end date
    let newStartDate = new Date(newEndDate);
    // Subtract 6 days to get the start of the previous week
    newStartDate.setDate(newStartDate.getDate() - 6);

    // Update the start and end dates
    this.startDate = this.formatDate(newStartDate);
    this.endDate = this.formatDate(newEndDate);

    // Update the week days
    this.updateWeekDays();
}

get previousButtonDisabled() {
    // Create a new date object from the start date
    let startDate = new Date(this.startDate);
    // Set the time to 00:00:00
    startDate.setHours(0, 0, 0, 0);

    // Create a new date object for today's date
    let today = new Date();
    // Set the time to 00:00:00
    today.setHours(0, 0, 0, 0);

    // Disable the button if the start date is less than or equal to today's date
    return startDate.getTime() <= today.getTime();
}

    // Show the next week
    showNextWeek() {
        // Create a new date object from the end date
        let newStartDate = new Date(this.endDate);
        // Add 1 day to get the start of the next week
        newStartDate.setDate(newStartDate.getDate() + 1);
        // Create a new date object from the new start date
        let newEndDate = new Date(newStartDate);
        // Add 6 days to get the end of the next week
        newEndDate.setDate(newEndDate.getDate() + 6);
    
        // Update the start and end dates
        this.startDate = this.formatDate(newStartDate);
        this.endDate = this.formatDate(newEndDate);
    
        // Update the week days
        this.updateWeekDays();
    }

    formatDate(date) {
        // Format the date as yyyy-mm-dd
        return date.toISOString().split('T')[0];
    }

    updateWeekDays() {
        // Clear the weekDays array
        this.weekDays = [];
        // Create a new date object from the start date
        let currentDate = new Date(this.startDate);
        // Loop for 7 days
        for (let i = 0; i < 7; i++) {
            // Add the current date to the weekDays array
            this.weekDays.push(this.formatDate(currentDate));
            // Add 1 day to the current date
            currentDate.setDate(currentDate.getDate() + 1);
        }
    }

    // Calculate the weekdays
    calculateWeekdays(start, end) {
        let day;
        let today = new Date();
        this.weekDays = []; // Reset the array
    
        // Define the date formatting options
        let options = { day: 'numeric', month: 'short' };
    
        // Loop through the dates between start and end
        for (let d = start; d <= end && this.weekDays.length < 7; d.setDate(d.getDate() + 1)) {
            day = d.getDay();
            // If the day is not a weekend
            if (day != 0 && day != 6) {
                // Format the date
                let formattedDate = new Intl.DateTimeFormat('en-US', options).format(d);
                // Push the date to the weekdays array
                this.weekDays.push({
                    date: formattedDate,
                    isToday: d.getDate() === today.getDate() && d.getMonth() === today.getMonth() && d.getFullYear() === today.getFullYear()
                });
            }
        }
    }

    // Method to generate the weekdays based on the start date
    generateWeekDays() {
        // Create a new Date object from '_startDate'
        let startDate = new Date(this._startDate);
        // Initialize 'weekDays' with an empty array
        this.weekDays = [];

        // Loop through the numbers 0 to 6
        for (let i = 0; i < 7; i++) {
            // Create a new Date object from 'startDate'
            let day = new Date(startDate);
            // Add 'i' days to the date
            day.setDate(day.getDate() + i);
            // Push the date to 'weekDays' in YYYY-MM-DD format
            this.weekDays.push(day.toISOString().slice(0,10));
        }
    }

    // Getter for the weekdays with their CSS class
    get weekDaysWithClass() {
        // Map 'weekDays' to an array of objects, each with a 'date' property and a 'class' property
        return this.weekDays.map(day => ({
            // The 'date' property is the date of the day
            date: day,
            // The 'class' property is 'block selected' if the date of the day is equal to 'selectedDate', otherwise it's 'block'
            class: day === this.selectedDate ? 'block selected' : 'block'
        }));
    }

    getTimeAsDate(date, timeString) {
        // Split the date string into year, month, and day
        let [year, month, day] = date.split('-');
    
        // Create a new Date object from the passed date
        let dateObj = new Date(year, month - 1, day); // Months are 0-indexed in JavaScript
    
        // Split the time string into hours and minutes
        let [hours, minutes, period] = timeString.split(/[:\s]/);
    
        // Convert the hours to 24-hour format
        if (period === 'PM' && hours !== '12') hours = Number(hours) + 12;
        if (period === 'AM' && hours === '12') hours = '00';
    
        // Set the hours and minutes of the date
        dateObj.setHours(Number(hours), Number(minutes));
    
        return dateObj;
    }
}