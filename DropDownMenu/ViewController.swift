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
    var showMenu = true
    
    let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(colorView)
        colorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        colorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        colorView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        setupTableView()
    }
    
    
    
    // MARK: - Selectors
    @objc func handleDropDown() {
        showMenu = !showMenu
        var indexPaths = [IndexPath]()
        Colors.allCases.forEach { (color) in
            print(color.rawValue)
            let indexPath = IndexPath(item: color.rawValue, section: 0)
            indexPaths.append(indexPath)
        }
        
        if showMenu {
            tableView.insertRows(at: indexPaths, with: .fade)
        } else {
            
            
            tableView.deleteRows(at: indexPaths, with: .fade)
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
        
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        
        tableView.register(DropDownCell.self, forCellReuseIdentifier: DropDownCell.reuseId)
    }


    // MARK: - UITableViewDelegate, UITableViewDataSource
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle("Select Color", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleDropDown), for: .touchUpInside)
        button.backgroundColor = .blue
        return button
    }
    

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let color = Colors(rawValue: indexPath.row) else { return }
        colorView.backgroundColor = color.color
        switch indexPath.row {
        case 0:
            print("rere")
            tableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
        default:
            print("rerfdfde")
        }
    }
}

