public with sharing class getTimeSlotFromCustomMetaData {
    
    // Define a public static method that is Aura enabled and cacheable
    // @AuraEnabled(cacheable=true)
    // public static List<TimeSlots__mdt> getTimeSlots() {
    
    //     // Get the metadata about the TimeSlots__mdt object
    //     Schema.DescribeSObjectResult d = TimeSlots__mdt.sObjectType.getDescribe();
    
    //    // Check if the current user has access to the TimeSlots__mdt object
    //     if (!d.isAccessible()) {
    //         // If the user does not have access, throw a SecurityException with a custom message
    //         throw new System.SecurityException('You do not have the necessary permissions to access TimeSlots__mdt.');
    //     }
    
    //     // Query the TimeSlots__mdt object to get the selected date and time
    //     List<TimeSlots__mdt> timeSlots = [SELECT Label,Selected_Date__c, Time__c,End_Time__c 
    //                                         FROM TimeSlots__mdt 
    //                                         ORDER BY Label ASC];
    
    //     // Return the queried time slots
    //     return timeSlots;
    // }
    
    @AuraEnabled
    public static DisplayDateTimeSlotsWrapper getTimeSlots(String startDate, String endDate, String providerId) {
        //providerId = '0HnD10000000bCbKAI';//For testing
        
        system.debug('=======startDate======='+startDate);
        system.debug('=======endDate======='+endDate);
        system.debug('=======providerId======='+providerId);
        Map<String, String> params = new Map<String, String>();
        Map<String, String> visitTypeMap = new Map<String, String>();
        list<ServiceResource> srList =  [Select Id,Account.Name, Account.HealthCloudGA__SourceSystem__pc, 
                                         Account.HealthCloudGA__SourceSystemId__pc,Account.RecordType.Name                                        
                                         from ServiceResource where Id=:providerId AND Account.RecordType.Name='Provider'];
        
        if(srList!=null && !srList.isEmpty()){
            ServiceResource sreq = srList[0];
            String sourceProviderId = sreq.Account.HealthCloudGA__SourceSystemId__pc!=null?sreq.Account.HealthCloudGA__SourceSystemId__pc:'';
            String sourceProviderType = sreq.Account.HealthCloudGA__SourceSystem__pc!=null?sreq.Account.HealthCloudGA__SourceSystem__pc:'';
            params.put('StartDate',startDate);
            params.put('EndDate',endDate);
            params.put('ProviderID',sourceProviderId);
            params.put('ProviderIDType',sourceProviderType);                        
            TimeSlotsWrapper responseWrapper = makeCallout(params); 
            
            if(responseWrapper != null){
                DisplayDateTimeSlotsWrapper dtWrapper = new DisplayDateTimeSlotsWrapper();
                list<DisplayTimeSlotsWrapper> displayTimeWrapperList = new list<DisplayTimeSlotsWrapper>();
                List<TimeSlotsWrapper.VisitTypes> visitTypeList = responseWrapper.VisitTypes!=null && responseWrapper.VisitTypes.size()>0?responseWrapper.VisitTypes:null;
                for(TimeSlotsWrapper.VisitTypes visitType : visitTypeList){
                    for(TimeSlotsWrapper.IDs visitTypeId : visitType.IDs){
                        String key = visitTypeId.ID+visitTypeId.Type;
                        String value = visitTypeId.ID+';'+visitTypeId.Type;
                        if(!visitTypeMap.containsKey(key)){
                            visitTypeMap.put(key,value);
                        }
                    }
                }
                
                system.debug('=======visitTypeMap======='+JSON.serialize(visitTypeMap));
                Integer i=0;
                for(TimeSlotsWrapper.ScheduleDays sch : responseWrapper.ScheduleDays){
                    
                    TimeSlotsWrapper.IDs visitTypeId = sch.VisitType;
                    if((visitTypeId.ID == '228' /* || visitTypeId.ID == '397'*/) && visitTypeId.Type=='External'){
                        for(TimeSlotsWrapper.Slots slot : sch.Slots){
                            i++;
                            DisplayTimeSlotsWrapper displayTimeWrapper = new DisplayTimeSlotsWrapper();                        
                            String timeString = slot.DisplayTime;
                            DateTime dt = DateTime.valueOf('1970-01-01 ' + timeString);
                            DateTime endDT = dt.addMinutes(60);
                            String formattedStartTime = dt.format('hh:mm a');
                            String formattedEndTime = endDT.format('hh:mm a');
                            displayTimeWrapper.startTime = formattedStartTime;
                            displayTimeWrapper.endTime = formattedEndTime;
                            displayTimeWrapper.slotId = i;
                            displayTimeWrapperList.add(displayTimeWrapper);
                            
                        }
                    }
                }
                dtWrapper.selectedDate = startDate;
                dtWrapper.timeSlotsWrapperList = displayTimeWrapperList;
                
                system.debug('=========dtWrapper=========='+dtWrapper);
                return dtWrapper;            
            }else{
                return new DisplayDateTimeSlotsWrapper();            
            }
        }
        return new DisplayDateTimeSlotsWrapper();            
    }
    
    /*
* This method makes a callout to an external service to get the available time slots for the selected date.
* @param params A map of parameters to pass to the external service.
* @return A map of available time slots.
*/
    public static TimeSlotsWrapper makeCallout(Map<String, String> params) {
        // Create and populate RequestWrapper
        Map<String, String> req = new Map<String, String>();
        
        // Add parameters from the map
        for (String key : params.keySet()) {
            req.put(key, params.get(key));
        }
        // Serialize the request data
        String jsonBody = JSON.serialize(req);
        // Setup HTTP callout using Named Credentials
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint('https://77zhnqwrx4.execute-api.us-east-1.amazonaws.com/dev/mapper/api/v1/appt/openslots?X-CONSUMER-KEY=SFHC-DEV');
        httpRequest.setMethod('POST');
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setBody(jsonBody);
        httpRequest.setHeader('Authorization', 'Bearer ' + getToken());
        httpRequest.setTimeout(30000);        
        // Perform the callout and handle the response
        HttpResponse httpResponse = http.send(httpRequest);
        System.debug('=========httpResponse======'+httpResponse.getBody());
        TimeSlotsWrapper responseWrapper;        
        if (httpResponse.getStatusCode() == 200) {
            responseWrapper = TimeSlotsWrapper.parse(httpResponse.getBody());
        }
        return responseWrapper;
    }
    
    public static String getToken() {
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint('https://cigna-destruct.oktapreview.com/oauth2/default/v1/token');
        httpRequest.setMethod('POST');
        httpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        httpRequest.setHeader('Accept', 'application/json');
        httpRequest.setBody('grant_type=client_credentials&scope=cdt-hbc-txn&client_id=0oabda87rnHsHnj6x1d7&client_secret=J3V8fuS9nIlCUAjoquIoeikenezYyDptBeyswLOKbUa0vs-akxP165CPFT_9bw6d');
        HttpResponse res = http.send(httpRequest);
        httpRequest.setTimeout(30000);
        Map<String,Object> newMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        String token = String.valueOf(newMap.get('access_token'));
        return token;
    }
    
    public Class DisplayDateTimeSlotsWrapper{
        @AuraEnabled
        public String selectedDate{get;set;}
        @AuraEnabled
        public list<DisplayTimeSlotsWrapper> timeSlotsWrapperList{get;set;}
    }
    
    public Class DisplayTimeSlotsWrapper{
        @AuraEnabled
        public Integer slotId{get;set;}
        @AuraEnabled
        public String startTime{get;set;}
        @AuraEnabled
        public String endTime{get;set;}
    }
    
}