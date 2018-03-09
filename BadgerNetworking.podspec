Pod::Spec.new do |s|

s.name         		= "BadgerNetworking"
s.version      		= "1.0.3"
s.summary      		= "Badger Networking"
s.description  		= "Swift networking library"
s.homepage     		= "https://github.com/appteur/badger_networking.git"
s.license     		= { :type => 'INTERNAL', :file => 'LICENSE' }
s.author    		= "Seth Arnott"
s.platform    		= :ios, "9.0"
s.source      		= { :git => "https://github.com/appteur/badger_networking.git", :branch => 'master', :tag => "#{s.version}" }
s.source_files  	= "Sources", "Sources/**/*.{h,m,swift,xcdatamodeld,xcdatamodel}"


end
