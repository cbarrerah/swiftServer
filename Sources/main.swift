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
        for (i, movie):(String, JSON) in usableData {
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
