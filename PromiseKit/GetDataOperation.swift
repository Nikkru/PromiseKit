//
//  GetDataOperation.swift
//  PromiseKit
//
//  Created by Nikolai Krusser on 10.02.2022.
//

import Foundation
import Alamofire

// напишем универсальную операцию, которую можно будет использовать для любого запроса.

class GetDataOperation: AsyncOperation {
    
    private var request: DataRequest
    var data: Data?
    
       init(request: DataRequest) {
           self.request = request
       }
    
    override func cancel() {
        
        request.cancel()
        super.cancel()
    }
    
    override func main() {
        
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            
            self?.data = response.data
            self?.state = .finished
        }
    }
}

// Создадим общий для всех асинхронных операций класс AsyncOperation. Он будет содержать всю необходимую логику, но в нем не будет подробностей о том, чем конкретно операция занимается.

class AsyncOperation: Operation {
    
    enum State: String {
        
        case ready, executing, finished
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    override var isFinished: Bool {
        return state == .finished
    }
    override func start() {
        
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }
    override func cancel() {
        
        super.cancel()
        state = .finished
    }
}

