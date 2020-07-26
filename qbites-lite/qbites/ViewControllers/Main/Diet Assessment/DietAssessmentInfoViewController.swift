//
//  DietAssessmentInfoViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 3/16/20.
//  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit

class DietAssessmentInfoViewController: UIViewController {
    
    var infoText = "<p><strong>qCal</strong></p>\r\n<p>The quality kilocalorie (qCal) is a unit of measure created by us and peer reviewed in scientific literature.&nbsp; The qCal is a measure used to distinguish between food items in a food group in terms of their caloric energy and relative nutrient density.&nbsp; As a measure of overall diet, the qCal meter indicates whether prevailing food item selections are high quality, moderate quality, or poor quality.&nbsp; For ease of use, meals in the meal plan are marked with a gold medal for highest qCal values, silver medal for the next highest ranked foods, bronze medal, and unranked so that you can make healthy meal choices more easily as a parent.</p>\r\n<p>&nbsp;</p>\r\n<p><strong>MAD</strong></p>\r\n<p>The Minimum Acceptable Diet (MAD) measures the feeding frequency and dietary diversity for children aged 6-23 months, apart from breast milk.&nbsp; The indicator consists of 6 food groups and is measured on a daily basis.&nbsp; Scores of 4 or higher is considered good.&nbsp; MAD was developed by the World Health Organization (WHO).&nbsp;</p>\r\n<p>&nbsp;</p>\r\n<p><strong>MDD</strong></p>\r\n<p>The Minimum Diet Diversity (MDD) measures the minimum dietary diversity for children aged 6-23 months.&nbsp; The indicator consists of 7 food groups, and is calculated on a daily basis.&nbsp; A daily score of 4 or higher is considered good.&nbsp; MDD was developed by the World Health Organization (WHO).</p>\r\n<p>&nbsp;</p>\r\n<p><strong>HEI</strong></p>\r\n<p>The Healthy Eating Index (HEI) is a measure of diet quality.&nbsp; Developed in the United States by the United States Department of Agriculture Food and Nutrition Service (USDA-FNS), the HEI assesses how well a person&rsquo;s foods consumed align with the Dietary Guidelines for Americans.&nbsp; These dietary guidelines are similar to dietary guidelines used internationally, and the HEI is widely used internationally as an indicator of overall diet quality.&nbsp; The HEI ranges from 0-100 with scores &gt; 80 indicating a good diet, 51-80 indicating a diet needing improvement, and &lt; 51 indicating a poor diet.</p>\r\n<p>&nbsp;</p>\r\n<p><strong>IDDS</strong></p>\r\n<p>The individual dietary diversity score (IDDS) is a measure of dietary diversity developed by the Food and Agricultural Organization of the United Nations (FAO).&nbsp; Our version has been adapted to children and ranges from 0-12, with higher scores indicating a better, more diverse diet and lower scores indicating a less diverse diet.</p>"
    
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
    
    let descriptionContentLabel: UILabel = {
        
        let textView = UILabel()
        textView.textColor = .black
        textView.numberOfLines = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    
        self.view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        contentView.addSubview(descriptionContentLabel)
        
        let descriptionAttributedText = infoText.htmlAttributedString() as! NSMutableAttributedString
        descriptionContentLabel.attributedText = descriptionAttributedText
        descriptionContentLabel.textColor = .black
        
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
    
        descriptionContentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        descriptionContentLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        descriptionContentLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: descriptionContentLabel.bottomAnchor, constant: 30).isActive = true
    }
    
}
