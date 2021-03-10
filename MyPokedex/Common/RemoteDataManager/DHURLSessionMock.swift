/*
 Copyright (c) 2016 Dominik Hauser <dom@dasdom.de>
 
 Created by dasdom on 05.01.16.
 Updated to Swift 3 by Audrey Tam on 28.11.16

 */

import Foundation


//Class to allow unit tests to mock API answers easily
public protocol DHURLSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

//API call for URLSession will be a DHURLSession. It allows test calls, or real calls.
extension URLSession: DHURLSession { }


public final class URLSessionMock: DHURLSession {
    var url: URL?
    private let dataTaskMock: URLSessionDataTaskMock
    
    public init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        dataTaskMock = URLSessionDataTaskMock()
        dataTaskMock.taskResponse = (data, response, error)
    }

    public func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.url = url
        self.dataTaskMock.completionHandler = completionHandler
        return self.dataTaskMock
    }
    
    //Returns mock API answer with received data
    final private class URLSessionDataTaskMock: URLSessionDataTask {
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        var taskResponse: (Data?, URLResponse?, Error?)?
        
        override func resume() {
            DispatchQueue.global(qos: .default).async {
                self.completionHandler?(self.taskResponse?.0, self.taskResponse?.1, self.taskResponse?.2)
            }
        }
    }
    
}
