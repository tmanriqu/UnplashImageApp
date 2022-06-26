//
//  HomeViewController.swift
//  UnsplashImageApp
//
//  Created by Tavi Danner Manrique Nestarez on 22/06/22.
//

import UIKit

class HomeViewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 300,
                height: 100
            )
        )
        label.textAlignment = .center
        //label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "FAVORITE SCREEN"
        return label
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        view.addSubview(titleLabel)
        titleLabel.center = view.center

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
