//
//  ImageRequest.swift
//  AlamoImage
//
//  Created by Guillermo Chiacchio on 6/4/15.
//
//

import Alamofire
import Foundation

#if os(OSX)

/**
Alamofire.Request extension to support a handler for images. OSX Only.
*/
extension Alamofire.Request {
    
    class func imageResponseSerializer() -> Serializer {
        return { request, response, data in
            if data == nil {
                return (nil, nil)
            }
            
            let image = NSImage(data: data!)
            
            return (image, nil)
        }
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the NSImage object, if one could be created from the URL response and data, and any error produced while creating the NSImage object.
    
    :returns: The request.
    */
    public func responseImage(completionHandler: (NSURLRequest, NSHTTPURLResponse?, NSImage?, NSError?) -> Void) -> Self {
        return response(serializer: Request.imageResponseSerializer(), completionHandler: { (request, response, image, error) in
            completionHandler(request!, response, image as? NSImage, error)
        })
    }
}
#endif
