import { LightningElement, api } from 'lwc';

export default class EditarConta extends LightningElement {
    @api recordId;
    @api objectApiName = 'Account';

    handleSubmit(evt) {
        console.log('EVT: ' + JSON.stringify(evt.detail.fields));
    }
}