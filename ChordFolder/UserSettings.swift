import Foundation
import Combine
/* DIRECTORY SHORTCUT WITH LIST */

class UserSettings: ObservableObject {
    
    
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }
    
    @Published var score = 0
    
    @Published var directoryShortcuts: [String]
        {
        didSet {
            print("didset")
            UserDefaults.standard.set(directoryShortcuts, forKey: "directoryShortcuts")
        }
    }
    
    
    let homeDirURL = FileManager.default.homeDirectoryForCurrentUser
    
    init() {
        self.username = UserDefaults.standard.object(forKey: "username") as? String ?? ""
        
        self.directoryShortcuts = UserDefaults.standard.object(forKey: "directoryShortcuts") as? [String] ?? ["", "", ""]
        
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
