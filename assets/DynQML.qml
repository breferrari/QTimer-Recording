import bb.cascades 1.2

Container {
    property alias dataModel: atendeesList.dataModel
    ListView {
        id: atendeesList
        dataModel: ArrayDataModel {
            id: atendees
        }
        //        onCreationCompleted: {
        //            //atendees.append([ "Fulano", "Sicrano", "Beltrano" ])
        //        }
        function addSpeaker(speaker) {
            console.log({
                    "speaker": speaker,
                    "timestamp": "test1"
            })
        meeting.append({
                "speaker": speaker,
                "timestamp": "test2"
        })
        }
        onTriggered: {
            //            var item = atendeesList.dataModel.data(indexPath)
            //            item.nome
            //            item.idade
            //            item.altura
        }
        attachedObjects: [
            ArrayDataModel {
                id: meeting
            }
        ]
        listItemComponents: ListItemComponent {
            //            ScrollView {
            //                scrollViewProperties.scrollMode: ScrollMode.Horizontal
            Container {
                id: root 
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                function addSpeaker(speaker) {
                    ListItem.view.addSpeaker(speaker)
                }
                Button {
                    id: bt
                    text: ListItemData.nome
                    onClicked: {
                        root.addSpeaker(text)
                    }
                }
                Slider {
                    id: sl
                    fromValue: 0
                    toValue: 100
                    value: ListItemData.idade
                }
            }
            //            }
        }
    }

}

