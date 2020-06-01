//
//  COVIDViewController.swift
//  covidAI
//
//  Created by Parikshat Sawant on 5/18/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit

class COVIDViewController: UIViewController {
    @IBOutlet weak var AboutCOVID: UINavigationItem!
    
    @IBOutlet weak var AppDescription: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        AboutCOVID.title = "About COVIDClicks"
        navigationController?.navigationBar.prefersLargeTitles = true
        AboutCOVID?.largeTitleDisplayMode = .always
        AppDescription.numberOfLines = 25
        AppDescription.text = "COVID-19 has drastically changed our world in the last few months. One of the main problems facing countries has been the lack of testing kits available. COVIDClicks attempts to  help doctors and patients diagnose COVID-19 using Deep Learning and, specifically, Convolutional Neural Networks (CNN). This app also attempts to raise awareness to people by displaying the effects COVID-19 has on lungs.\n\n\n Have any questions or feedback? \n Reach out to COVIDClicks@Outlook.com \n \n Help us improve our model by emailing us your images! We greatly appreciate it!"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
