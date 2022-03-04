//
//  Debug.swift
//
//
//  Created by Cristian Carlassare.
//

import Foundation


private enum DebugType {
    case info
    case success
    case error
}


public class Debug: NSObject {

    private override init() {  super.init()  }
    static var printLogIntoDevice = false
    
    
    // This method prints any object received by parameter
    static fileprivate func printWithOptions<T>( _ object: @autoclosure() -> T, _ file: String, _ function: String, _ line: Int, debugType: DebugType = .info) {
        
        #if DEBUG
        
        let obj = object()
        var stringRepresentation: String = ""
        
        if let obj = obj as? CustomDebugStringConvertible {
            stringRepresentation = obj.debugDescription
        }
        else if let obj = obj as? CustomStringConvertible {
            stringRepresentation = obj.description
        }
        
        var fileURL: String = NSURL(string: file)?.lastPathComponent ?? ""
        fileURL = fileURL.count > 0 ? fileURL : String(file.split(separator: "/").last ?? "")
        
        let queue = Thread.isMainThread ? "Main Thread" : "Background Thread"
        let gFormatter = DateFormatter()
        gFormatter.dateFormat = "HH:mm:ss:SSS"
        let timestamp = gFormatter.string(from: Date())
        var icon: String
        
        switch debugType {
            case .info:
                icon = "ℹ️"
            case .success:
                icon = "✅"
            case .error:
                icon = "❌"
        }
        
        if !Debug.printLogIntoDevice {
            if stringRepresentation.count > 0 {
                Swift.print("\n\(icon) \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]:\n")
                if !(obj is String) {
                    Swift.print("String representation: " + stringRepresentation.replacingOccurrences(of: "\\n", with: "\n") + "\n")
                }
                Swift.dump(obj)
            } else {
                Swift.print("\n\(icon) \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]:\n")
                Swift.dump(obj)
            }
        } else {
            if stringRepresentation.count > 0 {
                NSLog("\n\(icon) \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]:\n")
                if !(obj is String) {
                    NSLog("String representation: " + stringRepresentation.replacingOccurrences(of: "\\n", with: "\n") + "\n")
                }
                NSLog("\(obj)")
            } else {
                NSLog("\n\(icon) \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]:\n")
                NSLog("\(obj)")
            }
        }
        
        #endif
    }
    
    
    // MARK: - Public methods for printing
    
    static public func print( _ object: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        self.printWithOptions(object, file, function, line, debugType: .info)
    }
    
    static public func printSuccess( _ object: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        self.printWithOptions(object, file, function, line, debugType: .success)
    }
    
    static public func printError( _ object: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        self.printWithOptions(object, file, function, line, debugType: .error)
    }
}
