public class ValidationHelper{
  
  static String savedMessage='Saved successfully.';
  static String uniqueMessage='Record with same Staff ID already exists. Please enter unique value for Staff ID.';
  static String emailMessage='Staff ID must be in the form of an email address (for example, john@acme.com)';
  static String textAreaOverflowMessage = 'Only 32,000 characters are allowed.';
    public static String getSavedMessage(){
      return savedMessage;
    }
    
    public static String getMessageString(ApexPages.Message[] messages){
        String mesageString = '';
        for(ApexPages.Message message : messages){
            if(message.getSummary().contains('data value too large')){
                String[] msgs = message.getSummary().split(':');
                mesageString += msgs[0] + ' : '+textAreaOverflowMessage +'<BR>';
            }else{
                mesageString += message.getSummary()+'<BR>';
            }
        }
        if(mesageString.contains('Duplicate Username')){
            mesageString =  uniqueMessage;
            }
        else if(mesageString.contains('Username must')){
            mesageString =  emailMessage;  
        }
        return mesageString;
    }
    
    public static String getMessageFromError(String errorMessage){
        String message = '';
        if(errorMessage!= null && errorMessage!= '' &&  errorMessage.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
            Integer iStart = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION') + 35;
            Integer iEnd = errorMessage.lastIndexOf(': [');
            message = errorMessage.subString(iStart, iEnd);
        }else if(errorMessage!= null && errorMessage!= ''){
            message = errorMessage;
        }
        
        return message;
    
    }
}
			                            	