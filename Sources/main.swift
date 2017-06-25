// the web server : http://www.kitura.io/en/starter/gettingstarted.html
import Kitura
import KituraNet

// The http requests: https://github.com/JustHTTP/Just
//import Just
// The http requests compatible with linux: https://github.com/IBM-Swift/Kitura-Request
import KituraRequest


// The JSON handler : https://github.com/SwiftyJSON/SwiftyJSON#requirements
import SwiftyJSON

import Foundation


// Create a new router
let router = Router()

// Function to extract the body from the received data in a kitura-request

func bodyFromData(rawdata: Data?) -> JSON {
    // var response = JSON(data: rawdata!)
    var response = JSON("")

    // guard let myData = rawdata else {
    //     print("data not available to decode")
    //     return [[:]]
    // }
    // print("Starting to process response")
    
    guard let rawResponse = rawdata else {
        print("Data is empty")
        return response
    }
    print("RawResponse: \(rawResponse)")
    guard let dataString = String(data: rawResponse, encoding: String.Encoding.utf8) else {
        print("Unable to convert to string")
        return response
    }
        print("dataString: \(dataString)")

    let result = dataString.range(of: "\r\n\r\n", options: NSString.CompareOptions.literal, range: dataString.startIndex..<dataString.endIndex, locale: nil)
    // print(result)

    guard let found = result else {
        print("Unable to extract the body from the response")
        return response
    }
            // print("found: \(found)")

    let start = found.lowerBound
    // print("Printing what we think is the body")
    // print(dataString[start..<dataString.endIndex])
    let responseBody = dataString[start..<dataString.endIndex]
    // print("responseBody:\n\(responseBody)")


    guard let bodyData = responseBody.data(using: .utf8) else {
        print("unable to convert from string to data")
        return response
    }
    // print("bodyData: \(bodyData)")


    response = JSON(data:bodyData)
    return response

}


// Handle HTTP GET requests to /
router.get("/") {
    request, response, next in
    
//    var r = Just.get("http://httpbin.org/get", params:["page": 3])
//    let usableData = JSON(r.json!)
//
//    let ip = usableData["origin"].stringValue
//    print(r.text!)
//    response.send(ip)
    let urlString = "https://ghibliapi.herokuapp.com/films"
    
    let APIRequest = KituraRequest.request(.get,
                                           urlString,
                                           parameters: ["limit":3],
                                           encoding: JSONEncoding.default)
    APIRequest.response({
        request, response, data, error in
        print(response?.status)
        guard let rawResponse = data else {
            print("Data is empty")
            return
        }
        guard let datastring = String(data: rawResponse, encoding: String.Encoding.utf8) else {
            print("Unable to convert to string")
            return
        }
//        print(datastring)
        
//        iterating through loop
        /*
         If json is .Array
         The `index` is 0..<json.count's string value
         for (index,subJson):(String, JSON) in json {
            //Do something you want
         }
*/
        let usableData = JSON(data:rawResponse)
        for (_, movie):(String, JSON) in usableData {
        guard let movieName = movie["title"].string else { return }
            print(movieName)
        }
        
        
        
        
        
    })
    
    
    next()
}

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8086, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
