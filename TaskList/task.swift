

import UIKit

protocol TaskComposite {
    var parent: TaskComposite? { get set }
    var children: [TaskComposite] { get set }
    var name: String? { get set }
}

class Task: TaskComposite {
    var parent: TaskComposite?
    var children: [TaskComposite] = []
    var name: String?
    
    init(parent: TaskComposite?) {
        self.parent = parent
    }
    
}
