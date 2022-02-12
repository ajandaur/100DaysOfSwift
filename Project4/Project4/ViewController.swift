//
//  ViewController.swift
//  Project4
//
//  Created by Anmol  Jandaur on 2/8/22.
//

import UIKit
import WebKit

// the order matters in class declaration
// "create a new subclass of UIViewController called ViewController, and tell the compiler that we promise we’re safe to use as a WKNavigationDelegate."
class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!

    var progressView: UIProgressView!
    
    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func loadView() {
        webView = WKWebView()
        // setting navigationDelegate property to self
        // means that when any web page navigation happens
        // the current view controller wants to know it happened (self)
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        // CHALLENG: Try making two new toolbar items with the titles Back and Forward
        let back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        
        
        toolbarItems = [progressButton, spacer, back, forward, refresh]
        navigationController?.isToolbarHidden = false
        
        // Swift has a special keyword, #keyPath, which works like the #selector keyword you saw previously: it allows the compiler to check that your code is correct – that the WKWebView class actually has an estimatedProgress property.
        // context is easier: if you provide a unique value, that same context value gets sent back to you when you get your notification that the value has changed.
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)

        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    // This delegate callback allows us to decide whether we want to allow navigation to happen or not every time something happens.
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // set constant url to be equal to the URL of navigation
        let url = navigationAction.request.url
        
        // "if there is a hot for this URL, pull it out"
        // host = webdomain like apple.com
        if let host = url?.host {
            // if so, loop through all sites in our safe list and place name of the site in the website variable
            for website in websites {
                // if website host is in list -> allow loading
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
            
            // cancel loading if no identical host was found in our safe list
            
            // CHALLENGE: If users try to visit a URL that isn’t allowed, show an alert saying it’s blocked.
            let ac = UIAlertController(title: "Page blocked…", message: "This website is blocked!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
            
        }
        
       
        decisionHandler(.cancel)
        
    }
 
    
    // this method tells us which key path ahs changed and sends us back the context we registered earlier
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }


}

