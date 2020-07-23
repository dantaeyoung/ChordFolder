import Cocoa
import SwiftUI
import HotKey


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

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
            self.openFolder(keyn: 1)
        }
        hotKey2 = HotKey(key: .f2, modifiers: [])
        hotKey2!.keyDownHandler = {
            self.openFolder(keyn: 2)
        }
        hotKey3 = HotKey(key: .f3, modifiers: [])
        hotKey3!.keyDownHandler = {
            self.openFolder(keyn: 3)
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
    
    func openFolder(keyn: integer_t) {
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
        
        let dirpath = "/Users/provolot/Downloads/"
        let url = URL(fileURLWithPath: dirpath)
        self.openFinder(url: url)
        
    }
    
    func openFinder(url: URL?){
        guard let url = url else { return }
        NSWorkspace.shared.activateFileViewerSelecting([url])
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
