//
//  ViewController.swift
//  WikiSearch
//
//  Created by Brandon Rodriguez Molina on 06/05/21.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var buscarTextField: UITextField!
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buscarBtn(_ sender: Any) {
        guard let palabra = buscarTextField.text else { return }
        buscarWiki(palabras: palabra)
    }
    func buscarWiki(palabras: String) {
        if let urlAPI = URL(string: "https://es.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&titles=\(palabras)") {
            let peticion = URLRequest(url: urlAPI)
            let tarea = URLSession.shared.dataTask(with: peticion) { (datos, respuesta, err) in
                if err != nil {
                    print(err?.localizedDescription)
                } else {
                    do {
                        let objJson = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers as AnyObject as! JSONSerialization.ReadingOptions)
                        print("El objeto JSON es \(objJson)")
                    } catch {
                        print("Error")
                    }
                }
            }
            tarea.resume()
        }
        
        
    }


}

