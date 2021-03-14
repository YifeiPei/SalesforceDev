import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getSalesInfo from '@salesforce/apex/LSSalesPanelCtrl.getData';

const columns = [
    { label: 'Business Name', fieldName: 'businessName', sortable: "true" },
    { label: 'Type', fieldName: 'type', sortable: "true" },
    { label: 'Status', fieldName: 'status', sortable: "true" },
    { label: 'Due Date', fieldName: 'dueDate', type: 'date', sortable: "true" },
];

const neutralConvert = 'Convert to (Opportunity|Sale)';
const leadConvert = 'Convert to Opportunity';
const oppConvert = 'Convert to Sale';

export default class LSSalesPanel extends LightningElement {
    @track inputData;
    @track originalData = [];
    @track data = [];
    @track error;
    @track columns = columns;
    @track sortBy;
    @track sortDirection;
    @track searchKey = '';
    @track convertTo = neutralConvert;

    @wire(getSalesInfo)
    wiredResponse(result) {
        this.inputData = result;
        const { data, error } = result;
        if (data) {
            this.originalData = data;
            this.data = JSON.parse(JSON.stringify(this.originalData));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.originalData = undefined;
            this.data = undefined;
            const newError = new ShowToastEvent({
                "title": "Error",
                "message": error.body.message,
                "variant": "error",
            });
        }
        console.log('originalData', this.originalData);
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

    updateSearch(event) {
        this.searchKey = event.target.value;
        console.log('searchKey', this.searchKey);
        var searchData = [];
        if (this.searchKey === '') {
            this.data = JSON.parse(JSON.stringify(this.originalData));
            searchData = [];
        } else {
            this.data = JSON.parse(JSON.stringify(this.originalData));
            searchData = [];
            try {
                for (let value in this.data) {
                    let businessName = this.data[value].businessName.toLowerCase();
                    let searchValue = this.searchKey.toLowerCase();
                    if (businessName.includes(searchValue)) {
                        searchData.push(this.data[value]);
                    }
                }
                console.log('searchData', searchData);
                this.data = searchData;
            } catch (err) {
                console.log('err', err);
            }
        }
    }

    rowSelect(event) {
        var selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
        console.log('selectedRecords', selectedRecords[0].type);
    }

    convertRecord(event) {
        console.log('convert clicked');
    }
}