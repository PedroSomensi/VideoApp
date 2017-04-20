//
//  informationsDAO.swift
//  MoymerApp
//
//  Created by Pedro on 20/04/17.
//  Copyright © 2017 Pedro. All rights reserved.
//

import UIKit

class informationsDAO: NSObject {

    private let urlString = "http://a63298e20131911e7b0d20268bf074d8-1795538358.us-east-2.elb.amazonaws.com:8080/video/list"
    
    private var cellSelected = 0
    
    static let sharedInstance = informationsDAO()
    
    private var arrayVideoInformations = [videoInfomartions]()
    
    private override init() {
        super.init()
        
    }
    
    func addVideoinfo(title: String, thumb: String!, urlvideo: String!) {
        self.arrayVideoInformations.append(videoInfomartions(titleAux: title, thumbAux: thumb, urlvideoAux: urlvideo))
    }
    
    func getVideoInfo(index : Int!) -> videoInfomartions!{
        return self.arrayVideoInformations[index]
    }
    
    func loadVideosInfos() {
        
        
        
        let myUrl = URL(string: urlString)
        let request = NSMutableURLRequest(url: myUrl!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if error != nil {
                print(error!)
            } else {
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray
                    
                    if let parseJSON = json{
                        for i in 0..<parseJSON.count {
                            if let dict = parseJSON[i] as? NSDictionary {
                                self.addVideoinfo(title: dict.value(forKey: "name") as! String, thumb: dict.value(forKey: "thumb") as! String, urlvideo: dict.value(forKey: "url") as! String)
                            }
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
        }
        
        task.resume()
    }
    
    func getCount() -> Int! {
        return self.arrayVideoInformations.count
    }
    
    func setCellSelected(value : Int!) {
        self.cellSelected = value
    }
    
    func getCellSelected() -> Int! {
        return self.cellSelected
    }
    
    
}
