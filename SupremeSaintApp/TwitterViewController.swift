

import UIKit
import TwitterKit

class TwitterViewController: TWTRTimelineViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = TWTRAPIClient()
        self.dataSource = TWTRUserTimelineDataSource(screenName: "thesupremesaint", apiClient: client)
    }
    
    
    
    
}
