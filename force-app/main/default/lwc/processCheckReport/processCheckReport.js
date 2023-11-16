import { LightningElement } from 'lwc';
import processCheckReport from '@salesforce/apex/QuickFixUtility.processCheckReport';

export default class ProcessCheckReport extends LightningElement {

    processCheckReport;
    error;

    connectedCallback(){
        processCheckReport()
        .then((result) => {
            console.log(result);
          this.processCheckReport = result;
        })
        .catch((error) => {
          this.error = error;
        });
    }

}