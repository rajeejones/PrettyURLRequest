//
//  PrettyURLRequest.swift
//
//  An Extension to URLRequest to help debugging URLRequests
//
//  Created by Rajee Jones on 10/3/17.
//  MIT License
//  Copyright (c) 2017 Rajee Jones
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

public extension URLRequest {
    /// Returns a CURL inspired representation of the URLRequest
    func prettyRepresentation(requestName:String) -> String {
        
        var headers:String? {
            guard let headerFields = self.allHTTPHeaderFields else { return nil }
            
            var heads = ""
            for key in headerFields.keys {
                heads = heads.appendingFormat("%@: %@", key.replacingOccurrences(of: "\"", with: "\\\""), headerFields[key]!.replacingOccurrences(of: "\"", with: "\\\""))
            }
            return heads
        }
        
        var dataString:String? {
            guard let _ = self.httpBody,
                let result = try? JSONSerialization.jsonObject(with: self.httpBody!, options: .mutableContainers) as! [String:Any] else { return nil }
            
            return result.json()
        }
        
        return String.init(format:"--------\n%@ URLRequest:\n\nURL:\n%@\n\nMETHOD:\n%@\n\nHEADERS:\n%@\n\nDATA:\n%@\n\n--------",requestName,self.url?.absoluteString ?? "nil",
                           self.httpMethod ?? "nil",headers ?? "nil", dataString ?? "nil")
    }
}

public extension Collection {
    
    /// Convert self to JSON String.
    /// - Returns: Returns the JSON as String or empty string if error while parsing.
    /// Credit: https://stackoverflow.com/a/43410889
    func json() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
                print("Can't create string with data.")
                return "{}"
            }
            return jsonString
        } catch let parseError {
            print("json serialization error: \(parseError)")
            return "{}"
        }
    }
}

