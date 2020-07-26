//
//  WebViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 1/6/20.
//  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class HorizontalWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var boxView = UIView()
    
    lazy var webView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = .white
        view.navigationDelegate = self
//        view.scalesPageToFit = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(webView)
        
        webView.isHidden = true
        
        webView.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        webView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        webView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        webView.transform = CGAffineTransform(rotationAngle: .pi/2)
    }
    
//    func webViewDidStartLoad(_ webView: UIWebView){
//
//        // Box config:
//        boxView = UIView(frame: CGRect(x: 115, y: 110, width: 80, height: 80))
//        boxView.backgroundColor = .lightGray
//        boxView.alpha = 0.9
//        boxView.layer.cornerRadius = 10
//
//        boxView.center = view.center
//
//        // Spin config:
//        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
//        activityView.frame = CGRect(x: 20, y: 12, width: 40, height: 40)
//        activityView.startAnimating()
//
//        // Text config:
//        let textLabel = UILabel(frame: CGRect(x: 0, y: 50, width: 80, height: 30))
//        textLabel.textColor = UIColor.white
//        textLabel.textAlignment = .center
//        textLabel.font = mainFont(size: 13)
//        textLabel.text = "Loading..."
//
//        // Activate:
//        boxView.addSubview(activityView)
//        boxView.addSubview(textLabel)
//        view.addSubview(boxView)
//
//    }
//    func webViewDidFinishLoad(_ webView: UIWebView){
//        boxView.removeFromSuperview()
//        webView.isHidden = false
//    }
//    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
//        boxView.removeFromSuperview()
//        webView.isHidden = false
//    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        // Box config:
        boxView = UIView(frame: CGRect(x: 115, y: 110, width: 80, height: 80))
        boxView.backgroundColor = .lightGray
        boxView.alpha = 0.9
        boxView.layer.cornerRadius = 10
        
        boxView.center = view.center

        // Spin config:
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activityView.frame = CGRect(x: 20, y: 12, width: 40, height: 40)
        activityView.startAnimating()

        // Text config:
        let textLabel = UILabel(frame: CGRect(x: 0, y: 50, width: 80, height: 30))
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = .center
        textLabel.font = mainFont(size: 13)
        textLabel.text = "Loading..."

        // Activate:
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        view.addSubview(boxView)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        boxView.removeFromSuperview()
        webView.isHidden = false
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        boxView.removeFromSuperview()
        webView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        webView.evaluateJavaScript(jscript)
    }
    
}
