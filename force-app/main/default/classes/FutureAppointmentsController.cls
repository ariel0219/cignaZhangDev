public class FutureAppointmentsController {
    
    @AuraEnabled(cacheable=true)
    public static list<FutureAppointWrapper> getFutureAppoints(String fireId){
        list<FutureAppointWrapper> wrapperList = new list<FutureAppointWrapper>();
        if(fireId!=null && fireId!=''){
            FutureAppointmentWrapper responsefutureWrapper = makeCallout(fireId);
            if(responsefutureWrapper!=null){
                for(FutureAppointmentWrapper.entry entry : responsefutureWrapper.entry){   
                    String status = entry.resource.status;
                    if(status=='noshow' || status=='booked' || status=='fulfilled' || status=='cancelled' ){
                        FutureAppointWrapper wrapper = new FutureAppointWrapper();
                        wrapper.patientName = 'Cindy Alegis'; // Update for Dynamic Patient Details
                        wrapper.status = status;
                        wrapper.duration = entry.resource.minutesDuration;
                        wrapper.scheduledStart = convertDT(entry.resource.start);
                        DateTime dt = (DateTime)JSON.deserialize('"' + entry.resource.start + '"', DateTime.class);
                        dt = dt.addMinutes(wrapper.duration);
                        String formattedDate = dt.format('MM-dd-yyyy hh:mm:ss a');
                         wrapper.scheduledEnd = formattedDate;
                        wrapperList.add(wrapper);
                    }
                }
            }
        }
        return wrapperList;
    }
    
    static String convertDT(String dateTimeStr){
        if(dateTimeStr!=null){
            DateTime dt = (DateTime)JSON.deserialize('"' + dateTimeStr + '"', DateTime.class);
            // Now format the DateTime object
            String formattedDate = dt.format('MM-dd-yyyy hh:mm:ss a');
            return formattedDate;
        }
        return '';
    }
    
    
    public static FutureAppointmentWrapper makeCallout(String fireId) {
        
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint('https://77zhnqwrx4.execute-api.us-east-1.amazonaws.com/dev/mapper/api/v1/appt?patient='+fireId+'&X-CONSUMER-KEY=SFHC');
        httpRequest.setMethod('GET');
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setHeader('Authorization', 'Bearer ' + getToken());
        httpRequest.setTimeout(30000);        
        // Perform the callout and handle the response
        HttpResponse httpResponse = http.send(httpRequest);
        System.debug('=========httpResponse======'+JSON.serialize(httpResponse.getBody()));
        FutureAppointmentWrapper responsefutureWrapper;        
        if (httpResponse.getStatusCode() == 200) {
            responsefutureWrapper = (FutureAppointmentWrapper)JSON.deserialize(httpResponse.getBody(), FutureAppointmentWrapper.class);
        }
        return responsefutureWrapper;
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
    
    
    Public class FutureAppointWrapper{
        @AuraEnabled
        public string patientName;
        @AuraEnabled
        public string scheduledStart;
        @AuraEnabled
        public string scheduledEnd;
        @AuraEnabled
        public string status;
        @AuraEnabled
        public Integer duration;
    }
    

}