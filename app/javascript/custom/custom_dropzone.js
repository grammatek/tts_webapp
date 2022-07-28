import { Dropzone } from "dropzone";

/*
Since the application should be ready for a new document after each upload, we need to control
when dropzone clears the input field and when the submit button is enabled/disabled.
Here, we add a listener to the submit button that includes a timeout, i.e. we want to ensure the default
submit action is performed before Dropzone clears the field, causing the input file to be removed.
The automatic enabling of the submit button is done in the start() function of the DirectUploadController,
see controllers/dropzone_controller.js, each time a "success" is registered for a file upload, the submit button
gets enabled.
 */

const dropForm = document.getElementById("dropzone_form");
const submitButton = document.getElementById('submit');
// on load there are no files in the dropzone field, hence start with a disabled submit button
submitButton.disabled = true;

dropForm.addEventListener('submit', (e)=>{
    // The following checks after the timeout if files were already uploaded, if yes, clears the field and
    // disables submit button, otherwise does nothing, leaving the "remove file" to the user.
    setTimeout(()=>{
        //console.log('accepted files: ' + Dropzone.forElement('#filedrop').getAcceptedFiles().length);
        if (Dropzone.forElement('#filedrop').getAcceptedFiles().length > 0) {
            Dropzone.forElement('#filedrop').removeAllFiles();
            $('.dz-preview').empty();
            $('.dz-message').show();
            submitButton.disabled = true;
        }
    },1000)
})




