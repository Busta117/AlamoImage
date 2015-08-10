//
//  ImageRequest.swift
//  AlamoImage
//
//  Created by Guillermo Chiacchio on 6/4/15.
//
//

import Alamofire
import Foundation

#if os(iOS)
	
	/**
	Alamofire.Request extension to support a handler for images. iOS Only
	*/
	
	extension Alamofire.Request {
		
		
		public func imageResponseSerializer() -> GenericResponseSerializer<UIImage>
		{
			
			return GenericResponseSerializer { request, response, data in
				guard let data = data where data.length > 0 else {
					return .Failure(nil, NSError(domain: "Bad URL", code: 400, userInfo: [NSLocalizedDescriptionKey:"Bad URL"]))
				}
				
				if let image = UIImage(data: data, scale: UIScreen.mainScreen().scale) {
					return Result.Success(image)
				}else{
					return .Failure(nil, NSError(domain: "Bad URL", code: 400, userInfo: [NSLocalizedDescriptionKey:"Bad URL"]))
				}
				
			}
		}
		
		/**
		Adds a handler to be called once the request has finished.
		
		:param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the UIImage object, if one could be created from the URL response and data, and any error produced while creating the UIImage object.
		
		:returns: The request.
		*/
		public func responseImage(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<UIImage>) -> Void)-> Self{
			return response(responseSerializer: imageResponseSerializer(),completionHandler: completionHandler)
		}
		
		
		
	}
#endif
