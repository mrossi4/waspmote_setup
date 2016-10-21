/*  This example was provided by Jeremy Johnston.
 *  ------ Data Sending Example -------- 
 *  
 *  Explanation: This is the basic Code for Waspmote Pro
 *  
 *  Copyright (C) 2013 Libelium Comunicaciones Distribuidas S.L. 
 *  http://www.libelium.com 
 *  
 *  This program is free software: you can redistribute it and/or modify  
 *  it under the terms of the GNU General Public License as published by  
 *  the Free Software Foundation, either version 3 of the License, or  
 *  (at your option) any later version.  
 *   
 *  This program is distributed in the hope that it will be useful,  
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of  
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  
 *  GNU General Public License for more details.  
 *   
 *  You should have received a copy of the GNU General Public License  
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.  
 */
     
// Put your libraries here (#include ...)    
#include <WaspXBeeDM.h>
#include <WaspFrameConstants.h>
#include <WaspFrame.h>

//Destination MAC Addresses or broadcast mode(more packet loss)
char RX_ADDRESS_MESHLIUM[] = "0013A20041253B09";
char RX_BROADCAST[] = "000000000000FFFF";
char OWN_MAC_ADDRESS[] = "xxxxxxxxxxxxxxxx"; // can be found on radio module

//Define Waspmote ID of this node put in frame if no other identifier is used
char WASPMOTE_ID[] = "node_03";

//Define network address of the XBee Module
char OWN_NETADDRESS[] = "1213";

//Personal Area Network ID
uint8_t panID[2] = {0x12,0x34};

//define frequency channel
//Digimesh 2.4Ghz: range 0x0B t0 0x1A
//Digimesh 900Mhz: range 0x00 to 0x0B
uint8_t channel = 0x0F;

//mode: 1 (enabled) 0 (disabled)
uint8_t encryptionMode = 0;

//16-byte encryption key
char encryptionKey[] = "WaspmoteLinkKey!";

float anemometer_val;
char* vane_direction;
float plv_val;
float radiation;


void setup() {
    // put your setup code here, to run once:
    //turn on board, RTC(internal clock) and radio, SD card as well for 
    //data backup on waspmote, USB for printing while testing code
    
  USB.ON();
  USB.OFF();
  
  SD.ON();
  SD.OFF();
  
  RTC.ON();
  RTC.OFF();
  
  //for agriculture board example
  SensorAgrv20.ON();
  
  xbeeDM.ON();
  xbeeDM.setOwnNetAddress(OWN_NETADDRESS);//set individual XBee's Network Address
  //val from 0-7, defines how many times network retries packet sends
  //to ensure delivery-  has random delays included
  xbeeDM.setMeshNetworkRetries(0x01); 
  xbeeDM.setChannel( channel );
  xbeeDM.setPAN( panID );
  xbeeDM.setEncryptionMode( encryptionMode );
  xbeeDM.setLinkKey( encryptionKey );
  xbeeDM.writeValues();
  
  

}


void loop() {
  
    //read sensors here (actual sensor reading methods can be found in guides for 
    // the specific sensor board you are using
    
    anemometer_val = 10.0;
    vane_direction = "N";
    plv_val = 24.43;
    radiation = 245.0;
    
    // put your main code here, to run repeatedly:
    frame.createFrame(ASCII, "123"); //frame name is Waspmote ID by default changed to 123 as ex.
    frame.addSensor(SENSOR_ANE, anemometer_val);
    frame.addSensor(SENSOR_WV, vane_direction);
    frame.addSensor(SENSOR_PLV, plv_val);
    frame.addSensor(SENSOR_UV, radiation); 
     
    xbeeDM.send(RX_ADDRESS_GATEWAY, frame.buffer, frame.length);
    
    //set delay(xxxx) in ms or sleep mode (guides on site) here
    delay(60000); //one minute delay

}

