//
//  FolderScripts.swift
//  ChordFolder
//
//  Created by Dan Taeyoung on 7/28/20.
//  Copyright © 2020 Dan Taeyoung. All rights reserved.
//

import Foundation

class FolderScripts {
    
    //@ObservedObject var userSettings = UserSettings()
    static let shared = FolderScripts()
    
        
        let ap = """
                tell application "System Events"
                    set DialogApp to name of first application process ¬
                        whose role description of window 1 is "dialog"
                    set frontWindow to the first window of application process DialogApp
                end tell

                
                activate application DialogApp
                tell application "System Events"
                    keystroke "g" using {command down, shift down}
                    delay (0.4)
                    keystroke "/Users/provolot/Downloads"
                    delay (0.4)
                    key code 76
                end tell
"""
        
        let ap2 = """
     

set windowTitle to ""
tell application "System Events"
    set frontApp to first application process whose frontmost is true
    set frontAppName to name of frontApp

end tell



return {frontAppName}
"""
        
        let ap3 = """

set windowTitle to ""
display alert "hoooo"
tell application "System Events"
    set frontApp to the first application process whose frontmost is true
    set frontAppName to name of frontApp
    --set frontWindow to the first window of application process frontAppName
    set frontWindowProps to properties of frontApp
    display alert frontWindowProps

    
end tell


"""
        
        let ap4 = """
        tell application "Safari" to search the web for "macOS"
        """
    
    class func openFolder(dir: String) {
        
        
        
        print(dir + "Pressed at \(Date())")
        //print(NSWorkspace.shared.frontmostApplication)
        
    
        
        //changeOpenDialogAppleScript(dir: "/Users/provolot")
        
        print(openFinderAppleScript(dir: dir))
        let res = runAppleScript(myAppleScript: openFinderAppleScript(dir: dir))
        print("result:::: ")
        print(res)
        
        
    }
    
    /*func openFinder(dir: String){
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: dir)
    }*/
    
    
    class func runAppleScript(myAppleScript: String) -> String {
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: myAppleScript) {
            if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error) {
                print(output.stringValue)
                return output.stringValue ?? ""
            } else if (error != nil) {
                print("error: \(error)")
                return "error: \(error)"
            }
        }
        return ""
    }
    
    
    
    class func openFinderAppleScript(dir: String) -> String {
        return """
        set targetFolder to POSIX file \"\(dir)\"
        
        tell application "Finder"
        open targetFolder
        activate
        end tell
        
        """
    }
    
}
