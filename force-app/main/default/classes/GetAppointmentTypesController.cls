public with sharing class GetAppointmentTypesController {

    @AuraEnabled
    public static List<String> getAppointmentTypes(string visitType){
            try {
                IHPC_WorkTypeObjectMapping__mdt obj = [
                    SELECT MasterLabel, IHPC_Appointment_Type__c
                    FROM IHPC_WorkTypeObjectMapping__mdt 
                    WHERE MasterLabel = :visitType
                    LIMIT 1
                ];
                
                System.debug('selecte appointment type: '+ obj.IHPC_Appointment_Type__c);
                List<String> appointmentTypes = obj.IHPC_Appointment_Type__c.split(';');
                return appointmentTypes;
                
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
    }
}