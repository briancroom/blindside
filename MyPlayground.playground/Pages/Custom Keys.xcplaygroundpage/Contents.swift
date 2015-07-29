//: Playground - noun: a place where people can play

import Cocoa
import Blindside
import XCTest

(NSClassFromString("NSDateFormatter") as! NSObject.Type).init()

@objc class MyKey : NSObject {
    let innerKey: AnyObject

    init(innerKey: NSObject) {
        self.innerKey = innerKey
    }

    func bsCreateWithArgs(args: [AnyObject], injector: BSInjector) -> AnyObject {
        print("Creating!")
        return NSClassFromString(innerKey as! String)!
    }

    override func isEqual(object: AnyObject?) -> Bool {
        switch object {
        case let o as MyKey: return innerKey.isEqual(o.innerKey)
        default: return false
        }
    }

    override var hash: Int {
        get {
            return innerKey.hash
        }
    }
}


class MyModule : BSModule {
    @objc func configure(binder: BSBinder) {
        binder.bind("text", toInstance: "Hello World!")
    }
}

let injector = Blindside.injectorWithModule(MyModule())
injector.getInstance("text")
injector.getInstance(MyKey(innerKey: "NSDateFormatter"))



//////
MyKey(innerKey: "hi").isEqual(MyKey(innerKey: "hi"))
MyKey(innerKey: "hi").isEqual(MyKey(innerKey: "hi2"))
MyKey(innerKey: "hi").hash
MyKey(innerKey: "hi").hashValue
MyKey(innerKey: "hi2").hash
