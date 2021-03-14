import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import getSalesInfo from '@salesforce/apex/LSSalesPanelCtrl.getData';
import convertLeadRequest from '@salesforce/apex/LSSalesPanelCtrl.convertLeads';
import cloneRecordsRequest from '@salesforce/apex/LSSalesPanelCtrl.cloneRecords';
import deleteRecordsRequest from '@salesforce/apex/LSSalesPanelCtrl.deleteRecords';

const columns = [
    { label: 'Business Name', fieldName: 'businessName', sortable: "true" },
    { label: 'Type', fieldName: 'type', sortable: "true" },
    { label: 'Status', fieldName: 'status', sortable: "true" },
    { label: 'Due Date', fieldName: 'dueDate', type: 'date', sortable: "true" },
];

const neutralConvert = 'Convert to (Opportunity|Sale)';
const leadConvert = 'Convert to Opportunity';
const oppConvert = 'Convert to Sale';
const leadType = 'Lead';
const oppType = 'Opportunity';

export default class LSSalesPanel extends NavigationMixin(LightningElement) {
    @track inputData;
    @track originalData = [];
    @track data = [];
    @track error;
    @track columns = columns;
    @track sortBy;
    @track sortDirection;
    @track searchKey = '';
    @track convertTo = neutralConvert;
    @track openNew = false;
    @track newRecordType = '';
    @track convertDisable = true;
    @track buttonDisable = true;

    get newRecordTypes() {
        return [
            { label: leadType, value: leadType },
            { label: oppType, value: oppType },
        ];
    }

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
            this.dispatchEvent(newError);
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
        var leadOppSet = new Set();
        var selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
        var convertButton = this.template.querySelector('[data-my-id="convertButton"]');

        if (Array.isArray(selectedRecords)) {
            if (selectedRecords.length > 0) {
                this.convertDisable = false;
                this.buttonDisable = false;
            } else {
                this.convertDisable = true;
                this.buttonDisable = true;
            }
        } else {
            this.convertDisable = true;
            this.buttonDisable = true;
        }

        var oppSelectedRecords = [];
        convertButton.textContent = neutralConvert;
        for (let value in selectedRecords) {
            leadOppSet.add(selectedRecords[value].type);
            if (selectedRecords[value].type === oppType) {
                oppSelectedRecords.push(selectedRecords[value]);
            }
        }
        if (leadOppSet.size > 1) {
            convertButton.textContent = neutralConvert;
        } else {
            if (leadOppSet.has(leadType)) {
                convertButton.textContent = leadConvert;
            } else if (leadOppSet.has(oppType)) {
                convertButton.textContent = oppConvert;
            }
        }
        if (oppSelectedRecords.length > 1) {
            this.convertDisable = true;
        }
    }

    convertRecord(event) {
        var leadIds = new Set();
        var oppIds = new Set();
        var selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
        for (let value in selectedRecords) {
            if (selectedRecords[value].type === leadType) {
                leadIds.add(selectedRecords[value].id);
            }
            if (selectedRecords[value].type === oppType) {
                oppIds.add(selectedRecords[value].id);
            }
        }
        if (leadIds.size > 0) {
            convertLeadRequest({ LeadIds: JSON.stringify([...leadIds]) })
                .then(result => {
                    var requestResponse = JSON.parse(result);
                    console.log('converButton: requestResponse', requestResponse);
                    const success = new ShowToastEvent({
                        "title": "Success!",
                        "message": "Leads converted successfully",
                        "variant": "success",
                    });
                    this.dispatchEvent(success);
                    refreshApex(this.inputData);
                })
                .catch(error => {
                    console.log('error', error);
                    const newError = new ShowToastEvent({
                        "title": "Error",
                        "message": error.body.message,
                        "variant": "error",
                    });
                    this.dispatchEvent(newError);
                });
        }
        if (oppIds.size > 0) {
            const newInfo = new ShowToastEvent({
                "title": "Info",
                "message": "Convert to Sale function has not been defined.",
                "variant": "info",
            });
            this.dispatchEvent(newInfo);
        }
        console.log('convert clicked');
    }

    newRecord(event) {
        console.log('new clicked');
        this.openNew = true;
    }

    cloneRecord(event) {
        var recordIds = new Set();
        var selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
        for (let value in selectedRecords) {
            recordIds.add(selectedRecords[value].id);
        }
        if (recordIds.size > 0) {
            cloneRecordsRequest({ RecordIds: JSON.stringify([...recordIds]) })
                .then(result => {
                    var requestResponse = JSON.parse(result);
                    console.log('cloneButton: requestResponse', requestResponse);
                    const success = new ShowToastEvent({
                        "title": "Success!",
                        "message": "Records cloned successfully",
                        "variant": "success",
                    });
                    this.dispatchEvent(success);
                    refreshApex(this.inputData);
                })
                .catch(error => {
                    console.log('error', error);
                    const newError = new ShowToastEvent({
                        "title": "Error",
                        "message": error.body.message,
                        "variant": "error",
                    });
                    this.dispatchEvent(newError);
                });
        }
        console.log('clone clicked');
    }

    deleteRecord(event) {
        var recordIds = new Set();
        var selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
        for (let value in selectedRecords) {
            recordIds.add(selectedRecords[value].id);
        }
        if (recordIds.size > 0) {
            deleteRecordsRequest({ RecordIds: JSON.stringify([...recordIds]) })
                .then(result => {
                    var requestResponse = JSON.parse(result);
                    console.log('deleteButton: requestResponse', requestResponse);
                    const success = new ShowToastEvent({
                        "title": "Success!",
                        "message": "Records deleted successfully",
                        "variant": "success",
                    });
                    this.dispatchEvent(success);
                    refreshApex(this.inputData);
                })
                .catch(error => {
                    console.log('error', error);
                    const newError = new ShowToastEvent({
                        "title": "Error",
                        "message": error.body.message,
                        "variant": "error",
                    });
                    this.dispatchEvent(newError);
                });
        }
        console.log('delete clicked');
    }

    closeNewRecord() {
        this.openNew = false;
    }

    chooseType(event) {
        this.newRecordType = event.target.value;
    }

    continueNewRecord(event) {
        if (this.newRecordType !== '') {
            event.preventDefault();
            event.stopPropagation();
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: this.newRecordType,
                    actionName: 'new'
                }
            });
            this.newRecordType = '';
            this.closeNewRecord();
        } else {
            const newError = new ShowToastEvent({
                "title": "Error",
                "message": "Please choose one of the object type.",
                "variant": "error",
            });
            this.dispatchEvent(newError);
        }
    }
}