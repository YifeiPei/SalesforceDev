import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSalesInfo from '@salesforce/apex/LSSalesPanelCtrl.getData';

const columns = [
    { label: 'Business Name', fieldName: 'businessName' },
    { label: 'Type', fieldName: 'type' },
    { label: 'Status', fieldName: 'status' },
    { label: 'Due Date', fieldName: 'dueDate', type: 'date' },
];

export default class LSSalesPanel extends LightningElement {
    @track inputData;
    @track data = [];
    @track error;
    @track columns = columns;

    @wire(getSalesInfo)
    wiredResponse(result) {
        this.inputData = result;
        const { data, error } = result;
        if (data) {
            this.data = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
        console.log('data', this.data);
        console.log('error', this.error);
    }
}