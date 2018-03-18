//
//  TableViewManagerCache.swift
//  TableViewManager
//
//  Created by Julio Fernandes on 18/02/18.
//

import UIKit

class SelfTableViewManagerCache: NSObject {
    
    var items = NSMutableDictionary()
    static var instance: SelfTableViewManagerCache!
    
    deinit { NSLog("Dealloc SelfTableViewManagerCache") }
    
    class func shared() -> SelfTableViewManagerCache {
        self.instance = (self.instance ?? SelfTableViewManagerCache())
        
        return self.instance
    }
    
    override init() {
        super.init()
        let selector = #selector(clearCache)
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    func loadNib(path: String?, owner: AnyObject) -> AnyObject? {
        guard let pathItem = path else {
            return nil
        }
        
        var cached: UINib?
        objc_sync_enter(items)
        cached = items.object(forKey: pathItem) as? UINib
        objc_sync_exit(items)
        
        if let cachedNib = cached {
            return cachedNib.instantiate(withOwner: owner, options: [:]) as AnyObject?
        } else {
            let newNib = UINib(nibName: pathItem, bundle: nil)
            objc_sync_enter(items)
            items.setValue(newNib, forKey: pathItem)
            objc_sync_exit(items)
            
            return newNib.instantiate(withOwner: owner, options: [:]) as AnyObject?
        }
    }
    
    @objc func clearCache() {
        items.removeAllObjects()
    }
}
