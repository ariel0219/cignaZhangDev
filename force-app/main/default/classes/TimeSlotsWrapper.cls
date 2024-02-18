public class TimeSlotsWrapper {
    
    public class Specialty {
        public String Abbreviation {get;set;} 
        public String Number_Z {get;set;} // in json: Number
        public String Title {get;set;} 
        public String ExternalName {get;set;} 
        
        public Specialty(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'Abbreviation') {
                            Abbreviation = parser.getText();
                        } else if (text == 'Number') {
                            Number_Z = parser.getText();
                        } else if (text == 'Title') {
                            Title = parser.getText();
                        } else if (text == 'ExternalName') {
                            ExternalName = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Specialty consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Slots {
        public String Time_Z {get;set;} // in json: Time
        public String DisplayTime {get;set;} 
        public String ArrivalTime {get;set;} 
        
        public Slots(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'Time') {
                            Time_Z = parser.getText();
                        } else if (text == 'DisplayTime') {
                            DisplayTime = parser.getText();
                        } else if (text == 'ArrivalTime') {
                            ArrivalTime = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Slots consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Departments {
        public Address Address {get;set;} 
        public List<IDs> IDs {get;set;} 
        public List<LocationInstructions> LocationInstructions {get;set;} 
        public String Name {get;set;} 
        public Country OfficialTimeZone {get;set;} 
        public List<Phones> Phones {get;set;} 
        public Specialty Specialty {get;set;} 
        
        public Departments(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'Address') {
                            Address = new Address(parser);
                        } else if (text == 'IDs') {
                            IDs = arrayOfIDs(parser);
                        } else if (text == 'LocationInstructions') {
                            LocationInstructions = arrayOfLocationInstructions(parser);
                        } else if (text == 'Name') {
                            Name = parser.getText();
                        } else if (text == 'OfficialTimeZone') {
                            OfficialTimeZone = new Country(parser);
                        } else if (text == 'Phones') {
                            Phones = arrayOfPhones(parser);
                        } else if (text == 'Specialty') {
                            Specialty = new Specialty(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Departments consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class VisitTypes {
        public String Name {get;set;} 
        public String DisplayName {get;set;} 
        public List<String> PatientInstructions {get;set;} 
        public List<IDs> IDs {get;set;} 
        
        public VisitTypes(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'Name') {
                            Name = parser.getText();
                        } else if (text == 'DisplayName') {
                            DisplayName = parser.getText();
                        } else if (text == 'PatientInstructions') {
                            PatientInstructions = arrayOfString(parser);
                        } else if (text == 'IDs') {
                            IDs = arrayOfIDs(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'VisitTypes consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public Object Message {get;set;} 
    public Object ExceptionMessage {get;set;} 
    public Object ExceptionType {get;set;} 
    public List<Departments> Departments {get;set;} 
    public Provider Provider {get;set;} 
    public List<VisitTypes> VisitTypes {get;set;} 
    public List<ScheduleDays> ScheduleDays {get;set;} 
    
    public TimeSlotsWrapper(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'Message') {
                        Message = parser.readValueAs(Object.class);
                    } else if (text == 'ExceptionMessage') {
                        ExceptionMessage = parser.readValueAs(Object.class);
                    } else if (text == 'ExceptionType') {
                        ExceptionType = parser.readValueAs(Object.class);
                    } else if (text == 'Departments') {
                        Departments = arrayOfDepartments(parser);
                    } else if (text == 'Provider') {
                        Provider = new Provider(parser);
                    } else if (text == 'VisitTypes') {
                        VisitTypes = arrayOfVisitTypes(parser);
                    } else if (text == 'ScheduleDays') {
                        ScheduleDays = arrayOfScheduleDays(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Address {
        public String City {get;set;} 
        public Country Country {get;set;} 
        public Country County {get;set;} 
        public Country District {get;set;} 
        public Country State {get;set;} 
        public String HouseNumber {get;set;} 
        public Integer PostalCode {get;set;} 
        public List<String> StreetAddress {get;set;} 
        
        public Address(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'City') {
                            City = parser.getText();
                        } else if (text == 'Country') {
                            Country = new Country(parser);
                        } else if (text == 'County') {
                            County = new Country(parser);
                        } else if (text == 'District') {
                            District = new Country(parser);
                        } else if (text == 'State') {
                            State = new Country(parser);
                        } else if (text == 'HouseNumber') {
                            HouseNumber = parser.getText();
                        } else if (text == 'PostalCode') {
                            PostalCode = parser.getIntegerValue();
                        } else if (text == 'StreetAddress') {
                            StreetAddress = arrayOfString(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Address consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Phones {
        public String Number_Z {get;set;} // in json: Number
        public String Type {get;set;} 
        
        public Phones(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'Number') {
                            Number_Z = parser.getText();
                        } else if (text == 'Type') {
                            Type = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Phones consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ScheduleDays {
        public String Date_Z {get;set;} // in json: Date
        public List<Slots> Slots {get;set;} 
        public IDs Provider {get;set;} 
        public IDs Department {get;set;} 
        public IDs VisitType {get;set;} 
        
        public ScheduleDays(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'Date') {
                            Date_Z = parser.getText();
                        } else if (text == 'Slots') {
                            Slots = arrayOfSlots(parser);
                        } else if (text == 'Provider') {
                            Provider = new IDs(parser);
                        } else if (text == 'Department') {
                            Department = new IDs(parser);
                        } else if (text == 'VisitType') {
                            VisitType = new IDs(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'ScheduleDays consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Country {
        public String Abbreviation {get;set;} 
        public String Number_Z {get;set;} // in json: Number
        public String Title {get;set;} 
        
        public Country(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'Abbreviation') {
                            Abbreviation = parser.getText();
                        } else if (text == 'Number') {
                            Number_Z = parser.getText();
                        } else if (text == 'Title') {
                            Title = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Country consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class IDs {
        public String ID {get;set;} 
        public String Type {get;set;} 
        
        public IDs(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'ID') {
                            ID = parser.getText();
                        } else if (text == 'Type') {
                            Type = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'IDs consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class LocationInstructions {
        
        public LocationInstructions(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        {
                            System.debug(LoggingLevel.WARN, 'LocationInstructions consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Provider {
        public String DisplayName {get;set;} 
        public List<IDs> IDs {get;set;} 
        
        public Provider(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'DisplayName') {
                            DisplayName = parser.getText();
                        } else if (text == 'IDs') {
                            IDs = arrayOfIDs(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Provider consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static TimeSlotsWrapper parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new TimeSlotsWrapper(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                    depth++;
                } else if (curr == System.JSONToken.END_OBJECT ||
                           curr == System.JSONToken.END_ARRAY) {
                               depth--;
                           }
        } while (depth > 0 && parser.nextToken() != null);
    }
    
    private static List<Departments> arrayOfDepartments(System.JSONParser p) {
        List<Departments> res = new List<Departments>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Departments(p));
        }
        return res;
    }
    
    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }
    
    private static List<VisitTypes> arrayOfVisitTypes(System.JSONParser p) {
        List<VisitTypes> res = new List<VisitTypes>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new VisitTypes(p));
        }
        return res;
    }
    
    
    private static List<Slots> arrayOfSlots(System.JSONParser p) {
        List<Slots> res = new List<Slots>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Slots(p));
        }
        return res;
    }
    
    private static List<LocationInstructions> arrayOfLocationInstructions(System.JSONParser p) {
        List<LocationInstructions> res = new List<LocationInstructions>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new LocationInstructions(p));
        }
        return res;
    }
    
    private static List<Phones> arrayOfPhones(System.JSONParser p) {
        List<Phones> res = new List<Phones>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Phones(p));
        }
        return res;
    }
    
    private static List<ScheduleDays> arrayOfScheduleDays(System.JSONParser p) {
        List<ScheduleDays> res = new List<ScheduleDays>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ScheduleDays(p));
        }
        return res;
    }
    
    private static List<IDs> arrayOfIDs(System.JSONParser p) {
        List<IDs> res = new List<IDs>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new IDs(p));
        }
        return res;
    }
}