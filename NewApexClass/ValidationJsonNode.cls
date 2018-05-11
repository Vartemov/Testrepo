public class ValidationJsonNode{
          
     public String fieldLabel {get; set;}        
     public String validationType {get; set;}        
     public String validationFunction {get; set;}
     public String errorMessage {get; set;}        
     public String fieldId {get; set;} 
     public String fieldLab=' fieldLabel:\'' ;
     public String validationT=' validationType:\'';
     public String validationFn=' validationFunction:\'';
     public String errorMsg=' errorMessage:\'';
     public String fldId=' fieldId:\'';
     public map<String,ValidationJsonNode> childrenMap {get; set;}        
     public integer nodeCount {get; set;}
    
    public ValidationJsonNode(){
        fieldLabel = '';
        validationType = '';
        validationFunction = '';  
        fieldId  = '';
        errorMessage = 'Error Accured';
        childrenMap = new map<String,ValidationJsonNode>();
        nodeCount =0;
    }
    
    public void addChild(ValidationJsonNode childNode){
        nodeCount ++;
        childrenMap.put(nodeCount+'', childNode);
    }
    
    public String toJsonString(){
        return '['+makeJsonString()+']'; 
    }
    
    public String makeJsonString(){
        String jsonStr = ' { ';
        
        jsonStr += fieldLab+fieldLabel +'\',';
        jsonStr += validationT+validationType+'\',';
        jsonStr += validationFn+validationFunction+'\',';        
        jsonStr += errorMsg+errorMessage+'\',';        
        jsonStr += fldId+fieldId+'\'';        
        if(childrenMap != null && childrenMap.size()>0){
            jsonStr += ',';
            jsonStr += ' children : [ ';
            jsonStr += getJsonChildString();
            jsonStr += ' ] ';
        }
        jsonStr += ' } ';
        return jsonStr;
    }
    public String getJsonChildString(){
        String jsonChildStr = '';
            for(integer i=1; i<(nodeCount+1);i++){
                jsonChildStr += childrenMap.get(i+'').makeJsonString();
                if(i != nodeCount) jsonChildStr += ',';
            }
        return jsonChildStr;
    }
    
    public String getJsonChildArrayString(){
        return '[' + getJsonChildString() + ']';
    }
}
			                            	