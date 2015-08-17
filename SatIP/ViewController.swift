//
//  ViewController.swift
//  SatIP
//
//  Created by Björn Orri Saemundsson on 8/12/15.
//  Copyright (c) 2015 Eurescom. All rights reserved.
//

import UIKit
import Alamofire
import CocoaSSDP
import MobileVLCKit

class ViewController: UIViewController {
    
    let browser = SSDPServiceBrowser(serviceType: "urn:ses-com:device:SatIPServer:1")
    var services = [SSDPService]()
    var parsing = false
    var complete = false
    var tunerString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        browser.delegate = self
        browser.startBrowsingForServices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController: SSDPServiceBrowserDelegate {
    
    func ssdpBrowser(browser: SSDPServiceBrowser!, didFindService service: SSDPService!) {
        println("Found service: \(service.location)")
        // Because contains(services, service) doesn't compare correctly.
        var contains = false
        for s in services {
            if s.uniqueServiceName == service.uniqueServiceName {
                contains = true
                break
            }
        }
        if !contains {
            services.append(service)
            Alamofire.request(Method.GET, service.location.URLString, parameters: nil, encoding: ParameterEncoding.URL, headers: nil).response() {
                (request, respons, data, error) in
                if let error = error {
                    println("Error")
                    return
                }
                let parser = NSXMLParser(data: data!)
                parser.delegate = self
                if parser.parse() {
                } else {
                }
            }
        }
    }
    
    func ssdpBrowser(browser: SSDPServiceBrowser!, didRemoveService service: SSDPService!) {
        println("Removed service")
    }
    
    func ssdpBrowser(browser: SSDPServiceBrowser!, didNotStartBrowsingForServices error: NSError!) {
        println("Did not start browsing for services")
    }
}


extension ViewController: NSXMLParserDelegate {
   
    // Why does life have to be so complicated?
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        if elementName == "satip:X_SATIPCAP" {
            parsing = true
        }
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if parsing {
            if let string = string {
                tunerString += string
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "satip:X_SATIPCAP" && !complete {
            parsing = false
            complete = true
        }
    }
}