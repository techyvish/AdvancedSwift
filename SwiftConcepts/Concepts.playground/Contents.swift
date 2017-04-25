//: Playground - noun: a place where people can play

import UIKit

extension Array {
    
    func map<T>(_ transform:(Element)-> T) -> [T] {
        var result:[T] = []
        result.reserveCapacity(count)
        for x in self {
            result.append(transform(x))
        }
        return result
    }
    
}

let a = [10,20,30,40]

let k  = a.map { (i) -> Int in
    i * i
}