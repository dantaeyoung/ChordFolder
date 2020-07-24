import Cocoa
import SwiftUI
import HotKey


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var userSettings = UserSettings()

    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        
        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 500)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "Icon")
            button.action = #selector(togglePopover(_:))
        }
        
        
        hotKey1 = HotKey(key: .f1, modifiers: [])
        hotKey1!.keyDownHandler = {
            self.openFolder(keyn: 0)
        }
        hotKey2 = HotKey(key: .f2, modifiers: [])
        hotKey2!.keyDownHandler = {
            self.openFolder(keyn: 1)
        }
        hotKey3 = HotKey(key: .f3, modifiers: [])
        hotKey3!.keyDownHandler = {
            self.openFolder(keyn: 2)
        }
        
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                self.popover.contentViewController?.view.window?.becomeKey()
            }
        }
    }
    
    func openFolder(keyn: Int) {
        

        
        print(keyn.description + "Pressed at \(Date())")
        print(NSWorkspace.shared.frontmostApplication)
        
        
        /*
         guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.Finder") else { return }
         let path = "/bin"
         let configuration = NSWorkspace.OpenConfiguration()
         configuration.arguments = [path]
         NSWorkspace.shared.openApplication(at: url,
         configuration: configuration,
         completionHandler: nil)
         */
        //   NSWorkspace.shared.openFile("/Users/provolot/Documents/")
        //NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: "/Users/")
        
        //let dirpath = "/Users/provolot/Downloads/"
        //let url = URL(fileURLWithPath: dirpath)
        //self.openFinder(dir: dirpath)
        
        
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
        
        //changeOpenDialogAppleScript(dir: "/Users/provolot")
        
        let dir = self.userSettings.directoryShortcuts[keyn]
        print(openFinderAppleScript(dir: dir))
        let res = runAppleScript(myAppleScript: openFinderAppleScript(dir: dir))
        print("result:::: ")
        print(res)

        
    }
    
    func openFinder(dir: String){
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: dir)
    }
    
    
    func runAppleScript(myAppleScript: String) -> String {
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
    
    public var hotKey1: HotKey?
    public var hotKey2: HotKey?
    public var hotKey3: HotKey?
    
    
}

struct AppDelegate_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

func openFinderAppleScript(dir: String) -> String {
    return """
    set targetFolder to POSIX file \"\(dir)\"

    tell application "Finder"
        open targetFolder
        activate
    end tell

    """
}
