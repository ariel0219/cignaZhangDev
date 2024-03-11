/*
  @Page Name          : GetVisitType.js
  @Description        : 
  @Author             : Ariel Zhang
  @Group              : CGI - CIGNA - Sonic Team
  @Last Modified By   : Ariel Zhang
  @Last Modified On   : 2/24/2024, 11:03:00 AM
  @Modification Log   : 
  ==============================================================================
  Ver         Date                     Author                 Modification
  ==============================================================================
  Dev 1.0   2/24/2024, 11:15:00 AM   Ariel Zhang              Dev Version
*/

import { LightningElement, api, track } from 'lwc';

//import the method that created in the Apex class
import getSortedWorkTypes from '@salesforce/apex/GetVisitTypesController.getSortedWorkTypes';

export default class getVisitTypes extends LightningElement {

    /**
     * startofCare & routine array, to pass into the html
     * @type {Array.<{label: string, value: string}>}
     */
    @track startOfCareOptions = [];
    @track routineOptions = [];

    /**
     * user selected value, to pass to the ligtning flow screen
     * @type {string}
     */
    @api selectedVisitType;


    /**
     * flags that controlls the html card expand/collaps status
     * @type {boolean}
     */
    @track isStartOfCareExpanded = false;
    @track isRoutineExpanded = false;

    /**
     * Upon HTML page loading, call Apex class method, get data(all WorTypes) from Apex
     */
    connectedCallback() {
        getSortedWorkTypes()
            .then(result => {
                // Process the returned data
                if (result && result.length >= 2) {

                    //put 2 Lists into separated containers
                    const startOfCareList = result[0];
                    const routineList = result[1];

                    //use built method to convert the list(obj) into the array(<label, value>)
                    this.startOfCareOptions = this.processList(startOfCareList);
                    this.routineOptions = this.processList(routineList);
                } else { //error handling
                    console.error('Expecting at least two lists in the response.');
                }
            })
            .catch(error => { //erro handling
                console.error('Error retrieving work types:', error);
            });
    }

    /**
     * Extract WorkType.Name field as value and label
     * 
     * @param {list} list: list contains WorkType Object(s)
     * @returns {Array.<{label: string, value: string}>}
     */
    processList(list) {
        return list.map(workType => ({
            label: workType.Name,
            value: workType.Name
        }));
    }

    /**
     * handle changing the HTML Card expand/collaps flag. 
     * feature: when one of the card is expanded, the other card will be collapsed
     */
    handleExpandCollapseStartOfCare() {
        this.isStartOfCareExpanded = !this.isStartOfCareExpanded;
        if(this.isStartOfCareExpanded) {
            this.isRoutineExpanded = false;
        }
    }

    /**
     * handle changing the HTML Card expand/collaps flag. 
     * feature: when one of the card is expanded, the other card will be collapsed
     */
    handleExpandCollapseRoutine() {
        this.isRoutineExpanded = !this.isRoutineExpanded;
        if(this.isRoutineExpanded) {
            this.isStartOfCareExpanded = false;
        }
    }

    /**
     * handle when user select a value
     * 
     * @param {*} event
     */
    handleRadioSelectionChange(event) {
        this.selectedVisitType = event.detail.value;
    }

}