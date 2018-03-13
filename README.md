## Badger Networking

This is a networking library for Swift projects that provides a framework for building strongly typed object responses for api requests through the use of Swift generics.

### Overview
This library was designed to provide an easy and clean way to convert json responses from remote apis into local data model objects.

By creating local model objects that conform to the `JSONParsable` protocol you provide your own mapping logic to convert json to your local model. We contemplated using the `Codable` protocol available with Swift 4 but decided to use a custom implementation to provide more flexibility.

Using a custom implementation allows you to create model objects with relationship designs different than a remote api, which is useful in cases where:
* You don't control the remote api
* The json model of a remote api is more complex than your local model
* The json model contains information you don't need in your app model

See examples below.


### Setup
This library can be setup using Cocoapods, Swift Package Manager, or you can download this project as a zip and place the source files directly in your project.

#### Cocoapods
To use via cocoapods:
* create a file named 'Podfile' in the root level of your  Xcode project with the following contents
```Swift
    # Comment this line to define a global platform for your project
    platform :ios, '10.2'

    use_frameworks!

    source 'https://github.com/CocoaPods/Specs.git'

    target 'NetworkingSampleClient' do

    #    pod 'BadgerNetworking', '1.0.3'
        pod 'BadgerNetworking', :git => 'https://github.com/appteur/badger_networking', :branch => 'master'
    #    pod 'BadgerNetworking', :path => '../BadgerNetworking', :branch => 'master'

    inherit! :search_paths
    end
```
* Update the target name in the Podfile to match your project target name
* In terminal, cd into your project root directory and run `pod install`
* Close your Xcode project and launch Xcode using the newly generated xcworkspace file in your project root directory


#### Swift Package Manager
To use this library via Swift Package Manager you will need to:
* Create a Package.swift file in the root level of your Swift project
* Add this library as a dependency of your project
* Update the 'majorVersion' to whichever version you wish to use

```Swift
    import PackageDescription

    let package = Package(
        name: "SampleApi",
        targets: [],
        dependencies: [
            .Package(url: "https://github.com/appteur/badger_networking.git", majorVersion: 1)
        ]
    )
```

Once added to your dependencies you will either need to install or update your package dependencies.


### Usage
Once you've setup your project dependencies, you will create a class to act as the api router for the remote api you will be accessing.

#### Routing
A router object specifies the http method to use, the uri for the request and any custom request modifiers (if needed).

It could look similar to the following:

```Swift

enum MyRouter: NetworkRequestRouter {

    // define routes here as additional cases
    case login
    case productList

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
        case .login:        return "/v1/user/login"
        case .productList:  return "/v1/products"
        }
    }

    // You can define custom request modifiers for any route here. These request
    // modifiers could add headers, provide authentication, modify the body
    // or perform any custom logic.
    var requestModifiers: [NetworkRequestModifier] {

        // create an array for any required modifiers
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

#### Network Interface
Once you have routes setup and configured you'll need to create your internal app network interface. This interface will allow your Swift code to call your network interface with parameters and a completion block to run when the request completes.

This class will conform to the `NetworkRequestProvider` protocol which provides access to the `handle` function, and specifies a remote configuration and network layer for processing requests.

A sample implementation would look something like this:

```Swift

    import Foundation
    import BadgerNetworking

    class Remote: NetworkRequestProvider {
    
        /// The configuration object specifying the remote host... etc
        var configuration: RemoteConfig
        
        /// A reference to the class handling the network requests.
        var networkLayer: NetworkRequestHandler!

        init(configuration: RemoteConfig) {
        
            // set configuration
            self.configuration = configuration

            // setup network session, passing in configuration object
            networkLayer = NetworkSession.init(configuration: configuration)
        }
        
        /// Logs in a user, provided an email address and password.
        ///
        /// - Parameters:
        ///   - email: The users email address
        ///   - password: The users password
        ///   - completion: Completion block, on success the user object will be populated and error will be nil, else user will be nil and error will be set.
        func login(email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
            handle(
                route: MyRouter.login,         // specifies the uri and other info for this request
                responseType: User.self,     // specifies the model object type expected to be received
                params: [                // provide request parameters
                    "email" : email,
                    "password" : password
                ]
                headers: [:],                 // provide custom headers (if empty this can be left off)
                completion: completion        // completion handler
            )
        }
        
        /// Fetches a list of products. 'ProductList' is a model object with a `var products: [Product]?` property.
        ///
        /// - Parameter completion: Completion block, on success the ProductList object will be populated and error will be nil, else the ProductList will be nil and the error object set with the corresponding error.
        func getProductList(completion: @escaping (ProductList?, Error?) -> Void) {
            handle(
                route: Router.products,
                responseType: ProductList.self,
                parameters: nil,
                completion: completion
            )
        }
    }


```

Functions for additional network requests would be added to this class and follow the pattern illustrated in the example.


#### Model Object Mapping
This library is designed to make it so you can specify the api route you want and the model object you expect to receive for a successful request.

To handle this you need to make model objects conform to the `JSONParsable` protocol and map the remote json schema to your model objects.

A model object conforming to the protocol would look something like this:

```Swift

// definition of JSONParsable protocol here for reference purposes only
public protocol JSONParsable {
    associatedtype ParsedObject
    static func parseJSON(json: [String: Any]) -> ParsedObject?
}

// User sample model object
// An implementation such as this could be specified as the expected model type to receive
// back from an api request. The library handles the creation of this model object for a
// successful response from an api request to the login endpoint.
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


#### Usage
With your router, network interface and router in place you can setup your remote network class and call it to handle requests something like this:

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
