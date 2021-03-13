import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSalesInfo from '@salesforce/apex/LSSalesPanelCtrl.getData';

const columns = [
    { label: 'Business Name', fieldName: 'businessName', sortable: "true" },
    { label: 'Type', fieldName: 'type', sortable: "true" },
    { label: 'Status', fieldName: 'status', sortable: "true" },
    { label: 'Due Date', fieldName: 'dueDate', type: 'date', sortable: "true" },
];

export default class LSSalesPanel extends LightningElement {
    @track inputData;
    @track data = [];
    @track error;
    @track columns = columns;
    @track sortBy;
    @track sortDirection;

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

    handleSortdata(event) {
        // field name
        this.sortBy = event.detail.fieldName;
        // sort direction
        this.sortDirection = event.detail.sortDirection;
        // calling sortdata function to sort the data based on direction and selected field
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }

    sortData(fieldname, direction) {
        // serialize the data before calling sort function
        let parseData = JSON.parse(JSON.stringify(this.data));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction 
        let isReverse = direction === 'asc' ? 1 : -1;
        // sorting data 
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        // set the sorted data to data table data
        this.data = parseData;
    }
}