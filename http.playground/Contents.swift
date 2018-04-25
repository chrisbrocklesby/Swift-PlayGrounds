import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

////////////////////////////// HTTP Function ///////////////////////////////////
public func http(url: String, method: String = "GET", type: String = "FORM", data: Dictionary <String, Any> = [:], completion: @escaping (_ status: Int?, _ response: String?, _ error: String?) -> Void = { _,_,_  in }) {
	
	// Set URL and Create URL Format String
	let setUrl = URL(string: url)
	
	// Put together HTTP request (URL/Headers/Body)
	var request = URLRequest(url: setUrl!)
	request.timeoutInterval = 1.0
	request.httpMethod = method.uppercased()
	
	if type.uppercased() == "JSON" {
		request.httpBody = try! JSONSerialization.data(withJSONObject: data)
		request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
	}
	
	if type.uppercased() == "FORM" {
		var urlQuery: String = ""
		for (key,value) in data {
			urlQuery +=  "\(key)=\(value)&"
		}
		request.httpBody = urlQuery.data(using: String.Encoding.utf8);
		request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
	}
	
	if type.uppercased() == "UPLOAD" {
		request.setValue("multipart/form-data; charset=utf-8", forHTTPHeaderField: "Content-Type")
	}
	
	// Create HTTP Task with Completion and Error Handling
	let httpTask = URLSession.shared.dataTask(with: request) { data, response, error in
		if let error = error {
			completion(nil, nil, "Error: \(error.localizedDescription)")
		}
		
		if let status = (response as? HTTPURLResponse)?.statusCode {
			if let body = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
				completion(status, body, nil)
			} else {
				completion(status, nil, nil)
			}
		}
	}
	httpTask.resume()
}


////////////////////////////// Calling Final HTTP Function ///////////////////////////////////

var bodyData = ["Frog": "Cow", "Pig": "Ms. Piggy", "Weirdo": "Gonzo"]

http(url: "https://jsonplaceholder.typicode.com/posts/")

http(url: "https://jsonplaceholder.typicode.com/posts/") { (status, response, error) in
print(response ?? "No Response")
}

