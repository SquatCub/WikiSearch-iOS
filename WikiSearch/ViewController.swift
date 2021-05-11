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
        
        if let urlImage = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Wiki-black.png/657px-Wiki-black.png") {
            webView.load(URLRequest(url: urlImage))
        }
    }
    
    @IBAction func buscarBtn(_ sender: Any) {
        buscarTextField.resignFirstResponder()
        guard let palabra = buscarTextField.text else { return }
        buscarWiki(palabras: palabra)
    }
    func buscarWiki(palabras: String) {
        if let urlAPI = URL(string: "https://es.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&titles=\(palabras.replacingOccurrences(of: " ", with: "%20"))") {
            let peticion = URLRequest(url: urlAPI)
            let tarea = URLSession.shared.dataTask(with: peticion) { (datos, respuesta, err) in
                if err != nil {
                    print(err?.localizedDescription)
                } else {
                    do {
                        let objJson = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        // Haciendo Subconsulta a la respuesta
                        let querySubJson = objJson["query"] as! [String: Any]
                        let pagesSubJson = querySubJson["pages"] as! [String: Any]
                        let pageKeys = pagesSubJson.keys
                        let pageID = pageKeys.first!
                        if pageID != "-1" {
                            let idSubJSon = pagesSubJson[pageID] as! [String: Any]
                            let extracto = idSubJSon["extract"] as? String
                            
                            // Imprimir en la UI
                            DispatchQueue.main.async {
                                self.webView.loadHTMLString(extracto ?? "<h1>No se obtuvieron resultados</h1>", baseURL: nil)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.webView.loadHTMLString("<h1>No se obtuvieron resultados para la palabra: \(palabras)</h1>", baseURL: nil)
                            }
                        }
                        
                    } catch {
                        print("Error")
                    }
                }
            }
            tarea.resume()
        }
        
        
    }


}

