/**
  *Class to Read an XML file and convert it to a list of SObjects.
  */
public class XMLDataParser {
  
  /*
    Instance variable to Refer to the Page that Contains the XML data
  */
  Pagereference dataPageRef;
  
  /*
    SObject type name that has to be populated
  */
    public String objectName{get; set;}
  
  XMLDom xDom;
  
  public XMLDataParser(XMLDom xDom){
    
    this.xDom = xDom;
  }
  
  
  public XMLDataParser(PageReference dataPageRef,String objectName){
    
    this.dataPageRef = dataPageRef;
    this.objectName = objectName;
  }
  
  /*
    Method uses the dataPageRef var to refer to the XML file and converts it to 
    an instance of XMLDom class.
  
  */
  private XMLDom readDataFile(){
    Blob dataFileContent ;
    XMLDom xDom;
    dataFileContent=dataPageRef.getContent();
        xDom=new XMLDom(dataFileContent.toString());
        dataFileContent= null;
    return xDom;
  }
  
  /*
    Method reads the XMLDom instance and returns a list of SObjects of type ObjectName.
  
  */
  public List<SObject> populateDataList(){
    
    List<SObject> objectsList = initDataList(objectName);
    if(dataPageRef!=null)
      xDom = readDataFile();
    SObject dataObject = SObjectFactory.getSObject(objectName);
    
    Map<String, Schema.SObjectField> fieldsMap = new Map<String, Schema.SObjectField> ();                
        fieldsMap = dataObject.getSObjectType().getDescribe().fields.getMap();
    
    // traversing through the XML file tag-by-tag and adding to a List
    for(XMLDom.Element rowElement: xdom.root.childnodes[0].childNodes){
             dataObject = SObjectFactory.getSObject(objectName);
             for(XmlDom.Element fieldElement:rowElement.childNodes){
                 
                 // need to use more more efficiently.
                 schema.DescribeFieldResult fieldDesc = fieldsMap.get(fieldElement.nodeName).getDescribe();
          String fieldtype = fieldDesc.getType().name(); 
          
          if(fieldtype == Schema.DisplayType.ID.name()){
            dataObject = SObjectFactory.getSObject(objectName,fieldElement.nodeValue);
          }
          
          // Testing the visibitlity and types before adding to list.
                 if(fieldDesc.isAccessible() && fieldDesc.isUpdateable() && !(fieldDesc.isAutoNumber())){
                   if(fieldtype == Schema.DisplayType.String.name() ||fieldtype == Schema.DisplayType.TextArea.name() ||fieldtype == Schema.DisplayType.Reference.name()){
                     if(fieldElement.nodeValue != null &&  fieldElement.nodeValue != ''){
                       dataObject.put(fieldElement.nodeName, fieldElement.nodeValue);
                     }else{
                       dataObject.put(fieldElement.nodeName, null);
                     }
                     
                   }else if(fieldtype ==  Schema.DisplayType.Boolean.name() ){
                     if(fieldElement.nodeValue == '1'){
                       dataObject.put(fieldElement.nodeName,true);
                     }else{
                       dataObject.put(fieldElement.nodeName,false);
                     }
                     
                   }
                 }
                   
             }
             objectsList.add(dataObject);
        }
    
    return objectsList;
  } 
  
  /*
    Method to return a List<typeName>.
  */
  List<SObject> initDataList(String typeName){
    
    Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    
    Schema.SObjectType sObjectTypeToken = schemaMap.get(typeName);
    SObject sObjectInstance = sObjectTypeToken.newSObject();
    
    DriverAccess objDriverAccess = new DriverAccess();
    
    // Need to add Condition to Limit the number of Records fetched.
    ConditionBuilder objConditionBuilder = new ConditionBuilder();
    
    List<SObject> dataList = objDriverAccess.selectObjects(sObjectInstance,null,null,null);
    
    dataList.add(sObjectInstance);
    dataList.clear();
    return dataList;
  }
}
			                            	