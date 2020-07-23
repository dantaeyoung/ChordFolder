import Foundation
import Combine

struct DirectoryShortcut: Identifiable {
    var id: String
    var dirpath: String
    var shortcut: String
}

class UserSettings: ObservableObject {
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }
    
    @Published var directoryShortcuts: [DirectoryShortcut]
    
    
    init() {
        self.username = UserDefaults.standard.object(forKey: "username") as? String ?? ""
        
        self.directoryShortcuts = [
            DirectoryShortcut(id: "0", dirpath: "/Users/" , shortcut: ""),
            DirectoryShortcut(id: "1", dirpath: "/Users/", shortcut: ""),
            DirectoryShortcut(id: "2", dirpath: "/Users/", shortcut: "")
        ]
    }
    
    static func setDirectory(index: integer_t, dir: String) {
        //self.directoryShortcuts[index] = dir;
        //UserDefaults.standard.set(self.directoryShortcuts, forKey: "directoryShortcuts")
   }
}
