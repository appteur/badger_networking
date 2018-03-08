## Badger Networking

This is a networking library for Swift projects that provides a framework for building strongly typed object responses for api requests through the use of Swift generics.

When implemented your api requests would look similar to this:

```Swift

	func login(email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        handle(
        	route: MyRouter.login, 		// specifies the uri and other info for this request
        	responseType: User.self, 	// specifies the model object type expected to be received
        	params: [				// provide request parameters
        		"email" : email,
        		"password" : password
        	]
        	headers: [:], 				// provide custom headers (if empty this can be left off)
        	completion: completion		// completion handler
        )
    }

```

### Model Object Mapping
This library is designed to make it so you can specify the api route you want and the object you expect to receive back for a successful request. To handle this you need to make model objects returned from api requests conform to the JSONParsable protocol and map the remote json schema to your model objects. 

This allows for greater flexibility if you want your local model to be different from the api model, or in cases where you do not control the remote model and do not want to match it 1:1 as you would have to do using the Codable protocol.

A model object conforming to the protocol would look something like this:

```Swift

// definition of JSONParsable protocol
public protocol JSONParsable {
    associatedtype ParsedObject
    static func parseJSON(json: [String: Any]) -> ParsedObject?
}

// User example model object
// An implementation such as this could be specified as the expected model type to receive
// back from an api request. The library handles the creation of this model object in the
// case of a successful response from an api request to the login endpoint.
class User: JSONParsable {

    // model object properties
	var identifier: String?
	var name: String?

    // map the ParsedObject associatedtype to this class
    typealias ParsedObject = User
    
    // conform to the protocol, provide this model type as the return type
    static func parseJSON(json: [String : Any]) -> User.ParsedObject? {
        
        // create an instance of this model to return
        let user = User()
        
        // parse user values, this assumes a json dictionary top level object in the response
        user.identifier = json["id"] as? String
        user.name = json["name"] as? String
        
        return user
    }
}

```

### Routing
To provide routes for the networking library to use you will need to create a router. This will include the http method to use, the uri for the request and any custom request modifiers (if needed). 

It could look similar to the following:

```Swift

enum MyRouter: NetworkRequestRouter {
    
    // define routes here as additional cases
    case login
    
    // defines the type of http method to use for each request, defaults to .get
    var method: HttpMethod {
        switch self {
        case .login:  return .post
        default:      return .get
        }
    }
    
    // provide the uri for each route
    var uri: String {
        switch self {
        case .login:     return "/v1/user/login"
        }
    }
    
    // You can define custom request modifiers for any route here. These request
    // modifiers could add headers, provide authentication, modify the body
    // or do anything you specify.
    var requestModifiers: [NetworkRequestModifier] {

    	// create an array for any necessary modifiers
        var modifiers: [NetworkRequestModifier] = []
        
        // set any modifiers required for an endpoint
        switch self {
        case .login:
            modifiers.append(CustomAuthModifier())
        }
        
        return modifiers
    }
}


```

### Network Interface
Once you have routes setup and configured you'll need to create your internal app network interface. This interface will allow your Swift code to call your network interface with parameters and a completion block to run when the request completes. 

This class will conform to the 'NetworkRequestProvider' protocol and pull together any info needed to make the request.

It could look something like this:

```Swift

class MyNetwork: NetworkRequestProvider {

    var configuration: RemoteConfig
    var networkLayer: NetworkRequestHandler!
    
    //MARK: - Init & Setup
    init(config: RemoteConfig) {
        
        // setup configuration
        configuration = config
        
        // setup network session
        networkLayer = NetworkSession.init(configuration: configuration)
    }
    
    func login(email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        handle(
        	route: MyRouter.login, 
        	responseType: User.self, 
        	params: [
        		"email" : email,
        		"password" : password
        	]
        	headers: [:], 
        	completion: completion
        )
    }
}

```

### Usage
With your network interface in place, you can setup and call it to handle requests something like this:

```Swift

// create remote configuration object
let remoteConfig = RemoteConfig.init(basePath: "https://api.some_domain.com")

// initialize network with configuration object.
let network = MyNetwork.init(config: remoteConfig)

network.login("some@email.com", "strongPassword", completion: { [weak self] (user, error) in
	guard let strongself = self, let user = user, error == nil else {
		// handle error here
		return
	}

	// do something with user here
	DispatchQueue.main.async {
		strongself.labelName.text = user.name
	}
})


```
