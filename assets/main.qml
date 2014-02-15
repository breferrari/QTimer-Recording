/*
 * Copyright (c) 2011-2013 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.2
import bb.multimedia 1.0
import bb.data 1.0

Page {
    Menu.definition: MenuDefinition {
        settingsAction: SettingsActionItem {
            onTriggered: {
                controller.saveJson(atendeesModel2)
            }
        }
    }
    actions: [
        ActionItem {
            title: "Add Atendee"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                atendeesModel2.append({"nome": "Fulano", "idade": 35})
            }
        }
    ]
    Container {
        id: root
        
        function resetTimer () {
            timer.hh = 0;
            timer.mm = 0;
            timer.ss = 0;
        }
        
        property int iconTime: 0;
        
        layout: DockLayout {
        }
        
        ImageView { /*Background*/
            id: background
            imageSource: "asset:///images/background.jpg"
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
        }
        
        Label { /*Version*/
            text: qsTr("Chrono v5")
            horizontalAlignment: HorizontalAlignment.Right
            textFit.maxFontSizeValue: 5.0
        }
        
        Container {
            layout: StackLayout {
            
            }
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            
            Label { /*Time*/
                id: timer
                property int hh: 0
                property int mm: 0
                property int ss: 0
                
                text: qsTr("%1:%2:%3").arg(hh < 10 ? "0" + hh : "" + hh)
                                      .arg(mm < 10 ? "0" + mm : "" + mm)
                                      .arg(ss < 10 ? "0" + ss : "" + ss)

                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontWeight: FontWeight.Bold
            
            }
            
            attachedObjects: [
                MediaPlayer {
                    id: player
                },
                AudioRecorder {
                    id: recorder
                },
                SystemSound {
                    id: recordStartSound
                    sound: SystemSound.RecordingStartEvent
                },
                SystemSound {
                    id: recordStopSound
                    sound: SystemSound.RecordingStopEvent
                },
                QTimer{
                    id: updateTime
                    interval: 1000
                    onTimeout: {
                        if (record.state == 1) {
                        	timer.ss++;
                        	
                        	if (timer.ss == 60) {
                        	    timer.ss = 0;
                        	    timer.mm++;
                        	}
                        	if (timer.mm == 60) {
                        	    timer.mm = 0;
                        	    timer.hh++;                        	    
                        	}                        	
                        }
                    }
                },
                QTimer{
                    id: iconAnim
                    interval: 800                	
                    onTimeout: {                       
                        root.iconTime++;             
                                                  
                        if(record.state == 1) {
                            if (root.iconTime%2 != 0) {
                                record.imageSource="asset:///images/record-128-fabio.png"
                            }
                            else if (root.iconTime%2 == 0) {
                                record.imageSource="asset:///images/record.png"
                            }
                        }
                        if(record.state == 0) {
                            record.imageSource="asset:///images/record.png"
                        }
                        
                        if(listen.state == 1) {
                            if (root.iconTime%2 != 0) {
                                listen.imageSource="asset:///images/listening.png"
                            }
                            else if (root.iconTime%2 == 0) {
                                listen.imageSource="asset:///images/listen.png"
                            }
                        }
                        if(listen.state == 0) {
                            listen.imageSource="asset:///images/listen.png"
                        }
                    }                    
                }
            ]
            
            ProgressIndicator { /*Timer Bar*/
                id: timex
                horizontalAlignment: HorizontalAlignment.Center
                accessibility.name: "TODO: Add property content"
            }
            
            Container { /*Buttons*/        	
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                horizontalAlignment: HorizontalAlignment.Center
                
                Button {
                    id: record
                    text: "Record"
                    imageSource: "asset:///images/record.png"
                    
                    property int state: 0
                    
                    onClicked: {
                        if (record.state == 1) {
                            record.state = 0;
                            record.text = "Record";

                            listen.enabled = true;
                            btnPessoas.enabled = false;
                            
                            root.resetTimer();
                            
                            recorder.reset();
                            recordStopSound.play();
                        
                        }
                        else {
                            record.state = 1;
                            record.text = "Recording";

                            listen.enabled = false;
                            btnPessoas.enabled = true;
                            
                            recorder.outputUrl = "file:///accounts/1000/shared/voice/audio.m4a"
                            recordStartSound.play()
                            recorder.record();
                        
                        }
                    }
                }
                
                Button {
                    id: listen
                    text: "Listen"
                    imageSource: "asset:///images/listen.png"
                    
                    property int state: 0
                    
                    onClicked: {
                        if (listen.state == 1) {
                            listen.state = 0;
                            listen.text = "Listen";
                            record.enabled = true;
                            
                            root.resetTimer();
                            
                            player.stop();
                        }
                        else {
                            listen.state = 1;
                            listen.text = "Listening";
                            record.enabled = false;
                            
                            player.sourceUrl = "file:///accounts/1000/shared/voice/audio.m4a";
                            player.play();
                        }
                    }
                }
            }
            
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                topMargin: 10.0
                
                Button { /*Pause Recording*/
                    id: pause
                    text: "Pause"
                    imageSource: "asset:///images/pause.png"
                    
                    property int state: 0;
                    property string pausebtn: "";
                                        
                    onClicked: {
                        if (pause.state == 0){
                        	pause.state = 1;
                            if (record.state == 1){
                                record.state = 0;
                                pause.pausebtn = record.text;
                                record.enabled = false;
                                recorder.pause();
                                
                                pause.text = "Paused"    
                            }
                            
                            if (listen.state == 1){
                                listen.state = 0;
                                pause.pausebtn = listen.text;
                                listen.enabled = false;
                                player.pause();
                                
                                pause.text = "Paused"
                            }
                        }
                        else {
                            pause.state = 0;
                            if (record.text == pause.pausebtn){
                        		record.state = 1;
                                pause.pausebtn = "";
                                record.enabled = true;
                        		recorder.record();
                        		
                        		pause.text = "Pause"
                        	}
                            if (listen.text == pause.pausebtn){
                                listen.state = 1;
                                pause.pausebtn = "";
                                listen.enabled = true;
                                player.play();
                                
                                pause.text = "Pause"
                            }
                        }
                    }            
                }
            }
         
            Container {
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                topMargin: 50.0
                
                DynQML {
                    dataModel: ArrayDataModel {
                        id:atendeesModel2
                    }
                }
                attachedObjects: [
                    DataSource {
                        id: backup
                        source: "test.json"
                        onDataLoaded: {
                            atendeesModel2.append(data)
                        }
                    }
                ]
            }        
        }
    }
        
    onCreationCompleted: { /*Loop*/
        updateTime.start();
        iconAnim.start();
        backup.load();
    }

}