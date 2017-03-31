//: Please build the scheme 'AlamofirePlayground' first
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)

import Alamofire

struct Pokemon {
    var id:Int
    var name:String
}


struct Resource<A> {
    
    let url:URL
    let parse:(Any) -> A?
    
}
typealias JSONDictionary = [String:AnyObject]
extension Resource {
    init(url: URL, parseJSON: ([JSONDictionary]) -> A? ) {
        self.url = url
        self.parse = { data in
            return nil
        }
    }
}


struct Media { }

let url = URL(string: "http://swapi.co/api/people/")!

struct MovieCharacter {

    var name:String
    
    static let all = Resource<[MovieCharacter]>(url: url, parseJSON: { json in
        guard let dictionaries = json as? [JSONDictionary] else { return nil }
        return dictionaries.flatMap(MovieCharacter.init)
    })
}

extension MovieCharacter {
    
    init?(dict: JSONDictionary) {
        guard let name = dict["name"] as? String else {
            return nil
        }
        self.name = name
    }
    
}

final class WebServices {
    
    func load<A>(resource:Resource<A>, completion: @escaping (A?)->())  {
        Alamofire.request( resource.url, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: ["Content-Type": "application/json"])
            .responseJSON { ( response ) in
            
            guard let value = response.result.value as? JSONDictionary, let results = value["results"] else {
                completion(nil)
                return
            }
                
            let arrayOfDict = results as! [JSONDictionary]
            let r = resource.parse(arrayOfDict)
            completion(r)
        }
    }
    
}

WebServices().load(resource: MovieCharacter.all) { (characters) in
    
}

/*
class PokedexViewController: UITableViewController {
    let pokemons: [Pokemon] = [
        Pokemon(id: 1, name: "Bulbasaur"),
        Pokemon(id: 2, name: "Ivysaur"),
        Pokemon(id: 3, name: "Venusaur"),
        Pokemon(id: 4, name: "Charmander"),
        Pokemon(id: 5, name: "Charmeleon"),
        Pokemon(id: 6, name: "Charizard"),
        Pokemon(id: 7, name: "Squirtle"),
        Pokemon(id: 8, name: "Wartortle"),
        Pokemon(id: 9, name: "Blastoise")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = UITableViewCell(style: .default, reuseIdentifier: "PokemonTableViewCell")
            
            let pokemon = pokemons[indexPath.row]
            cell.textLabel?.text = pokemon.name
            
            return cell
    }

    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let pokemon = pokemons[indexPath.row]
        let viewController = PokemonViewController(frame: tableView.frame, pokemon: pokemon)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

class PokemonViewController: UIViewController {
    private let pokemon: Pokemon
    
    init(frame: CGRect, pokemon: Pokemon) {
        self.pokemon = pokemon
        super.init(nibName: nil, bundle: nil)
        
        self.title = self.pokemon.name
        self.view = UIView(frame: frame)
        self.view.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let rootViewController = PokedexViewController()
rootViewController.title = "Pokedex"

let navigationController = UINavigationController(rootViewController: rootViewController)
PlaygroundPage.current.liveView = navigationController
*/
