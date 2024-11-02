//
//  SqLiteDB.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 25.04.2024.
//

import Foundation
import SQLite3

class DBManager: ObservableObject
{
    init()
    {
        db = openDatabase()
        createTable()
        createTrainingSplitsTable()
    }
  
  
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
  
  
    func openDatabase() -> OpaquePointer?
    {
        let filePath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(filePath?.path, &db) != SQLITE_OK
        {
            //debugPrint("can't open database")
            return nil
        }
        else
        {
            print("Successfully created connection to database at \(dbPath)")
            return db
        }
    }
    func deleteTable(name:String) {
        let createTableString = "Drop TABLE IF EXISTS \(name);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("\(name) table deleted.")
            } else {
                print("\(name) table could not be deleted.")
            }
        } else {
            print("DRop TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS workout(Id INTEGER PRIMARY KEY, date TEXT,type TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                //print("workout table created.")
            } else {
                //print("workout table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    func createTrainingSplitsTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS trainingsplits(Id INTEGER PRIMARY KEY,workoutId INTEGER, time TEXT,heartRate DOUBLE, activeEnergy DOUBLE, distance Double, FOREIGN KEY(workoutId) REFERENCES workout(id));"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                //print("trainingsplits table created.")
            } else {
                //print("trainingsplits table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
      
      
    func insert(id:Int, date:String, type:String)
    {
        let workouts = read()
        for w in workouts
        {
            if w.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO workout (Id, date, type) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))

            sqlite3_bind_text(insertStatement, 2, (date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (type as NSString).utf8String, -1, nil)
              
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    func insertTrainingSplits(id:Int, workoutId:Int, time:String, heartRate: Double, activeEnergy: Double, distance: Double)
    {
        let trainingSplits = readTrainingSplits()
        for t in trainingSplits
        {
            if t.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO trainingsplits (Id,workoutId, time,heartRate, activeEnergy, distance) VALUES (?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_int(insertStatement, 2, Int32(workoutId))
            sqlite3_bind_text(insertStatement, 3, (time as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 4, Double(heartRate))
            sqlite3_bind_double(insertStatement, 5, Double(activeEnergy))
            sqlite3_bind_double(insertStatement, 6, Double(distance))
        
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\(id) | \(workoutId)| \(time)| \(heartRate)| \(activeEnergy)| \(distance)")
                //print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            //print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
      
    func read() -> [Workout] {
        let queryStatementString = "SELECT * FROM workout;"
        let (workoutSplits) = readWorkoutBody(queryStatementString: queryStatementString)
        return (workoutSplits)
    }
    func read(type: String) -> [Workout] {
        let queryStatementString = "SELECT * FROM workout where type = '\(type)';"
        let (workoutSplits) = readWorkoutBody(queryStatementString: queryStatementString)
        return (workoutSplits)
        
    }
    func readWorkoutBody(queryStatementString: String) -> ([Workout]){
        var queryStatement: OpaquePointer? = nil
        var trainingSplits : [Workout] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            //print("Query Result:")
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let type = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                trainingSplits.append(Workout(id: Int(id), date: String(date), type: String(type)))
                    //print("\(id) | \(date) | \(type)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return trainingSplits
    }
    func readTrainingSplits() -> [TrainingSplits] {
        let queryStatementString = "SELECT * FROM trainingsplits;"
        var queryStatement: OpaquePointer? = nil
        var trainingSplits : [TrainingSplits] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            //print("Query Result:")
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let workoutId = sqlite3_column_int(queryStatement, 1)
                let time = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let heartRate = sqlite3_column_double(queryStatement, 3)
                let activeEnergy = sqlite3_column_double(queryStatement, 4)
                let distance = sqlite3_column_double(queryStatement, 5)
                trainingSplits.append(TrainingSplits(id:Int(id), workoutId:Int(workoutId), time:String(time), heartRate: Double(heartRate), activeEnergy: Double(activeEnergy), distance: Double(distance)))
               //print("\(id) | \(workoutId)| \(time)| \(heartRate)| \(activeEnergy)| \(distance)")
            }
        } else {
            //print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return trainingSplits
    }
    
    func readTrainingSplits(worloutId: Int) -> ([TrainingSplits], [Double], [Double], [Double])  {
        let queryStatementString = "SELECT * FROM trainingsplits where workoutId = \(worloutId);"
        let (trainingSplits,activeEnergy, distance, heartRate) = readTrainingSplitsBody(queryStatementString: queryStatementString)
        return (trainingSplits, activeEnergy, distance, heartRate)
    }
    func readTrainingSplits(type: String, Distance: Double) -> ([TrainingSplits], [Double], [Double], [Double]) {
        let queryStatementString = "SELECT t.Id, t.workoutId, t.time, t.heartRate, t.activeEnergy, t.distance FROM trainingsplits t JOIN workout w ON t.workoutId = w.id WHERE w.type = '\(type)' AND t.distance BETWEEN \(Distance * 0.9) AND \(Distance * 1.1) ORDER BY t.distance;"
        let (trainingSplits,activeEnergy, distance, heartRate) = readTrainingSplitsBody(queryStatementString: queryStatementString)
        return (trainingSplits, activeEnergy, distance, heartRate)
    }
    func readTrainingSplits(type: String, worloutId: Int, distance: Double) -> ([TrainingSplits], [Double], [Double], [Double]) {
        let queryStatementString = "SELECT t.Id, t.workoutId, t.time, t.heartRate, t.activeEnergy, t.distance FROM trainingsplits t JOIN workout w ON t.workoutId = w.id WHERE w.type = '\(type)' AND w.id = \(worloutId) and t.distance <= \(distance);"
        let (trainingSplits,activeEnergy, distance, heartRate) = readTrainingSplitsBody(queryStatementString: queryStatementString)
        return (trainingSplits, activeEnergy, distance, heartRate)
    }
    func readTrainingSplits(type: String) -> ([TrainingSplits], [Double], [Double], [Double]) {
        let queryStatementString = "SELECT t.Id, t.workoutId, t.time, t.heartRate, t.activeEnergy, t.distance FROM trainingsplits t JOIN workout w ON t.workoutId = w.id WHERE w.type = '\(type)' ORDER BY t.distance;"
        let (trainingSplits,activeEnergy, distance, heartRate) = readTrainingSplitsBody(queryStatementString: queryStatementString)
        return (trainingSplits, activeEnergy, distance, heartRate)
    }
    func readTrainingSplitsBody(queryStatementString: String) -> ([TrainingSplits], [Double], [Double], [Double]){
       var queryStatement: OpaquePointer? = nil
       var trainingSplits : [TrainingSplits] = []
       var activeEnergy: [Double] = []
       var distance: [Double] = []
        var heartRate: [Double] = []
       if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
           while sqlite3_step(queryStatement) == SQLITE_ROW {
               let id = sqlite3_column_int(queryStatement, 0)
               let workoutId = sqlite3_column_int(queryStatement, 1)
               let time = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
               let heartRateValue = sqlite3_column_double(queryStatement, 3)
               let activeEnergyValue = sqlite3_column_double(queryStatement, 4)
               let distanceValue = sqlite3_column_double(queryStatement, 5)
               let trainingSplit = TrainingSplits(id:Int(id), workoutId:Int(workoutId), time:String(time), heartRate: Double(heartRateValue), activeEnergy: Double(activeEnergyValue), distance: Double(distanceValue))
               trainingSplits.append(trainingSplit)
               activeEnergy.append(trainingSplit.activeEnergy)
               distance.append(trainingSplit.distance)
               heartRate.append(trainingSplit.heartRate)
           }
       } else {
           //print("SELECT statement could not be prepared")
       }
       sqlite3_finalize(queryStatement)
       return (trainingSplits, activeEnergy, distance, heartRate)
    }

    func deleteData(){
        print("deleteData2")
        //self.deleteTable(name: "trainingsplits")
        //self.deleteTable(name: "workout")
    }
    func deleteRawByID(id:Int, deleteStatementStirng:String) {
            var deleteStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(deleteStatement, 1, Int32(id))
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("Successfully deleted row.")
                } else {
                    print("Could not delete row.")
                }
            } else {
                print("DELETE statement could not be prepared")
            }
            sqlite3_finalize(deleteStatement)
        }
    func deleteRowByID(id:Int) {
        
        let deleteTrainingsplitsRec = "DELETE FROM trainingsplits WHERE workoutId = \(id);"
        deleteRawByID(id: id, deleteStatementStirng: deleteTrainingsplitsRec)
        let deleteWorkoutRec = "DELETE FROM workout WHERE Id = \(id);"
        deleteRawByID(id: id, deleteStatementStirng: deleteWorkoutRec)
            
        }
    func deleteWorkoutSplitRowByID(id:Int) {
        
        let deleteWorkoutRec = "DELETE FROM workoutsplits WHERE id = \(id);"
        deleteRawByID(id: id, deleteStatementStirng: deleteWorkoutRec)
            
        }
    func createWorkoutSplitsTable() {
            let createTableString = """
            CREATE TABLE IF NOT EXISTS workoutsplits(
                id INTEGER PRIMARY KEY,
                workoutId INTEGER,
                athleteID TEXT,
                distance DOUBLE,
                splitspeed DOUBLE,
                splitIntensity TEXT,
                splitworkouttype TEXT,
                comment TEXT,
                FOREIGN KEY(workoutId) REFERENCES workout(Id)
            );
            """
            var createTableStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
                if sqlite3_step(createTableStatement) == SQLITE_DONE {
                    print("WorkoutSplits table created successfully.")
                } else {
                    print("WorkoutSplits table could not be created.")
                }
            } else {
                print("CREATE TABLE statement for workoutsplits could not be prepared.")
            }
            sqlite3_finalize(createTableStatement)
        }

        // 2. Insert data into WorkoutSplits table
        func insertWorkoutSplit(workoutSplit: WorkoutSplit) {
            let insertStatementString = """
            INSERT INTO workoutsplits (id, workoutId, athleteID, distance, splitspeed, splitIntensity, splitworkouttype, comment)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?);
            """
            var insertStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(insertStatement, 1, Int32(workoutSplit.id))
                sqlite3_bind_int(insertStatement, 2, Int32(workoutSplit.workoutId))
                sqlite3_bind_text(insertStatement, 3, (workoutSplit.athleteID as NSString).utf8String, -1, nil)
                sqlite3_bind_double(insertStatement, 4, workoutSplit.distance)
                sqlite3_bind_double(insertStatement, 5, workoutSplit.splitspeed)
                sqlite3_bind_text(insertStatement, 6, (workoutSplit.splitIntensity as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 7, (workoutSplit.splitworkouttype as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 8, (workoutSplit.comment as NSString).utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("WorkoutSplit inserted successfully.")
                } else {
                    print("Could not insert workout split.")
                }
            } else {
                print("INSERT statement for workoutsplits could not be prepared.")
            }
            sqlite3_finalize(insertStatement)
        }

        // 3. Delete all data from WorkoutSplits table
        func deleteAllWorkoutSplits() {
            let deleteStatementString = "DELETE FROM workoutsplits;"
            var deleteStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("All data deleted from workoutsplits.")
                } else {
                    print("Could not delete data from workoutsplits.")
                }
            } else {
                print("DELETE statement for workoutsplits could not be prepared.")
            }
            sqlite3_finalize(deleteStatement)
        }

        // 4. Retrieve data from WorkoutSplits table
        func readWorkoutSplits() -> [WorkoutSplit] {
            let queryStatementString = "SELECT * FROM workoutsplits;"
            var queryStatement: OpaquePointer? = nil
            var workoutSplits: [WorkoutSplit] = []

            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id = sqlite3_column_int(queryStatement, 0)
                    let workoutId = sqlite3_column_int(queryStatement, 1)
                    let athleteID = String(cString: sqlite3_column_text(queryStatement, 2))
                    let distance = sqlite3_column_double(queryStatement, 3)
                    let splitspeed = sqlite3_column_double(queryStatement, 4)
                    let splitIntensity = String(cString: sqlite3_column_text(queryStatement, 5))
                    let splitworkouttype = String(cString: sqlite3_column_text(queryStatement, 6))
                    let comment = String(cString: sqlite3_column_text(queryStatement, 7))

                    let workoutSplit = WorkoutSplit(
                        id: Int(id),
                        workoutId: Int(workoutId),
                        athleteID: athleteID,
                        distance: distance,
                        splitspeed: splitspeed,
                        splitIntensity: splitIntensity,
                        splitworkouttype: splitworkouttype,
                        comment: comment
                    )
                    workoutSplits.append(workoutSplit)
                }
                print("Retrieved workout splits successfully.")
            } else {
                print("SELECT statement for workoutsplits could not be prepared.")
            }
            sqlite3_finalize(queryStatement)
            return workoutSplits
        }
}
