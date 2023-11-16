public with sharing class QuickFixUtility {

    @AuraEnabled(cacheable=true)
    public static list<ProcessCheckReportLine> processCheckReport(){
        try {

            list<ProcessCheckReportLine> report = new list<ProcessCheckReportLine>();


            for(prodigy1__ProductProcess__c process:[SELECT id, name,
                                                        (SELECT id, name, 
                                                            prodigy1__CascadeAuthorization__c,
                                                            prodigy1__GatedStageTemplate__c
                                                            FROM prodigy1__ProductProcessStageTemplates__r)
                                                    FROM prodigy1__ProductProcess__c WITH SECURITY_ENFORCED LIMIT 100]){

                ProcessCheckReportLine line = new ProcessCheckReportLine(process.name);
                
                for(prodigy1__ProductProcessStageTemplateItem__c stage:process.prodigy1__ProductProcessStageTemplates__r){
                    if(stage.prodigy1__CascadeAuthorization__c==false){
                        line.allStagesCascade = false;
                        line.warnings.add('Stage: '+stage.name+' does not have cascade authorization set.');
                    }

                    for(prodigy1__ProdigyStageTaskItem__c taskTemplate:[SELECT id, name, prodigy1__Repeatable__c 
                                                                            FROM prodigy1__ProdigyStageTaskItem__c
                                                                            WHERE prodigy1__GatedStageTemplate__c=:stage.prodigy1__GatedStageTemplate__c
                                                                            AND prodigy1__Repeatable__c!=NULL
                                                                            WITH SECURITY_ENFORCED LIMIT 100]){
                        line.warnings.add('Task: '+taskTemplate.name+' is repeatable (LOCK UP FEATURE!).');                   
                    }
                }
         
                report.add(line);
            }

            return report;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class ProcessCheckReportLine{
        public string processName;
        public boolean allStagesCascade;
        public boolean noRepeatingTasks;
        public list<string> warnings;

        ProcessCheckReportLine(string processName){
            this.processName = processName;
            this.allStagesCascade = true;
            this.noRepeatingTasks = true;
            this.warnings = new list<string>();
        }

    }
}