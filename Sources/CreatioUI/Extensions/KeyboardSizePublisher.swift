//
//  KeyboardSizePublisher.swift
//  
//
//  Created by Davis Allie on 8/6/2022.
//

import UIKit

public enum KeyboardSizePublishers {
    
    private static let mainObserver = NotificationObserver(name: UIResponder.keyboardWillChangeFrameNotification)
    public static let height = mainObserver.$dimension.eraseToAnyPublisher()
    
}

fileprivate class NotificationObserver: ObservableObject {
    
    @Published var dimension: CGFloat = 0
    init(name: Notification.Name) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(notification:)),
                                               name: name,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handle(notification: Notification) {
        guard let info = notification.userInfo, let rect = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        dimension = rect.height
    }
    
}
