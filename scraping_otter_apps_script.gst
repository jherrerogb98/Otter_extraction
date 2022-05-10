function scrape_data() {  

  function sacar_local(store_id){
		var store_codes={
		"09035365-81a9-414f-8da7-f2b806bc7f26":"Leganes",
    "ac32f6dd-2da9-4ebf-aca4-59f746f3df26": "Leganes",
		"e5bea962-c9d7-4be6-8cdd-2056f2be66ff":"Vallecas",
		"0788ea25-169c-48ca-bb4a-b575fe9ab437":"Getafe",
		"30b7b9c6-3db5-4297-a2db-20251e24afe2":"Pozuelo",
		"1f690a9f-eb14-4cad-a5e5-0d13d3cca36e":"Ciudad Lineal",
		"3c208c26-062c-4fc4-b921-5dc9075679fa":"Ciudad Lineal",
		"429a4ac6-bde7-45bb-877a-78c64d48fa63":"Carabanchel",
    "e5bea962-c9d7-4be6-8cdd-2056f2be66ff": "Carabanchel",
    "f12b5827-6cee-479f-a100-fd862f773b0b": "Carabanchel",
		"5c3cf784-545d-4bf9-9d80-5e824d379b8c":"Mostoles",
		"bcd06a50-fb7c-4dff-80c6-4bfaae2e5520":"Chamartin",
		"db2907f0-14f4-4840-a76f-60b324812f7e":"Alcorcon",
    "3f40a42b-949d-4ff1-9178-3e529ba52125": "Alcorcón",
		"e3a26675-f45d-4703-8336-5be6cf9fde2f":"Hortaleza",
    "f8747364-69f5-4227-a6df-8ab7f3798dd2": "Hortaleza",
		"331779a1-08cc-4e31-bcc3-1772c3084f9f":"Alcobendas",
		"8ac15727-55cb-4cd9-ac3e-484577df33be":"Alcobendas",
		"ef329756-a6d1-4239-b209-c744154949ab":"Coslada",
		"fce52216-566a-41cd-9d00-09ce241ab425":"Coslada",
		"e2597d84-5491-48bf-9367-8e2a56651d57":"Mirasierra",
    "038456c1-0e9c-47e0-bc77-1c75db66e6d5": "Mirasierra",
		"f8747364-69f5-4227-a6df-8ab7f3798dd2":"Hortaleza",
    "60e69c25-4871-435d-898b-b18f2c970e32": "Centro",
    "a6a54ee3-5a27-49c3-ab2d-02390a80f21c": "Centro",
    "f5d59862-f659-4b29-ae50-ec373afa08d7": "Retiro",
    "82351d26-e704-48bd-b141-d2dfee057039": "Retiro",
    "41aaaaf1-49ad-47d0-9d29-75fcf7a681d1": "Chamberí",
    "aa21c1a4-0864-4c34-9047-92774ccb43a1": "Chamberí",
    "6e826f1f-351f-4eee-8d7a-68d262762d6a": "Pilar",
    "7a5eeb79-ef70-4996-871d-0b1e06763764": "Pilar",
    "20e0f58a-b7b1-40cb-92cd-87cb4a6ecd4f": "Torrejón",
    "a5f5eef2-34fa-47e7-ad2c-934cd7d9a74d": "Torrejón"

		}
    return store_codes[store_id]
  }
    
  function status(ofostatus){
		if (ofostatus=="OFO_STATUS_CANCELED"){
			return "canceled"
      }
		return ""
    }

  function date(i){return data.orders[i].createdAt.split('T')[0]}  
  function hour(i){return data.orders[i].createdAt.split('T')[1].slice(0,-1)}

  function price(i){
    try{
    return data.orders[i].customerOrder.restaurantOrderTotals.total.amount.units+","+data.orders[i].customerOrder.restaurantOrderTotals.total.amount.nanos
} catch(ignore){}
  }


var myHeaders1 = {"authority": "api.tryotter.com",
"content-type": "application/json"}

var raw = {
  "email": "*ENTER YOUR EMAIL*",
  "password": "*ENTER YOUR PASSWORD*!"
};

var requestOptions1 = {
  method: 'POST',
  headers: myHeaders1,
  payload: JSON.stringify(raw),
  redirect: 'follow',
  muteHttpExceptions:true
};

var response1 = UrlFetchApp.fetch("https://api.tryotter.com/users/sign_in", requestOptions1);
data2=response1.getContentText()
var data1=JSON.parse(response1)
var access_token=data1.accessToken
var myHeaders = {"authority":"api.tryotter.com",
"authorization":"Bearer"+" "+access_token
}

var requestOptions = {
  method: 'GET',
  headers: myHeaders,
  redirect: 'follow'
};
offset=''
var response = UrlFetchApp.fetch("https://api.tryotter.com/ufo/otter_order_history?limit=20&facility_id=2219e341-8b55-45a5-9f54-1bd2264b7324&offset="+offset, requestOptions);

var data = JSON.parse(response);
var ss=SpreadsheetApp.openById('*ENTER YOUR GSHEET DATABASE*');
var sheet=ss.getSheetByName('BBDD'); //sheet 1
var sheet2=ss.getSheetByName('temp'); //sheet 2
var orders_cond=true;
var last_order_id=sheet.getRange('a2').getValue()
while (orders_cond==true){
  for (var i=0;i< data.orders.length;i++){
    var orders_id=data.orders[i].customerOrder.orderId.id

        var orders=[orders_id,
        data.orders[i].customerOrder.externalOrderId.displayId,
        data.orders[i].customerOrder.ofoSlug,
        date(i),
        hour(i),
        sacar_local(data.orders[i].customerOrder.storeId.id),
        price(i),
        data.orders[i].customerOrder.customer.displayName,
        data.orders[i].customerOrder.customer.phone,
        data.orders[i].customerOrder.customer.email,
        data.orders[i].customerOrder.ofostatus,
        data.offsetToken,
        data.orders[i].customerOrder.customerNote.replace("\n","")]
          
        sheet2.appendRow(orders);
        if(orders_id==last_order_id){
          orders_cond = false
        }
        var unf_offset=data.offsetToken;
        var offset=unf_offset.replace("=","%3D");
        var offset=offset.replace("+","%2B").replace("/","%2F");
        
  }


      var response = UrlFetchApp.fetch("https://api.tryotter.com/ufo/otter_order_history?limit=20&facility_id=2219e341-8b55-45a5-9f54-1bd2264b7324&offset="+offset, requestOptions)    
      var data = JSON.parse(response)
      }

sheet2.getDataRange()
var targetRow = 2;
var n_rows=sheet2.getLastRow();
var n_columns=sheet2.getLastColumn();
var target=sheet.insertRowsBefore(targetRow,n_rows).getRange(targetRow, 1);
sheet.getRange(2,1,n_rows,n_columns).setValues(sheet2.getDataRange().getValues());
sheet.getDataRange().removeDuplicates([1])
sheet2.clear()


}

function onOpen() {
  SpreadsheetApp.getUi() // Or DocumentApp or SlidesApp or FormApp.
      .createMenu('Menu options')
      .addItem('Refresh', 'scrape_data')
      .addToUi();
}
