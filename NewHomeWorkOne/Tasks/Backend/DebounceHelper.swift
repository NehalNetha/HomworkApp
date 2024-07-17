//
//  DebounceHelper.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 27/06/24.
//

import Foundation


class Debouncer {
    private var workItem: DispatchWorkItem?
    private let delay: TimeInterval
    
    init(delay: TimeInterval) {
        self.delay = delay
    }
    
    func call(_ action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem {
            action()
        }
        if let workItem = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
}
