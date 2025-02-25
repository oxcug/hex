# Storage

![Swift](https://github.com/oxcug/hex/actions/workflows/swift.yml/badge.svg)

**[🚧 WIP 🚧]** NOTE: This library is still under development but would appreciate any/all feedback!.

Storage is a general purpose library that bridges multiple usecases:
* Internal large memory representation of data
* Object Relationship Model Storage
* Key Value Storage
* Block / Binary Storage

With the following high-level features:

* Local Data Persistence
* Cloud Data Persistence
* Peer To Peer Data Sharing
* Public Data Sharing 
* E2EE
* HIPPA Compliance

With support for multiple backing technologies on multiple platforms, this library is defined to dramatically reduce the amount of time spent picking and using ORMs, KVs, or Block / Binary oriented data.

## Driver/OS Support Matrix

|         	| SQLite 	   | IndexDB 		| User Defaults  |  File System  |
|---------	|:------:	   |:-------:		|:-------------: |:-------------:|
| WASI    	|    N/A    	|    🚧    	|        N/A       |      TBD
| Linux   	|    🚧    	|     X    	|        X       |      TBD
| Windows 	|    🚧   	|     X   	|        X       |      TBD
| watchOS 	|    ✅   	|     X    	|       ✅       |      TBD
| tvOS    	|    ✅   	|     X    	|       ✅       |      TBD
| iOS     	|    ✅   	|     X    	|       ✅       |      TBD
| macOS   	|    ✅   	|     X    	|       ✅       |      TBD

## Features Matrix

|         	  | SQLite 	| IndexDB 	| User Defaults  |  File System  |
|---------	  |:------:	|:-------:	|:-------------: |:-------------:|
| KV Store     |         	|       		|      ✅        |      TBD
| ORM Store    |   ✅  	|        		|                |      TBD
| Block  Store |   TBD    	| 	  TBD    	|      TBD       |      TBD



**Legend:**

🚧 - Actively In Development

✅ - Support Added

X - Incompatible

TBD -  Development has not been planned but is desired.


## Examples:

Here are a few code snippets of what you can do with this library:


### Object Relational Model Storage:

```swift
import Storage

class User: Model {
    
    @Attribute var createdOn: Date

    @Attribute var name: String
    
    @NullableAttribute var viewedCounter: Double?
}
```

### Key Value Storage:

```swift
import Storage

class Settings {

    @KeyValue var shouldDisplayOnboarding: Bool
    
}

```
### **[🚧 WIP 🚧]** Block Storage:

(Coming Soon)
