//
//  ContentView.swift
//  ChordFolder
//
//  Created by Dan Taeyoung on 7/23/20.
//  Copyright © 2020 Dan Taeyoung. All rights reserved.
//

import SwiftUI



struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, World!!!")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action: {
                buttonPress()
            }) {
                Text("button me")
            }
            TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
            Button("choose dir") {
                let chosend = chooseDir()
                print(chosend)
                
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


func chooseDir() -> String {
    let dialog = NSOpenPanel();

    dialog.title                   = "Choose a dir";
    dialog.showsResizeIndicator    = true;
    dialog.allowsMultipleSelection = false;
    dialog.canChooseFiles = false;
    dialog.canChooseDirectories = true;

    if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
        let result = dialog.url // Pathname of the file

        if (result != nil) {
            let path: String = result!.path
            return path
        }
        
    } else {
        // User clicked on "Cancel"
        return ""
    }
    
    return ""
}

func buttonPress() -> Bool {
    let myAppleScript = "display alert \"yo\""
    var error: NSDictionary?
    if let scriptObject = NSAppleScript(source: myAppleScript) {
        if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error) {
            print(output.stringValue)
            return true
        } else if (error != nil) {
            print("error: \(error)")
            return false
        }
    }
    return true
}
