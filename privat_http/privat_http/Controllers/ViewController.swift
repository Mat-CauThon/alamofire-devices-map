//
//  ViewController.swift
//  privat_http
//
//  Created by Roman Mishchenko on 9/27/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//

import UIKit
import Alamofire
import CoreData


let headers: HTTPHeaders = [
    "Authorization": "Basic VXNlcm5hbWU6UGFzc3dvcmQ=",
    "Accept": "application/json"
]


class ATMCellClass: UITableViewCell {
    @IBOutlet weak var atmTitle: UILabel!
}

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var addMenuButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var menu: UIView!
    @IBOutlet var menuHeigthConstraint: NSLayoutConstraint!
    @IBOutlet var menuOpenWidth: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var field: UITextField!
    private var newCity: UIButton!
    private var cityField: UITextField!

    private var menuIsOpen = false
       
    private var query = ""
    private var filtered = [Device]()
       
       
    private let context = PersistentService.persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<Device>!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Details" {
            if let index = sender as? IndexPath {
                let pvc = segue.destination as! DeviceViewController
                let device = fetchedRC.object(at: index)
                pvc.device = device
                
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private var favoriteCheck = false
    @IBAction func favoriteAction(_ sender: Any) {
        
          
            if !self.favoriteCheck {
                self.query = "\u{7}"
                self.refresh()
                self.favoriteButton.setTitleColor(UIColor.white, for: .normal)
                self.tableView.reloadData()
                self.favoriteCheck = !self.favoriteCheck
                
            } else {
                self.query = ""
                self.refresh()
                self.favoriteButton.setTitleColor(UIColor(red:0.36, green:0.62, blue:0.10, alpha:1.0), for: .normal)
                self.tableView.reloadData()
                self.favoriteCheck = !self.favoriteCheck
            }
        
        
    }
    
    
    @IBAction func addMenu(_ sender: Any) {
        let queue = DispatchQueue.global(qos: .userInteractive)
        queue.sync {
            self.menuIsOpen = !self.menuIsOpen
            self.menuHeigthConstraint.constant = self.menuIsOpen ? 200 : 44
                   //barHeigthBig.constant = !menuIsOpen ? 712 : 512
                   //field.resignFirstResponder()
                   
                   UIView.animate(
                       withDuration: 0.33,
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations: {
                           let angle: CGFloat = self.menuIsOpen ? .pi : 0.0
                           self.addMenuButton.transform = CGAffineTransform(rotationAngle: angle)
                           self.view.layoutIfNeeded()
                           
                   },
                       completion: nil)
        }
       
    }
    
    
}
        
        
        
    




extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedRC.fetchedObjects?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite =  favoriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "Details", sender: indexPath)
    }
    
    func favoriteAction(at indexPath: IndexPath) -> UIContextualAction {
        let obj = fetchedRC.object(at: indexPath)
        let action = UIContextualAction(style: .normal, title: "Favorite") { (action, view, completion) in
            if !obj.favorite {
                obj.favorite = !obj.favorite
               
                obj.fullAddressRu?.insert("\u{7}", at: obj.fullAddressRu!.startIndex)
                completion(true)
            } else {
                obj.favorite = !obj.favorite
                
                obj.fullAddressRu?.remove(at: obj.fullAddressRu!.startIndex)
                completion(true)
            }
            PersistentService.saveContext()
            
            self.refresh()
            self.tableView.reloadData()
           
        }
        action.image = UIImage(systemName: "star.fill")
        action.backgroundColor = obj.favorite ? .gray : UIColor(red:0.36, green:0.62, blue:0.10, alpha:1.0)
        return action
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Atm item", for: indexPath) as! ATMCellClass
        let object = fetchedRC.object(at: indexPath)
        cell.atmTitle.text = object.fullAddressRu
        self.cityField.text = object.cityRU
        if object.favorite {
            cell.atmTitle.textColor = UIColor(red:0.36, green:0.62, blue:0.10, alpha:1.0)
        } else {
            cell.atmTitle.textColor = UIColor.white
        }
        return cell
    }
    
    private func makeField(field: UITextField, name: String) {
        
       
        field.backgroundColor = UIColor(red:0.16, green:0.16, blue:0.15, alpha:1.0)
        field.minimumFontSize = 30
        field.layer.cornerRadius = 5
       
        field.attributedPlaceholder = NSAttributedString(string: name,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        field.textColor = UIColor.white
        field.isEnabled = true
        field.translatesAutoresizingMaskIntoConstraints = false
        self.menu.addSubview(field)
        
        
    }
    

    func makeSlider() {
        
       
        let rect = CGRect(x: 0, y: 0, width: 600, height: 140)
        
//        cityLabel = UILabel(frame: rect)
//        cityLabel.textColor = UIColor(red:0.36, green:0.62, blue:0.10, alpha:1.0)
//        menu.addSubview(cityLabel)
//
//        addConstraint(item: cityLabel!, itemTo: menu!, constant: 20, atributeOne: NSLayoutConstraint.Attribute.top, atributeTwo: NSLayoutConstraint.Attribute.top)
//        addConstraint(item: cityLabel!, itemTo: menu!, constant: 20, atributeOne: NSLayoutConstraint.Attribute.left, atributeTwo: NSLayoutConstraint.Attribute.left)
        
        cityField = UITextField(frame: rect)
        cityField.borderStyle = .roundedRect

        makeField(field: cityField, name: "Укажите ваш город")
        cityField.delegate = self
        cityField.returnKeyType = .continue
        addConstraint(item: cityField!, itemTo: menu!, constant: 20, atributeOne: NSLayoutConstraint.Attribute.left, atributeTwo: NSLayoutConstraint.Attribute.left)
        addConstraint(item: cityField!, itemTo: menu!, constant: 130, atributeOne: NSLayoutConstraint.Attribute.top, atributeTwo: NSLayoutConstraint.Attribute.top)
        
        //constrait
        
        
        
        let buttonRect = CGRect(x: menu.frame.size.width - 120, y: 130, width: 100, height: cityField.bounds.size.height/4)
        newCity = UIButton(frame: buttonRect)
        newCity.setTitle("Выбрать", for: .normal)
        newCity.setTitleColor(UIColor(red:0.36, green:0.62, blue:0.10, alpha:1.0), for: .normal)
        newCity.backgroundColor = UIColor(red:0.16, green:0.16, blue:0.15, alpha:1.0)
        newCity.tintColor = UIColor(red:0.36, green:0.62, blue:0.10, alpha:1.0)
        newCity.isEnabled = true
        newCity.isHidden = false
        
        newCity.addTarget(self, action: Selector(("saveCity")), for: UIControl.Event.touchUpInside)
        
        newCity.layer.cornerRadius = 10
        self.menu.addSubview(newCity)
        
      //  addConstraint(item: newCity!, itemTo: menu!, constant: 150, atributeOne: NSLayoutConstraint.Attribute.top, atributeTwo: NSLayoutConstraint.Attribute.top)
        addConstraint(item: cityField!, itemTo: newCity!, constant: -20, atributeOne: NSLayoutConstraint.Attribute.right, atributeTwo: NSLayoutConstraint.Attribute.left)
        
//        self.menu.addSubview(progress)
        
        //addConstraint(item: progress!, itemTo: newCity!, constant: -90, atributeOne: NSLayoutConstraint.Attribute.right, atributeTwo: NSLayoutConstraint.Attribute.left)
        
        
        
        
    }
    
    @IBAction func saveCity() {
        
        self.newCity.pulsate()
        self.indicator.isHidden = false
        let queue = DispatchQueue.global(qos: .utility)
        
            if self.cityField.text?.count ?? 0 < 3 {
                let alert = UIAlertController(title: "Неверно указано название города", message: "Пожалуйста проверьте корректность данных", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in }))
                self.present(alert, animated: true, completion: nil)
            } else {
                
                    let url = "https://api.privatbank.ua/p24api/infrastructure?atm&address=&city=\(self.cityField.text ?? "Киев")"
                   
                    queue.async{
                    let safeURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    
                
                    request(safeURL, method: .get, encoding: URLEncoding.default, headers: headers)
                                        
                    .validate()
                    .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                       // print("Progress: \(progress)")
                        //не работает для полосы загрузки, Parent: 0x0 (portion: 0) / Fraction completed: 0.0000 / Completed: 436209 of -1
                    }
                                    
                    .responseJSON { (response) in
                    
                                        
                    switch response.result {
                        case .success(let value):
                        
                        let moc = PersistentService.context
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
                        let result = try? moc.fetch(fetchRequest)
                        let resultData = result as! [Device]
                        for object in resultData {
                            moc.delete(object)
                        }
                        do {
                            try self.context.save()
                            print("saved!")
                        } catch let error as NSError {
                            print("Could not save \(error), \(error.userInfo)")
                        } catch {}
                        self.refresh()
                        self.tableView.reloadData()
                        
                        guard let bankDict = value as? [String: Any] else {return}
                        guard let city = bankDict["city"] as? String else {return}
                        guard let deviceDict = bankDict["devices"] as? [Any] else {return}
                                      
                        self.cityField.text = city
                        if deviceDict.count == 0 {
                           let alert = UIAlertController(title: "Неверно указано название города", message: "Пожалуйста проверьте корректность данных", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in }))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        for device in deviceDict {
                                      
                            let data = Device(entity: Device.entity(), insertInto: self.context)
                                              
                            guard let deviceParam = device as? [String: Any] else {return}
                            guard let cityRU = deviceParam["cityRU"] as? String else {return}
                            guard let cityUA = deviceParam["cityUA"] as? String else {return}
                            guard let cityEN = deviceParam["cityEN"] as? String else {return}
                                          
                            guard let fullAddressRu = deviceParam["fullAddressRu"] as? String else {return}
                            guard let fullAddressUa = deviceParam["fullAddressUa"] as? String else {return}
                            guard let fullAddressEn = deviceParam["fullAddressEn"] as? String else {return}
                                          
                            guard let placeRu = deviceParam["placeRu"] as? String else {return}
                            guard let placeUa = deviceParam["placeUa"] as? String else {return}
                                          
                            guard let latitude = deviceParam["latitude"] as? String else {return}
                            guard let longitude = deviceParam["longitude"] as? String else {return}
                            guard let type = deviceParam["type"] as? String else {return}
                                              
                                        
                            let normalArdess = fullAddressRu.split(separator: ",")
                            var adress = " "
                            var number = 0
                            
                            for i in 0...(normalArdess.count-1) {
                                if normalArdess[i].split(separator: " ").first == "город" || normalArdess[i].split(separator: " ").first == "пгт" || normalArdess[i].split(separator: " ").first == "село"{
                                    number = i+1
                                    break
                                }
                            }
                                              
                            for i in number...(normalArdess.count-1) {
                                adress += normalArdess[i] + ", "
                            }
                                              // = normalArdess[normalArdess.count-2] + ", " + normalArdess[normalArdess.count-1]
                                              
                            adress.removeLast()
                            adress.removeLast()
                            
                          //  adress.removeLast()
                            data.cityRU = cityRU
                            data.cityUA = cityUA
                            data.cityEN = cityEN
                            data.fullAddressRu = String(adress)
                            data.fullAddressUa = fullAddressUa
                            data.fullAddressEn = fullAddressEn
                            data.placeRu = placeRu
                            data.placeUa = placeUa
                            data.latitude = latitude
                            data.longitude = longitude
                            data.type = type
                            data.favorite = false
                            
                            guard let tw = deviceParam["tw"] as? [String: String] else {return}
                            guard let mon = tw["mon"] else {return}
                            guard let tue = tw["tue"] else {return}
                            guard let wed = tw["wed"] else {return}
                            guard let thu = tw["thu"] else {return}
                            guard let fri = tw["fri"] else {return}
                            guard let sat = tw["sat"] else {return}
                            guard let sun = tw["sun"] else {return}
                            guard let hol = tw["hol"] else {return}
                                             
                            data.mon = mon
                            data.tue = tue
                            data.wed = wed
                            data.thu = thu
                            data.fri = fri
                            data.sat = sat
                            data.sun = sun
                            data.hol = hol
                                             
                                             
                            PersistentService.saveContext()
                                         
                                
                        }
                       
                        self.refresh()
                        self.tableView.reloadData()
                        self.indicator.isHidden = true
                        break
                        case .failure(let error):
                            
                             let alert = UIAlertController(title: "Отсутствует интернет подключение", message: "Пожалуйста проверьте ваше интернет соединение", preferredStyle: .alert)
                                                       alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in }))
                                                       self.present(alert, animated: true, completion: nil)
                            print(error)
                         self.indicator.isHidden = true
                    }
                       
                                    
                    }
                }
                
            
        }
        
        
        
       
}
    
    
    private func addConstraint(item: Any, itemTo: Any, constant: CGFloat, atributeOne: NSLayoutConstraint.Attribute, atributeTwo: NSLayoutConstraint.Attribute) {
        NSLayoutConstraint(item: item, attribute: atributeOne, relatedBy: NSLayoutConstraint.Relation.equal, toItem: itemTo, attribute: atributeTwo, multiplier: 1, constant: constant).isActive = true
        
    }
    
    
    
    private func refresh() {
        let request = Device.fetchRequest() as NSFetchRequest<Device>
        if !query.isEmpty {
            request.predicate = NSPredicate(format: "fullAddressRu CONTAINS[cd] %@", query)
        }
        let sort = NSSortDescriptor(key: #keyPath(Device.fullAddressRu), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // indicator.isAnimating = true
        indicator.isHidden = true
        makeSlider()
       
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let txt = searchBar.text else {
            return
        }
        query = txt
        refresh()
        searchBar.resignFirstResponder()
        tableView.reloadData()
        //tableView.reloadData()
        
    }
    
}
extension ViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     
        guard let txt = searchBar.text else {
            return
        }
        query = txt
        refresh()
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        query = ""
        searchBar.text = nil
        searchBar.resignFirstResponder()
        refresh()
        tableView.reloadData()
    }
}
