import Cocoa
import SwiftUI
import HotKey


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var userSettings = UserSettings()

    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    
    public var hotKey1: HotKey?
    public var hotKey2: HotKey?
    public var hotKey3: HotKey?
    
    
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
            let dir = self.userSettings.directoryShortcuts[0]
            FolderScripts.openFolder(dir: dir)
        }
        hotKey2 = HotKey(key: .f2, modifiers: [])
        hotKey2!.keyDownHandler = {
            let dir = self.userSettings.directoryShortcuts[1]
            FolderScripts.toggleDarkMode()
            //FolderScripts.openFolder(dir: dir)
        }
        hotKey3 = HotKey(key: .f3, modifiers: [])
        hotKey3!.keyDownHandler = {
            let dir = self.userSettings.directoryShortcuts[2]
            FolderScripts.openFolder(dir: dir)
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
    
    
    
}

struct AppDelegate_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

