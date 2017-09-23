//
//  ViewController.swift
//  AbstractionKitSample
//
//  Created by Yuya Hirayama on 2017/09/24.
//  Copyright © 2017年 Yuya Hirayama. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            let identifier = "cell"
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
            forecasts.asObservable()
                .flatMap { Observable.from(optional: $0) }
                .bind(to: tableView.rx.items(cellIdentifier: identifier, cellType: UITableViewCell.self)) { row, element, cell in
                    cell.textLabel?.text = "\(element.dateStr): \(Int(element.temperatureInFahrenheit))°F"
            }
            .disposed(by: bag)
        }
    }

    private let forecasts = Variable<[Forecast]?>.init(nil)

    private let bag = DisposeBag.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        Abstraction.forecast(cityName: "München", countryCode: "DE")
            .asObservable()
            .bind(to: forecasts)
            .disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

