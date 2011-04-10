/**
 * Facilitates the call into the Bluetooth plugin's BTDeviceManager.
 * 
 * @param win - success callback
 * @param fail - error callback
 */
var getDevices = function(win, fail) {
	if (window['BTDeviceManager'] == undefined)
		PluginManager.addService("BTDeviceManager","com.phonegap.BluetoothPlugin.BTDeviceManager");
	PhoneGap.exec(win, fail, "BTDeviceManager", "getDevices", []);
};


/**
 * Displays the list of found devices in the user interface.
 * @param number - device list (JSON)
 */
function updateDeviceList(json) {
    console.log("ADFADASD");
	devices = $.parseJSON(json);
	for (var d in devices) {
	    $("#devices").append(d + "=>");
		$("#devices").append(devices[d]);
		$("#devices").append("<br/>");
	}
	$("#get-discoverable-devices").text('Find some devices!');
	$("#get-discoverable-devices").bind('click', getDevicesEvent);
}

/**
 * Event fired when user clicks the Get some devices link.
 */
function getDevicesEvent() {
	getDevices(
			function(r){
				// The call has been successfully made.
				$("#get-discoverable-devices").text('Gathering devices...');
			},
			function(e){alert(e)}
	);
}