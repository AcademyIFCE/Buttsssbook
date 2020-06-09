//
//  KeyboardState.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 23/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit
import Combine

enum KeyboardState {
    
    case willShow(height: CGFloat)
    case didShow(height: CGFloat)
    case willHide(height: CGFloat)
    case didHide(height: CGFloat)
    
    init?(_ notification: Notification) {
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            self = .willShow(height: keyboardEndFrame.height)
        case UIResponder.keyboardDidShowNotification:
            let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            self = .didShow(height: keyboardEndFrame.height)
        case UIResponder.keyboardWillHideNotification:
            self = .willHide(height: 0)
        case UIResponder.keyboardDidHideNotification:
            self = .didHide(height: 0)
        default:
            return nil
        }
    }
    
    var notification: NSNotification.Name {
        switch self {
        case .willShow:
            return UIResponder.keyboardWillShowNotification
        case .didShow:
            return UIResponder.keyboardDidShowNotification
        case .willHide:
            return UIResponder.keyboardWillHideNotification
        case .didHide:
            return UIResponder.keyboardDidHideNotification
        }
    }
    
    static var notifications: [NSNotification.Name] {
        [UIResponder.keyboardWillShowNotification, UIResponder.keyboardDidShowNotification,
         UIResponder.keyboardWillHideNotification, UIResponder.keyboardDidHideNotification ]
    }
    
}
