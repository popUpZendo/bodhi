//
//  SanghaVC.swift
//  bodhi
//
//  Created by Joseph Hall on 10/31/17.
//  Copyright © 2017 Joseph Hall. All rights reserved.
//

import UIKit

class SanghaVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var testButton: UIButton!
    
    
    var bodhiArray = [Bodhi]()
    var testArray = [Bodhi] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController()  .tapGestureRecognizer())
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        DataService.instance.getAllBodhi { (returnedBodhiArray) in
//            //self.bodhiArray = returnedBodhiArray.reversed()
//            self.tableView.reloadData()
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.REF_BODHI.observe(.value) { (snapshot) in
            DataService.instance.getAllBodhi { (returnedBodhiArray) in
                self.bodhiArray = returnedBodhiArray
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func testButton(_ sender: Any) {
        print(bodhiArray)
    }
    
}

extension SanghaVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bodhiArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "sanghaCell") as? SanghaCell else { return UITableViewCell() }
        let image = UIImage(named: "defaultProfileImage")
        let bodhi = bodhiArray[indexPath.row]
        
        DataService.instance.getAllBodhi { (returnedBodhi) in
            cell.configureSanghaCell(profileImage: image!, name: bodhi.name, popUpGroup: bodhi.popUpGroup, city: bodhi.city, state: bodhi.state, temple: bodhi.temple, teacher: bodhi.teacher, practice: bodhi.teacher)
        }
        return cell
    }
}

