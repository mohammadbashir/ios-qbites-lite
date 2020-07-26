//
//  DietAssessmentViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 12/29/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import Firebase
import ABGaugeViewKit
import LinearProgressBar

class DietAssessmentViewController: UIViewController {
    
    var assessment = Assessment()
    
    let mainScrollView: UIScrollView = {
        
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
        
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let childLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = mainFont(size: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let segmentedControl: UISegmentedControl = {
        
        let segmentedControl = UISegmentedControl()
        
        segmentedControl.backgroundColor = mainGreenColor
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        segmentedControl.insertSegment(withTitle: "Last week", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Yesterday", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "This week", at: 2, animated: true)
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: mainGreenColor], for: UIControl.State.selected)
        
        segmentedControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
        
    }()
    
    let qcalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = mainFontBold(size: 20)
        label.textAlignment = .center
        label.text = "qCal"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let guage: ABGaugeView = {
        let guage = ABGaugeView()
        
        guage.translatesAutoresizingMaskIntoConstraints = false
        guage.backgroundColor = .clear
        guage.blinkAnimate = false
        guage.colorCodes =  UIColor.red.toHexString() + "," + mainYellowColor.toHexString() + "," + mainGreenColor.toHexString()
//        guage.areas = "15,25,60"
        guage.areas = String(GuageRedRatio) + "," + String(GuageYellowRatio) + "," + String(GuageGreenRatio)
//        guage.needleValue = 100
        guage.clipsToBounds = false
        
        return guage
    }()
    
    let adequacyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = mainFontBold(size: 20)
        label.textAlignment = .center
        label.text = "Diet Adequacy"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let adequacyMinLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = mainFont(size: 12)
        label.textAlignment = .center
//        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let adequacyMaxLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = mainFont(size: 12)
        label.textAlignment = .center
//        label.text = "100"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let adequacyBar: LinearProgressBar = {
        let bar = LinearProgressBar()
        bar.barColor = mainGreenColor
        bar.backgroundColor = .clear
        bar.trackColor = mainLightGrayColor.withAlphaComponent(0.7)
        
        bar.barThickness = 20
        bar.barPadding = 10
        bar.trackPadding = 3
        
//        bar.progressValue = 50
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    let diversityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = mainFontBold(size: 20)
        label.textAlignment = .center
        label.text = "Diet Diversity"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let diversityMinLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = mainFont(size: 12)
        label.textAlignment = .center
//        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let diversityMaxLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = mainFont(size: 12)
        label.textAlignment = .center
//        label.text = "100"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let diversityBar: LinearProgressBar = {
        let bar = LinearProgressBar()
        bar.barColor = mainGreenColor
        bar.backgroundColor = .clear
        bar.trackColor = mainLightGrayColor.withAlphaComponent(0.7)
        
        bar.barThickness = 20
        bar.barPadding = 10
        bar.trackPadding = 3
        
//        bar.progressValue = 50
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    let heightGrowthChartButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = mainGreenColor.cgColor
        button.layer.borderWidth = 2
        button.setTitle("Height Growth Chart", for: .normal)
        button.setTitleColor(mainGreenColor, for: .normal)
        button.titleLabel?.font =  mainFontBold(size: 20)
        button.addTarget(self, action: #selector(heightGrowthChartPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let heightGrowthChartInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "question")?.mask(with: mainGreenColor) , for: UIControl.State.normal)
        button.addTarget(self, action: #selector(growthChartInfoPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let weightGrowthChartButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = mainGreenColor.cgColor
        button.layer.borderWidth = 2
        button.setTitle("Weight Growth Chart", for: .normal)
        button.setTitleColor(mainGreenColor, for: .normal)
        button.titleLabel?.font =  mainFontBold(size: 20)
        button.addTarget(self, action: #selector(weightGrowthChartPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let weightGrowthChartInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "question")?.mask(with: mainGreenColor) , for: UIControl.State.normal)
        button.addTarget(self, action: #selector(growthChartInfoPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let assessmentHistoryButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = mainGreenColor.cgColor
        button.layer.borderWidth = 2
        button.setTitle("Assessment History", for: .normal)
        button.titleLabel?.font =  mainFontBold(size: 20)
        button.setTitleColor(mainGreenColor, for: .normal)
        button.addTarget(self, action: #selector(assessmentHistoryPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let assessmentHistoryInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "question")?.mask(with: mainGreenColor) , for: UIControl.State.normal)
        button.addTarget(self, action: #selector(assessmentHistoryInfoPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let updateChildButton: UIButton = {
        let button = UIButton()
        //        button.setTitle("Finsihed breast or formula feeding?", for: .normal)
        button.titleLabel?.font =  mainFont(size: 15)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.black, for: .normal)
        button.setTitle("update child weight or height?", for: .normal)
        button.addTarget(self, action: #selector(updateChild( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        
        if #available(iOS 11, *) {
            mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        
        contentView.addSubview(childLabel)
        contentView.addSubview(segmentedControl)
        contentView.addSubview(qcalLabel)
        contentView.addSubview(guage)
        
        contentView.addSubview(adequacyLabel)
        contentView.addSubview(adequacyMinLabel)
        contentView.addSubview(adequacyBar)
        contentView.addSubview(adequacyMaxLabel)
        
        contentView.addSubview(diversityLabel)
        contentView.addSubview(diversityMinLabel)
        contentView.addSubview(diversityBar)
        contentView.addSubview(diversityMaxLabel)
        
        contentView.addSubview(heightGrowthChartButton)
        heightGrowthChartButton.addSubview(heightGrowthChartInfoButton)
        
        contentView.addSubview(weightGrowthChartButton)
        weightGrowthChartButton.addSubview(weightGrowthChartInfoButton)
        
        contentView.addSubview(assessmentHistoryButton)
        assessmentHistoryButton.addSubview(assessmentHistoryInfoButton)
        
        contentView.addSubview(updateChildButton)
        
        childLabel.text = "Assessment for " + appChild().name
        
        segmentedControl.selectedSegmentIndex = 1
        displayAssessmentValues()
        getAssessment(period: "YESTERDAY")
        
    }
    
    override func viewSafeAreaInsetsDidChange() {
        // ... your layout code here
        layoutViews()
    }
    
    func layoutViews(){
        
        mainScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        mainScrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: mainScrollView.rightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true
        
        childLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7).isActive = true
        childLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        childLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        segmentedControl.topAnchor.constraint(equalTo: childLabel.bottomAnchor, constant: 7).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        qcalLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 7).isActive = true
        qcalLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        qcalLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        guage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        guage.topAnchor.constraint(equalTo: qcalLabel.bottomAnchor, constant: 7).isActive = true
        guage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
        guage.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
        
        adequacyLabel.topAnchor.constraint(equalTo: guage.bottomAnchor, constant: 7).isActive = true
        adequacyLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        adequacyLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        adequacyBar.topAnchor.constraint(equalTo: adequacyLabel.bottomAnchor, constant: 7).isActive = true
        adequacyBar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        adequacyBar.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        adequacyBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        adequacyMinLabel.rightAnchor.constraint(equalTo: adequacyBar.leftAnchor, constant: -3).isActive = true
        adequacyMinLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 3).isActive = true
        adequacyMinLabel.centerYAnchor.constraint(equalTo: adequacyBar.centerYAnchor, constant: 0).isActive = true
        adequacyMinLabel.heightAnchor.constraint(equalTo: adequacyMinLabel.widthAnchor, multiplier: 1).isActive = true
        
        adequacyMaxLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -3).isActive = true
        adequacyMaxLabel.leftAnchor.constraint(equalTo: adequacyBar.rightAnchor, constant: 3).isActive = true
        adequacyMaxLabel.centerYAnchor.constraint(equalTo: adequacyBar.centerYAnchor, constant: 0).isActive = true
        adequacyMaxLabel.heightAnchor.constraint(equalTo: adequacyMinLabel.widthAnchor, multiplier: 1).isActive = true
        
        diversityLabel.topAnchor.constraint(equalTo: adequacyBar.bottomAnchor, constant: 7).isActive = true
        diversityLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        diversityLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        diversityBar.topAnchor.constraint(equalTo: diversityLabel.bottomAnchor, constant: 7).isActive = true
        diversityBar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        diversityBar.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        diversityBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        diversityMinLabel.rightAnchor.constraint(equalTo: diversityBar.leftAnchor, constant: -3).isActive = true
        diversityMinLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 3).isActive = true
        diversityMinLabel.centerYAnchor.constraint(equalTo: diversityBar.centerYAnchor, constant: 0).isActive = true
        diversityMinLabel.heightAnchor.constraint(equalTo: adequacyMinLabel.widthAnchor, multiplier: 1).isActive = true
        
        diversityMaxLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -3).isActive = true
        diversityMaxLabel.leftAnchor.constraint(equalTo: diversityBar.rightAnchor, constant: 3).isActive = true
        diversityMaxLabel.centerYAnchor.constraint(equalTo: diversityBar.centerYAnchor, constant: 0).isActive = true
        diversityMaxLabel.heightAnchor.constraint(equalTo: adequacyMinLabel.widthAnchor, multiplier: 1).isActive = true
        
        heightGrowthChartButton.topAnchor.constraint(equalTo: diversityBar.bottomAnchor, constant: 20).isActive = true
        heightGrowthChartButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        heightGrowthChartButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        heightGrowthChartButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        heightGrowthChartInfoButton.widthAnchor.constraint(equalTo: heightGrowthChartButton.heightAnchor, multiplier: 0.7).isActive = true
        heightGrowthChartInfoButton.heightAnchor.constraint(equalTo: heightGrowthChartInfoButton.widthAnchor, multiplier: 1.0).isActive = true
        heightGrowthChartInfoButton.rightAnchor.constraint(equalTo: heightGrowthChartButton.rightAnchor, constant: -10).isActive = true
        heightGrowthChartInfoButton.centerYAnchor.constraint(equalTo: heightGrowthChartButton.centerYAnchor).isActive = true
        
        weightGrowthChartButton.topAnchor.constraint(equalTo: heightGrowthChartButton.bottomAnchor, constant: 20).isActive = true
        weightGrowthChartButton.centerXAnchor.constraint(equalTo: heightGrowthChartButton.centerXAnchor, constant: 0).isActive = true
        weightGrowthChartButton.widthAnchor.constraint(equalTo: heightGrowthChartButton.widthAnchor, multiplier: 1).isActive = true
        weightGrowthChartButton.heightAnchor.constraint(equalTo: heightGrowthChartButton.heightAnchor).isActive = true
        
        weightGrowthChartInfoButton.widthAnchor.constraint(equalTo: heightGrowthChartInfoButton.widthAnchor, multiplier: 1.0).isActive = true
        weightGrowthChartInfoButton.heightAnchor.constraint(equalTo: heightGrowthChartInfoButton.heightAnchor, multiplier: 1.0).isActive = true
        weightGrowthChartInfoButton.rightAnchor.constraint(equalTo: weightGrowthChartButton.rightAnchor, constant: -10).isActive = true
        weightGrowthChartInfoButton.centerYAnchor.constraint(equalTo: weightGrowthChartButton.centerYAnchor).isActive = true
        
        assessmentHistoryButton.topAnchor.constraint(equalTo: weightGrowthChartButton.bottomAnchor, constant: 20).isActive = true
        assessmentHistoryButton.centerXAnchor.constraint(equalTo: weightGrowthChartButton.centerXAnchor, constant: 0).isActive = true
        assessmentHistoryButton.widthAnchor.constraint(equalTo: weightGrowthChartButton.widthAnchor, multiplier: 1).isActive = true
        assessmentHistoryButton.heightAnchor.constraint(equalTo: weightGrowthChartButton.heightAnchor).isActive = true
        
        assessmentHistoryInfoButton.widthAnchor.constraint(equalTo: weightGrowthChartInfoButton.widthAnchor).isActive = true
        assessmentHistoryInfoButton.heightAnchor.constraint(equalTo: weightGrowthChartInfoButton.heightAnchor).isActive = true
        assessmentHistoryInfoButton.rightAnchor.constraint(equalTo: assessmentHistoryButton.rightAnchor, constant: -10).isActive = true
        assessmentHistoryInfoButton.centerYAnchor.constraint(equalTo: assessmentHistoryButton.centerYAnchor).isActive = true
        
        updateChildButton.topAnchor.constraint(equalTo: assessmentHistoryButton.bottomAnchor, constant: 20).isActive = true
        updateChildButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        updateChildButton.heightAnchor.constraint(equalTo: weightGrowthChartButton.heightAnchor).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: updateChildButton.bottomAnchor, constant: 20).isActive = true
        
        view.layoutIfNeeded()
        
        heightGrowthChartButton.layer.cornerRadius = 15
        weightGrowthChartButton.layer.cornerRadius = 15
        assessmentHistoryButton.layer.cornerRadius = 15
        
    }
    
    func getAssessment(period: String){
        
        SVProgressHUD.show()
        RequestHelper.sharedInstance.getChildAssessment(period: period) { (response) in
            
            if(response["success"] as? Bool == true){
                SVProgressHUD.dismiss()
                self.assessment = response["assessment"] as! Assessment
                self.displayAssessmentValues()
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
            }
            
        }
        
    }
    
    @objc func segmentSelected(sender: UISegmentedControl){
        
        let index = sender.selectedSegmentIndex
        var period = "TODAY"
        
        //TODAY, YESTERDAY, LAST_WEEK, CURRENT_WEEK
        
        if(index == 0){
            period = "LAST_WEEK"
        }
        else if(index == 1){
            period = "YESTERDAY"
        }
        else if(index == 2){
            period = "CURRENT_WEEK"
        }
        
        getAssessment(period: period)
        
    }
    
    func displayAssessmentValues(){
        
//        guage.needleValue = 0
//        if(assessment.qcal_min + assessment.qcal_max != 0){
//            guage.needleValue = CGFloat(Utilities.sharedInstance.getGuageRatio(value: ( Double(assessment.qcal) / ( Double(assessment.qcal_min) + Double(assessment.qcal_max)) )))
//        }
        
        guage.needleValue = CGFloat(assessment.qcalToKCalRatioPct)

        adequacyMinLabel.text = String(assessment.diet_adequacy_min)
        adequacyMaxLabel.text = String(assessment.diet_adequacy_max)


        diversityMinLabel.text = String(assessment.diet_diversity_min)
        diversityMaxLabel.text = String(assessment.diet_diversity_max)


        adequacyBar.progressValue = 0 //CGFloat(assessment.diet_diversity)
        if(assessment.diet_adequacy_min + assessment.diet_adequacy_max != 0){
            adequacyBar.progressValue = CGFloat(( CGFloat(assessment.diet_adequacy) / ( CGFloat(assessment.diet_adequacy_min) + CGFloat(assessment.diet_adequacy_max)) ) * 100)
        }


        diversityBar.progressValue = 0 //CGFloat(assessment.diet_diversity)
        if(assessment.diet_diversity_min + assessment.diet_diversity_max != 0){
            diversityBar.progressValue = CGFloat(( CGFloat(assessment.diet_diversity) / ( CGFloat(assessment.diet_diversity_min) + CGFloat(assessment.diet_diversity_max)) ) * 100)
        }
        
        adequacyLabel.text = "Diet Adequacy: " + String(format: "%.2f", assessment.diet_adequacy)
        diversityLabel.text = "Diet Diversity: " + String(format: "%.2f",assessment.diet_diversity)
        
    }
    
    @objc func weightGrowthChartPressed(sender: UIButton){
        
        let webVC = HorizontalWebViewController()
//        UIWebView.loadRequest(webVC.webView)(NSURLRequest(url: NSURL(string: weightGrowthChartURL + "/" + String(appChild().id))! as URL) as URLRequest)
        
        webVC.webView.load(NSURLRequest(url: NSURL(string: weightGrowthChartURL + "/" + String(appChild().id))! as URL) as URLRequest)
        self.present(webVC, animated: true) {}
        
    }
    
    @objc func heightGrowthChartPressed(sender: UIButton){
        
        let webVC = HorizontalWebViewController()
//        UIWebView.loadRequest(webVC.webView)(NSURLRequest(url: NSURL(string: heightGrowthChartURL + "/" + String(appChild().id))! as URL) as URLRequest)
        webVC.webView.load(NSURLRequest(url: NSURL(string: heightGrowthChartURL + "/" + String(appChild().id))! as URL) as URLRequest)
        self.present(webVC, animated: true) {}
        
    }
    
    @objc func assessmentHistoryPressed(sender: UIButton){
        let webVC = HorizontalWebViewController()
//        UIWebView.loadRequest(webVC.webView)(NSURLRequest(url: NSURL(string: assessmentHistoryURL + "/" + String(appChild().id))! as URL) as URLRequest)
        webVC.webView.load(NSURLRequest(url: NSURL(string: assessmentHistoryURL + "/" + String(appChild().id))! as URL) as URLRequest)
        self.present(webVC, animated: true) {}
    }
    
    @objc func growthChartInfoPressed(sender: UIButton){
        self.present(DietAssessmentInfoViewController(), animated: true) {}
    }
    
    @objc func assessmentHistoryInfoPressed(sender: UIButton){
        self.present(DietAssessmentInfoViewController(), animated: true) {}
    }
    
    @objc func updateChild(sender: UIButton){
        self.navigationController?.pushViewController(ChildViewController(), animated: true)
    }
    
}
