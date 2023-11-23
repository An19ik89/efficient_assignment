# efficient_assignmentLogin :
Use esssumon@gmail.com and admin as user and password. Otherwise invalid login.
Home page :
By pressing custom order nagivate to the order form page. And by pressing feedback navigate to the feedback page.
  
Order form page :
The order form’s field will be dynamically populated from the API.
API ref => https://formcreate.free.beeceptor.com/form (if API response not working use the respose.json provided)
Here: ‘formName’ is the title of the order collection form
There can be multiple sections in this form and each section will contain multiple fields.
For each field view is different. Feel free to use any UI widget for that.
There is different type of field(check type property in the response json). And the validations for that specific fields are also listed there.
In the response there is another property that is valueMapping. Value mapping will consist of a list, and in this list there is list of object consist of search list, and display list.
The field provided in the searchList should be used to find the matched result from the csv provided. Consider taking the value of the field.
If the provided value in the searchList matches with any field in the csv take necessary values of fields from the csv and populate accordingly using the displayList.
Feedback page :
There will be one textfield, 1 photo picker field, and show the photo to the left after picking, and a voice record field. If the record pressed it will start recording and there will be a stop icon. If stop pressed this field will show the recorded filename there and can be played.
Invoice page:
Invoice page should list all the label with the filled or picked field value side by side. And if user hit save it will save the invoice to phone’s storage. And send an email to the customer.
Important to look at : If user started to fill any field then want to go the previous page, then show a warning to the user saying “Do you really want to lose the changes ??”
Optional :
Can you share the invoice with any nearby user using NFC?
