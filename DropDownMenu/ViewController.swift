//
//  ViewController.swift
//  DropDownMenu
//
//  Created by Алексей Пархоменко on 18.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

enum Colors: Int, CaseIterable {
    case purple
    case red
    case green
    
    var description: String {
        switch self {
        case .purple:
            return "Purple"
        case .red:
            return "Red"
        case .green:
            return "Green"
        }
    }
    
    var color: UIColor {
        switch self {
        case .purple:
            return UIColor.purple
        case .red:
            return UIColor.red
        case .green:
            return UIColor.green
        }
    }
}

class ViewController: UIViewController {
    
    var tableView: UITableView!
    var showMenu = false
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Selectors
    @objc func handleDropDown() {
        showMenu = !showMenu
        var indexPaths = [IndexPath]()
        Colors.allCases.forEach { (color) in
            let indexPath = IndexPath(item: color.rawValue, section: 0)
            indexPaths.append(indexPath)
        }
        
        if showMenu {
            tableView.insertRows(at: indexPaths, with: .fade)
        } else {
            tableView.deleteRows(at: indexPaths, with: .fade
            )
        }
    }
    
    // MARK: - Helper Funcs
    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 50
        
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        tableView.register(DropDownCell.self, forCellReuseIdentifier: DropDownCell.reuseId)
    }


    // MARK: - UITableViewDelegate, UITableViewDataSource
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle("Select Color", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleDropDown), for: .touchUpInside)
        button.backgroundColor = .blue
        return button
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showMenu ? Colors.allCases.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropDownCell.reuseId, for: indexPath) as! DropDownCell
        cell.titleLabel.text = Colors(rawValue: indexPath.row)?.description
        cell.backgroundColor = Colors(rawValue: indexPath.row)?.color
        return cell
    }
}

