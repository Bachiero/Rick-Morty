//
//  ServiceQueue.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 04.03.24.
//

import Foundation

public class ServiceQueue {
    private var current = 0 {
        didSet {
            if current == 0 {
                self.acton?()
            }
        }
    }
    
    public var acton: (() -> Void)?
    
    public init(action: (() -> Void)? = nil) {
        self.acton = action
    }
    
    public func enqueue() {
        self.current += 1
    }
    
    public func dequeue() {
        self.current -= 1
    }
    
    public func resetQueue() {
        self.current = .zero
    }
}
