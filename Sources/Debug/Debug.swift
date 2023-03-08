//
//  Debug.swift
//
//
//  Created by Cristian Carlassare.
//

import Foundation
import os.log


public class Debug: NSObject {

    private override init() {  super.init()  }
    public static var printLogIntoDevice = false
    
    
    // This method prints any object received by parameter
    static fileprivate func printWithOptions<T>( _ object: @autoclosure() -> T, _ file: String, _ function: String, _ line: Int, debugType: OSLogType) {
        
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
            case .info, .debug:
                icon = "ℹ️"
            case .default:
                icon = "✅"
            case .error, .fault:
                icon = "❌"
            default:
                icon = "ℹ️"
        }
        
        // Print to Xcode console
        Swift.print("\(icon) \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]:")
            
        if stringRepresentation.count > 0 {
            Swift.dump(stringRepresentation.replacingOccurrences(of: "\\n", with: "\n") + "\n")
        } else {
            Swift.dump("\(obj) \n")
        }
        
        // Print to device
        if Debug.printLogIntoDevice {
            os_log("%@ %@ {%@} %@ > %@[%d]", type: debugType, icon, timestamp, queue, fileURL, function, line)
            
            if stringRepresentation.count > 0 {
                os_log("%@\n", type: debugType, stringRepresentation.replacingOccurrences(of: "\\n", with: "\n"))
            } else {
                os_log("%@\n", type: debugType, obj as! CVarArg)
            }
        }
        
        #endif
    }
    
    
    // MARK: - Public methods for printing
    
    static public func print( _ object: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        self.printWithOptions(object, file, function, line, debugType: .info)
    }
    
    static public func printSuccess( _ object: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        self.printWithOptions(object, file, function, line, debugType: .default)
    }
    
    static public func printError( _ object: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        self.printWithOptions(object, file, function, line, debugType: .error)
    }
    
    static public func printFault( _ object: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        self.printWithOptions(object, file, function, line, debugType: .fault)
    }
}
