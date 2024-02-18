public class FutureAppointmentWrapper {
    
    public String resourceType;	    //Bundle
    public String type;	    //searchset
    public Integer total;	    //141
    public List<entry> entry;
    public class entry {
        public fullURL fullURL;
        public resource resource;
        public search search;
    }
    
    class fullURL {
    }
    
    public class resource {
        public String resourceType;	    //Appointment
        public String id;	    //eYtOg2Bg3G3GagvTC6zM1aw3
        public List<identifier> identifier;
        public String status;	    //noshow
        public List<serviceCategory> serviceCategory;
        public List<serviceType> serviceType;
        public appointmentType appointmentType;
        public String start;	    //2022-10-17T22:00:00Z
        public String end_Z;	    //2022-10-17T23:00:00Z
        public Integer minutesDuration;	    //60
        public String created;	    //2022-10-17
        public String comment;	    //sick & tired
        Public String scheduledStart;
        Public String Duration;
        
        public String patientInstruction;	    //This is a friendly reminder of your upcoming telephonic appointment:        
        public List<participant> participant;
       // public issue issue;
    }
    
    class identifier {
        public String system_Z;	    //urn:oid:1.2.840.114350.1.13.562.3.7.3.698084.8
        public String value;	    //446
    }
    
    class serviceCategory {
        public List<coding> coding;
        public String text;	    //appointment
    }
    
    class coding {
        public String system_Z;	    //http://terminology.hl7.org/CodeSystem/v3-ActCode
        public String code;	    //AMB
        public String display;	    //Ambulatory
    }
    
    class serviceType {
        public List<coding> coding;
    }
    
    class appointmentType {
        public List<coding> coding;
    }
    
    class participant {
        public actor actor;
        public String required;	    //required
        public String status;	    //declined
        public period period;
    }
    
    class actor {
        public String reference;	    //Patient/eeM2K.MjJjYovRLWJRnBcaQ3
        public String display;	    //Alegis, Cindy
    }
    
    class period {
        public String start;	    //2022-10-17T22:00:00Z
        public String end_Z;	    //2022-10-17T23:00:00Z
    }
    
    class issue {
        public String issue;
    }
    
    class search {
        public String mode;	    //match
    }
}