//
//  ImageView.swift
//  AlamoImage
//
//  Created by Guillermo Chiacchio on 6/5/15.
//
//

import Alamofire
import Foundation
import UIKit

#if os(iOS)
	
	/**
	Extension to support and handle the request of a remote image, to be downloaded and set. iOS Only.
	*/
	public extension UIImageView {
		/// A reference to handle the `Request`, if any, for the `UIImage` instance.
		public var request: Alamofire.Request? {
			get {
				return associatedObject(self, key: &imageRequestPropertyKey) as! Alamofire.Request?
			}
			set {
				setAssociatedObject(self, key: &imageRequestPropertyKey, value: newValue)
			}
		}
		
		/**
		Creates a request using `Alamofire`, and sets the returned image into the `UIImageview` instance. This method cancels any previous request for the same `UIImageView` instance
		
		:param: URLStringConv The URL for the image.
		:param: placeholder An optional `UIImage` instance to be set until the requested image is available.
		:param: success The code to be executed if the request finishes successfully.
		:param: failure The code to be executed if the request finishes with some error.
		
		*/
		public func requestImage(URLStringConv: URLStringConvertible, placeholder: UIImage? = nil,
			success: (UIImageView, NSURLRequest?, NSHTTPURLResponse?, UIImage?) -> Void = { (imageView, _, _, theImage) in
				
				imageView.image = theImage
			},
			failure: (UIImageView, NSURLRequest?, NSHTTPURLResponse?, NSError?) -> Void = { (_, _, _, _) in }
			)
		{
			if (placeholder != nil) {
				self.image = placeholder
			}
			self.request?.cancel()
			if let cachedImage = imageCache?.objectForKey(URLStringConv.URLString) as? UIImage {
				success(self, nil, nil, cachedImage)
			} else {
				if !validateURL(URLStringConv){
					self.image = UIImage()
					return
				}
				self.request = Alamofire.request(.GET, URLStringConv).validate().responseImage() {
					(req, response, result) in
					
					if result.isSuccess{
						imageCache?.setObject(result.value!, forKey: URLStringConv.URLString)
						success(self, req, response, result.value)
					}else{
						failure(self, req, response, result.error)
					}
				}
			}
		}
		
		private func validateURL(URLStringConv: URLStringConvertible)->Bool{
			
			if let _ = NSURL(string: URLStringConv.URLString) {
				return true
			}
			
			return false
		}
		
	}
#endif
