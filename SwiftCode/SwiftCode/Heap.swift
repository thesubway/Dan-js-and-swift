//
//  Heap.swift
//  SwiftCode
//
//  Created by Daniel Hoang on 7/14/19.
//  Copyright © 2019 Daniel Hoang. All rights reserved.
//
/*
 How to init with object:
 var myHeap = Heap<TaskNode>(sortCriteria: {$0.frequency > $1.frequency}, arr: [])
 myHeap.insert(value: TaskNode(value: "A", frequency: 4))
 
 Testing the code:
 var myHeap = Heap<Int>(sortCriteria: {$0 < $1}, arr: [4, 1, 0, 6, 2])
 myHeap.insert(value: 9)
 print(myHeap.pop())
 myHeap.insert(value: 8)
 
 */

import Foundation

public struct Heap<T> {
    
    var arr: [T]
    var sortCriteria: (T, T) -> Bool
    public var count: Int {
        return self.arr.count
    }
    public var isEmpty: Bool {
        return self.arr.count == 0
    }
    public var top: T? {
        return self.arr.count == 0 ? nil : self.arr[0]
    }
    
    /*
     EXAMPLE:
     let heap = Heap<FrequencyNode>(sortCriteria: {$0.frequency > $1.frequency}, arr: [])
     By selecting the > symbol, the example shows max heap.
     Every time the inner function returns true, it implies $0 belongs closer to main idx than $1 (true means $0 is bigger in a max heap, and $0 is smaller in a min heap)
     */
    init(sortCriteria: @escaping (T, T) -> Bool, arr: [T]) {
        self.sortCriteria = sortCriteria
        self.arr = []
        for eachElement in arr {
            self.insert(value: eachElement)
        }
    }
    
    private func parentIdx(ofIdx idx: Int) -> Int {
        if idx == 0 {
            return -1
        }
        return (idx - 1) / 2
    }
    private func childIdxLeft(ofIdx idx: Int) -> Int {
        return idx * 2 + 1
    }
    private func childIdxRight(ofIdx idx: Int) -> Int {
        return idx * 2 + 2
    }
    
    /*
     Up means towards the 0 index.
     */
    private mutating func shiftUp(idx: Int) {
        var childIdx = idx
        var parentIdx = self.parentIdx(ofIdx: idx)
        let child = self.arr[childIdx]
        // let parent, not setting as idx may return -1
        // while-loop checks if child belongs closer to the 0 idx or not.
        while childIdx > 0 && self.sortCriteria(child, self.arr[parentIdx]) {
            // swap them:
            (self.arr[childIdx], self.arr[parentIdx]) = (self.arr[parentIdx], self.arr[childIdx])
            // update indices:
            childIdx = parentIdx
            parentIdx = self.parentIdx(ofIdx: childIdx)
        }
    }
    
    /*
     Down means higher index (away from 0 index)
     */
    private mutating func shiftDown(idx: Int) {
        func recursiveShiftDown(idx: Int) {
            let leftIdx = self.childIdxLeft(ofIdx: idx)
            let rightIdx = self.childIdxRight(ofIdx: idx)
            
            // compare current (which is parent) to both leftChild and rightChild:
            
            var importantIdx = idx
            if leftIdx < self.arr.count && self.sortCriteria(self.arr[leftIdx], self.arr[idx]) {
                // update but don't swap nodes yet, in case rightIdx is more important
                importantIdx = leftIdx
            }
            if rightIdx < self.arr.count && self.sortCriteria(self.arr[rightIdx], self.arr[idx]) {
                importantIdx = rightIdx
            }
            if importantIdx == idx {
                return
            }
            
            (self.arr[idx], self.arr[importantIdx]) = (self.arr[importantIdx], self.arr[idx])
            let originalIdx = importantIdx
            recursiveShiftDown(idx: originalIdx)
        }
        recursiveShiftDown(idx: idx)
    }
    
    mutating func insert(value: T) {
        // insert to back of heap:
        self.arr.append(value)
        self.shiftUp(idx: self.arr.count-1)
    }
    
    mutating func replaceHead(value: T) {
        self.arr[0] = value
        self.shiftDown(idx: 0)
    }
    
    mutating func pop() -> T {
        if self.arr.count == 0 {
            fatalError("Unable to pop from empty Heap")
        }
        let first = self.arr[0]
        self.arr[0] = self.arr[self.arr.count-1]
        self.arr.removeLast()
        if self.arr.count > 0 {
            self.shiftDown(idx: 0)
        }
        return first
    }
}
