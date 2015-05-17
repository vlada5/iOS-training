//
//  TodoDataManager.swift
//  TodoApp
//
//  Created by Kotaro Hirayama on 5/13/15.
//  Copyright (c) 2015 Kotaro Hirayama. All rights reserved.
//

import Foundation

struct TODO { // 構造体: クラスとほぼ同等。ただ参照渡しでなく値渡し
    var title : String
}

class TodoDataManager {
    
    let STORE_KEY = "TodoDataManager.store_key"
    
    class var sharedInstance : TodoDataManager {
        struct Static {
            static let instance : TodoDataManager = TodoDataManager()
        }
        return Static.instance
    }
    
    var todoList: [TODO]
    
    var size : Int {
        return todoList.count
    }
    subscript(index: Int) -> TODO { // []でアクセスしたときの振る舞い
        return todoList[index]
    }
    
    init() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let data = defaults.objectForKey(self.STORE_KEY) as? [String] {
            self.todoList = data.map { title in
                TODO(title: title)
            }
        } else {
            self.todoList = []
        }
    }
    
    class func validate(todo: TODO!) -> Bool {
        return todo != nil && todo.title != ""
    }
    
    func save() { // localStorage的なノリのやつぽ
        let defaults = NSUserDefaults.standardUserDefaults()
        let data = self.todoList.map { todo in
            todo.title
        }
        defaults.setObject(data, forKey: self.STORE_KEY)
    }
    
    func create(todo: TODO!) -> Bool {
        if TodoDataManager.validate(todo) {
            self.todoList += todoList
            self.save()
            return true
        }
        return false
    }
    
    func update(todo: TODO!, at index: Int) -> Bool {
        if(index >= self.todoList.count) {
            return false
        }
        
        if TodoDataManager.validate(todo) { // TODO: if文、括弧なしでええん？
            todoList[index] = todo
            self.save()
            return true
        }
        return false
    }
    
    func remove(index: Int) -> Bool {
        if(index >= self.todoList.count) {
            return false
        }
        
        self.todoList.removeAtIndex(index)
        self.save()
        
        return true
    }
}
