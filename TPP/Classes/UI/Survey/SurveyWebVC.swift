//
//  SurveyWebVC.swift
//  TPP
//
//  Created by Igors Nemenonoks on 24/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import DZNWebViewController

class SurveyWebVC: DZNWebViewController {

    var activityCompletionHandler: ((ActivityCreateResponseDO) -> Void)?
    var activity: ActivityDO?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideBarsWithGestures = false
        self.showRightButton(loading: false)
    }

    func showRightButton(loading: Bool) {
        if loading {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
            indicator.startAnimating()
            indicator.hidesWhenStopped = true
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: indicator)
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(onCancel))
        }
    }

    @objc func onCancel() {
        self.dismiss(animated: true, completion: nil)
        //self.complete()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func complete() {
        if let acId = activity?.id {
            let request = TPPPostWebSurveyActivityRequest(activityId: acId)
            let handler = self.activityCompletionHandler
            self.showRightButton(loading: true)
            _ = request.send().asObservable().subscribe(onNext: { (response) in
                self.dismiss(animated: true, completion: nil)
                TPPLoadActivityListEvent().send()
                handler?(response)
            }, onError: {[weak self] (error) in
                self?.showTPPAlert(error: error)
                self?.showRightButton(loading: false)
            })
        }
    }

    override func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url?.absoluteString.contains("survey_status=complete") == true {
            self.complete()
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

}
