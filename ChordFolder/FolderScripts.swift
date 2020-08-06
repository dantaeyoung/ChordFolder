//
//  FolderScripts.swift
//  ChordFolder
//
//  Created by Dan Taeyoung on 7/28/20.
//  Copyright © 2020 Dan Taeyoung. All rights reserved.
//

import Foundation
import Cocoa


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
        
        
        
        let ap4 = """
        tell application "Safari" to search the web for "macOS"
        """
    
    class func openFolder(dir: String) {
        
        let ap3 = """

        set windowTitle to ""
        tell application "System Events"
            set frontApp to the first application process whose frontmost is true
            set frontAppName to name of frontApp
            --set frontWindow to the first window of application process frontAppName
            set frontWindowProps to properties of frontApp
            display alert frontWindowProps
            
        end tell


        """
        
        let ap4 = """
        tell application "Finder"
            set _b to bounds of window of desktop
        end tell
        """
        
        print(dir + "Pressed at \(Date())")
        //print(NSWorkspace.shared.frontmostApplication)
        
        let res = runAppleScript(myAppleScript: ap3)
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
    
    /* everything below this is from NightFall */
    
    struct AppleScriptError : Error {
        let errorDict: NSDictionary
        let errorNumber: Int?
        let errorMessage: String?
        
        init(_ errorInfo: NSDictionary) {
            self.errorDict = errorInfo
            self.errorNumber = errorDict["NSAppleScriptErrorNumber"] as? Int
            self.errorMessage = errorDict["NSAppleScriptErrorMessage"] as? String
        }
    }
    
    

    class func checkSystemEventsPermission(canPrompt: Bool) -> Bool {
        let bundleID = "com.apple.systemevents"
        
        // First, make sure the System Events application is running...
        
        if NSRunningApplication.runningApplications(withBundleIdentifier: bundleID).isEmpty {
            NSWorkspace.shared.launchApplication(withBundleIdentifier: bundleID, options: .withoutActivation,
                additionalEventParamDescriptor: nil, launchIdentifier: nil)
        }
        
        // ...then check the permission
        
        let target = NSAppleEventDescriptor(bundleIdentifier: bundleID)
        let status = AEDeterminePermissionToAutomateTarget(target.aeDesc, typeWildCard, typeWildCard, canPrompt)
                
        return status == noErr
    }

    enum SystemAppearance: String {
        case light = "no"
        case dark = "yes"
        case toggle = "not dark mode"
    }

    class func setSystemAppearance(to appearance: SystemAppearance) throws {
        let scriptSource = """
            tell application "System Events"
                tell appearance preferences
                    set dark mode to \(appearance.rawValue)
                end tell
            end tell
            """
        
        // This forced unwrap should be safe, as I can't find any situation where it returns nil
        let script = NSAppleScript(source: scriptSource)!
        
        var error: NSDictionary?
        script.executeAndReturnError(&error)
        
        if let error = error {
            throw AppleScriptError(error)
        }
    }
    
    
    /// Switches between light mode and dark mode.
    ///
    /// This function includes behavior not in `setSystemAppearance(to:)`, such as displaying the fade
    /// animation and displaying errors in alerts.
    
    class func toggleDarkMode() {
        if !checkSystemEventsPermission(canPrompt: true) {
            let alert = NSAlert()
            alert.messageText = "System Events are not enabled for ChordFolder."
            alert.informativeText = "ChordFolder needs access to System Events to enable and disable dark mode. Enable \"Automation\" for ChordFolder in System Preferences to use ChordFolder."
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Open System Preferences")
            
            if alert.runModal() == .alertSecondButtonReturn {
                // Opens the Automation section in System Preferences
                if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation") {
                    NSWorkspace.shared.open(url)
                }
            }
            
            return
        }
                
        do {
            try setSystemAppearance(to: .toggle)
        } catch {
            let alert = NSAlert()
            if let error = error as? AppleScriptError {
                alert.messageText = "An AppleScript error ocurred."
                if let errorNumber = error.errorNumber {
                    alert.informativeText += "Error \(errorNumber)\n"
                }
                if let errorMessage = error.errorMessage {
                    alert.informativeText += "\"\(errorMessage)\""
                }
            }
            alert.runModal()
        }
    }
    
}
