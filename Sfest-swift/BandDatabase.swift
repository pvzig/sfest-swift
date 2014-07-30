//
//  BandDatabase.swift
//  Sfest-swift
//
//  Created by Peter Zignego on 7/29/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.

import Foundation

class BandDatabase {
    
    class var sharedInstance:BandDatabase {
    struct Static {
        static let instance : BandDatabase = BandDatabase()
        }
        return Static.instance
    }
    
    var handle: COpaquePointer = nil
    
    func open() {
        var location = NSBundle.mainBundle().pathForResource("sfdb", ofType: "sqlite3")
        var path = location.bridgeToObjectiveC().cStringUsingEncoding(NSUTF8StringEncoding)
        let code = sqlite3_open(path, &handle)
    }
    
    func bandsPlayingAtStage(stage:String, date:String) -> [(band:String, time:String)] {
        var results: [(band:String, time:String)] = []
        let queryString = "SELECT UID, DATE, TIME, STAGE, BAND FROM sfinfo WHERE DATE='"+date+"' AND STAGE='"+stage+"'"
        var cString = queryString.bridgeToObjectiveC().cStringUsingEncoding(NSUTF8StringEncoding)
        var statement: COpaquePointer = nil
        var result: CInt = 0
        
        // Prepare statement
        result = sqlite3_prepare_v2(handle, cString, -1, &statement, nil)
        if (result != SQLITE_OK) {
            sqlite3_finalize(statement)
            println("Error")
        }
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            var uniqueID = sqlite3_column_int(statement, 0)
            var dateCharacters = UnsafePointer<Int8> (sqlite3_column_text(statement, 1))
            var timeCharacters = UnsafePointer<Int8> (sqlite3_column_text(statement, 2))
            var stageCharacters = UnsafePointer<Int8> (sqlite3_column_text(statement, 3))
            var bandCharacters = UnsafePointer<Int8> (sqlite3_column_text(statement, 4))
            var date = String.fromCString(dateCharacters)
            var time = String.fromCString(timeCharacters)
            var stage = String.fromCString(stageCharacters)
            var band = String.fromCString(bandCharacters)

            results += (band!, time!)
        }
        return results
    }
}
