<style>
img[src*="#icon"] {
   width:175px;
   height:175px;
}
</style>

<center>
![Icon](res/Hex Storage Icon.png#icon)

# Hex Storage
</center>

This library is designed to Application development by providing a simple and unified API for:

* Object Relationship Model Storage
* Key Value Storage
* **[🚧 WIP 🚧]** Block storage

With support for multiple backing technologies on multiple platforms.  

## Driver/OS Support Matrix

|         	| SQLite 	   | IndexDB 		| User Defaults  |  File System  |
|---------	|:------:	   |:-------:		|:-------------: |:-------------:|
| wasm    	|    X    	|    🚧    	|        X       |      TBD
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
import HexStorage

class User: Model {
    
    @Attribute var createdOn: Date

    @Attribute var name: String
    
    @NullableAttribute var viewedCounter: Double?
}
```

### Key Value Storage:

```swift
import HexStorage

class Settings {

    @KeyValue var
    
}

```
### **[🚧 WIP 🚧]** Block Storage:

(Coming Soon)
