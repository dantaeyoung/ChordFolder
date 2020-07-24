import Foundation
import Combine

struct DirectoryShortcut: Codable {
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
    
    @Published var score = 0
    
    @Published var directoryShortcuts: [DirectoryShortcut]
        {
        didSet {
            print("didset")
            UserDefaults.standard.set(directoryShortcuts, forKey: "directoryShortcuts")
        }
    }
    
    
    init() {
        self.username = UserDefaults.standard.object(forKey: "username") as? String ?? ""
        
        if let data = UserDefaults.standard.object(forKey: "directoryShortcuts") as? Data,
            let ds = try? JSONDecoder().decode(DirectoryShortcut.self, from: data) {
            self.directoryShortcuts = ds
        } else {
            self.directoryShortcuts = [
                DirectoryShortcut(id: "0", dirpath: "/Users/" , shortcut: ""),
                DirectoryShortcut(id: "1", dirpath: "/Users/", shortcut: ""),
                DirectoryShortcut(id: "2", dirpath: "/Users/", shortcut: "")
            ]
        }
        
    }
    /*
     func setUsername(username: String) {
     UserDefaults.standard.set(username, forKey: "username")
     }
     
     static func setDirectory(index: integer_t, dir: String) {
     //self.directoryShortcuts[index] = dir;
     //UserDefaults.standard.set(self.directoryShortcuts, forKey: "directoryShortcuts")
     }
     */
}
