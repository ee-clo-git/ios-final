//
// Created by Igors Nemenonoks on 12/02/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import Foundation

class EventBus {

    var queue: OperationQueue

    init(queue: OperationQueue) {
        self.queue = queue
    }

    func send(event: AnyObject) {
        self.queue.addOperation {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:String.className(event)), object: event)
        }
    }

    func handleEvent<T: PubSubEvent>(target:EventBusObservable, handleBlock: ((T.EventResult) -> Void)!) where T.EventResult == T {
        let notificationName = NSNotification.Name(rawValue: T.eventName())
        target.eventBusObserver.addObserver(forName: notificationName, object: nil, queue: self.queue) { (notification) in
            if let handler = handleBlock {
                handler((notification.object as? T)!.event())
            }
        }
    }

}

class EventBusObserver {

    var objectProtocol: NSObjectProtocol?

    func addObserver(forName name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Swift.Void) {
        self.objectProtocol = NotificationCenter.default.addObserver(forName: name, object: obj, queue: queue, using: block)
    }

    deinit {
        if let obj = self.objectProtocol {
            NotificationCenter.default.removeObserver(obj)
        }
        self.objectProtocol = nil
        print("deinit observer!")
    }
}

protocol EventBusObservable {
    var eventBusObserver: EventBusObserver {get set}
    func handleBGEvent<T: PubSubEvent>(handleBlock: ((T.EventResult) -> Void)!) where T.EventResult == T
    func handleUIEvent<T: PubSubEvent>(handleBlock: ((T.EventResult) -> Void)!) where T.EventResult == T
}

extension EventBusObservable {
    func handleBGEvent<T: PubSubEvent>(handleBlock: ((T.EventResult) -> Void)!) where T.EventResult == T {
        BGEventBus.sharedInstance.handleEvent(target: self, handleBlock:handleBlock)
    }

    func handleUIEvent<T: PubSubEvent>(handleBlock: ((T.EventResult) -> Void)!) where T.EventResult == T {
        UIEventBus.sharedInstance.handleEvent(target: self, handleBlock:handleBlock)
    }
}
