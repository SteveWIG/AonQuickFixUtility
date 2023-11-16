public with sharing class QuickFixUtility {

    @AuraEnabled(cachable=true)
    public static string processCheckReport(){
        try {

            public list<ProcessCheckReportLine> report = new list<ProcessCheckReportLine>();

            for(prodigy1__ProductProcess__c process:[SELECT id, name,
                                                    (SELECT id, name, prodigy1__CascadeAuthorization__c
                                                        FROM prodigy1__ProductProcessStageTemplates__r)
                                                     FROM prodigy1__ProductProcess__c WITH SECURITY_ENFORCED]){

                ProcessCheckReportLine line = new ProcessCheckReportLine(process.name);

                for(prodigy1__ProductProcessStageTemplateItem__c stage:process.prodigy1__ProductProcessStageTemplates__r){
                    if(stage.prodigy1__CascadeAuthorization__c==false){
                        line.allStagesCascade = false;
                        line.warnings.add('Stage: '+stage.name+' does not have cascade authorization set.');
                    }
                }
                
            }

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