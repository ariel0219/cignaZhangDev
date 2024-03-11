/*
 @Page Name          : GetVisitType.cls
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
  Dev 1.1   2/26/2024, 20:18:00 PM   Ariel Zhang              Dev Version
*/

public with sharing class GetVisitTypesController {

    /**[PUBLIC] [AURA-ENABLED]
     * Get all current Work Types(visit types) and separate into two different lists by its category and return. 
     * Two categories are "Start of Care" and "Routine"
     * 
     * @param (void)
     * @return List<List<WorkType>>: A List contains two lists, 1. Start of Care List  2. Routine List.
     * Each list contains 'WorkType' object(s).
     * @throws N/A 
     * @see 'getAllWorkType' & 'separateVisitTypeObjByCategory' for more nested methods details.
     * @since 26-Feb-2024
     * @author Ariel Zhang
     * @version Dev 1.1
     */
    @AuraEnabled //Register method, thus can be found in the lwc
    public static List<List<WorkType>> getSortedWorkTypes() {
        //Create WorkType Objects containers.
        List<WorkType> startOfCareList = new List<WorkType>();
        List<WorkType> routineList = new List<WorkType>();
        List<List<WorkType>> sortedWorkTypeList = new List<List<WorkType>>(); //to be returned

        //First Get all Worktype Object and pass into the 'separateVisitTypeObjByCategory' to separte by different categories
        separateVisitTypeObjByCategory(getAllWorkTypes(), startOfCareList, routineList);

        //add to the return List and ready to return
        sortedWorkTypeList.add(startOfCareList);
        sortedWorkTypeList.add(routineList);

        displayWorkTypeList(startOfCareList);
        displayWorkTypeList(routineList);

        return sortedWorkTypeList;
    }

    /** [PRIVATE]
     * Get all Worktypes and return them in a List<Worktype>
     * 
     * @return List<WorkType>
     * @throws N/A 
     * @since 26-Feb-2024
     * @author Ariel Zhang
     * @version Dev 1.2
     * v1.2: if statment for soql changed to "or" to prevent one field failed to get the entire result is null
     */
    private static List<WorkType> getAllWorkTypes(){

        List<WorkType> allWorkTypes;

        //this 'if' statment is to avoid CRUD violation: Validate CRUD permission before SOQL/DML operation (rule: Security-ApexCRUDViolation)
        if(
            WorkType.SObjectType.getDescribe().isAccessible() ||
            Schema.SObjectType.WorkType.fields.Name.isAccessible() ||
            Schema.SObjectType.WorkType.fields.IHPC_VisitType__c.isAccessible() ||
            Schema.SObjectType.WorkType.fields.IHPC_Visit_Type_Id__c.isAccessible() ||
            Schema.SObjectType.WorkType.fields.DurationType.isAccessible() ||
            Schema.SObjectType.WorkType.fields.EstimatedDuration.isAccessible() ||
            Schema.SObjectType.WorkType.fields.IHPC_Visit_Type_Category__c.isAccessible() ||
            Schema.SObjectType.WorkType.fields.IHPC_Resource__c.isAccessible() ||
            Schema.SObjectType.WorkType.fields.IHPC_Notes__c.isAccessible()
          ) {
            //get all WorkType query
            allWorkTypes = [SELECT Id, Name, IHPC_VisitType__c, IHPC_Visit_Type_Id__c, DurationType,
                                   EstimatedDuration, IHPC_Visit_Type_Category__c, IHPC_Resource__c, IHPC_Notes__c 
                            FROM WorkType];
          }
          displayWorkTypeList(allWorkTypes);
          return allWorkTypes;
    }

    /**
     * Separate mixed WorkType List by 2 categories, 'Start of Care' & 'Routine',
     * SHOULD be used when required parameters been initialized.
     * 
     * @param List<WorkType> allWorkTypeList: An non-empty list containing mixed WorkType objects.
     * @param List<WorkType> startOfCareList: An initially empty list intended to be populated during processing.
     * @param List<WorkType> routineList: An initially empty list intended to be populated during processing.
     * @see 'getAllWorkType' & 'separateVisitTypeObjByCategory' for more nested methods details.
     * @since 26-Feb-2024
     * @author Ariel Zhang
     * @version Dev 1.1
     */
    private static void separateVisitTypeObjByCategory(List<WorkType> allWorkTypeList, List<WorkType> startOfCareList, List<WorkType> routineList)
    {
        //iterate through each objects in the List and add to the list according to its Category (IHPC_Visit_Type_Category__c)
        for(WorkType obj : allWorkTypeList) {
            if(obj.IHPC_Visit_Type_Category__c == 'Start of care') {
                startOfCareList.add(obj);
            }
            else if(obj.IHPC_Visit_Type_Category__c == 'Routine') {
                routineList.add(obj);
            }
        }
    }
    

    /**
     * Test method to print out desired fields from workType objects. 
     * 
     * @param List<WorkType> workTypeList: A list of WorkType Objects needs to be inspected
     * @since 26-Feb-2024
     * @author Ariel Zhang
     */
    private static void displayWorkTypeList(List<WorkType> workTypeList) {
        for(WorkType obj : workTypeList) {
            System.debug('[id]: ' + obj.Id
                      + ' [Name]: ' + obj.Name
                      + ' [Visit Type]: ' + obj.IHPC_VisitType__c
                      + ' [Visit Type Id]: ' + obj.IHPC_Visit_Type_Id__c
                      + ' [Duration Type]: ' + obj.DurationType
                      + ' [Estimated Duration]: ' + obj.EstimatedDuration
                      + ' [Visit Type Category]: ' + obj.IHPC_Visit_Type_Category__c
                      + ' [Resource]: ' + obj.IHPC_Resource__c
                      + ' [Notes]: ' + obj.IHPC_Notes__c);
        }
    }
}