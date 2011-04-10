package com.phonegap.BluetoothPlugin;

import java.util.List;

import org.json.*;

import android.os.Handler;
import android.os.Message;
import android.util.Log;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;
import com.phonegap.model.Device;


public class BTDeviceManager extends Plugin {
	
	private static final String TAG = "BluetoothChat";
	
	private GetDiscoverableDevices gdd; 
	
	private final Handler mHandler = new Handler() {
	    public void handleMessage(Message msg) {
	    	Log.e(TAG, "Handling a message");
	        switch (msg.what) {
	            case GetDiscoverableDevices.DONE_GATHERING_DEVICES:
	            Log.e(TAG, "Done looking for bound devices");
	            break;
	            case GetDiscoverableDevices.DONE_LOOKING_FOR_DEVICES:
	            if (GetDiscoverableDevices.devices != null) {
	            	Log.e(TAG, "We've received " + GetDiscoverableDevices.devices.size() + " devices.");
	            	for(Device d: GetDiscoverableDevices.devices) {
	            		String name = d.getName();
	        			name = name.replace("\'", "\\\'");
	            		sendJavascript("foundDevice('"+name+"','"+d.getMac()+"')");
	            	}
	            }
	            
	            Log.e(TAG, "Done discovering devices");
	        }
	    }
	};
	
	/**
	 * Executes the request and returns PluginResult.
	 * 
	 * @param action 		The action to execute.
	 * @param args 			JSONArry of arguments for the plugin.
	 * @param callbackId	The callback id used when calling back into JavaScript.
	 * @return 				A PluginResult object with a status and message.
	 */
	public PluginResult execute(String action, JSONArray args, String callbackId) {
		if (action.equals("getDevices")) {
			
			gdd = new GetDiscoverableDevices();
			gdd.mHandler = this.mHandler;
			gdd.execute(BTDeviceManager.this);

			return new PluginResult(PluginResult.Status.OK, "HELLO FROM NATIVE CODES!");
		} 
		else {
			return new PluginResult(PluginResult.Status.INVALID_ACTION);
		}
	}
	
}

