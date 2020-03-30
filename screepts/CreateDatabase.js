function createDb(db) {
    console.log("here " + db)
    //db = Sql.LocalStorage.openDatabaseSync("Kanban", "1.0", "Kanban tables and tasks", 1000000);

    db.transaction(
        function(tx) {
            // Create the database if it doesn't already exist
            tx.executeSql("CREATE TABLE IF NOT EXISTS Tables (table_id INTEGER PRIMARY KEY NOT NULL UNIQUE, Name STRING)");
            tx.executeSql("CREATE TABLE IF NOT EXISTS Tasks (task_id INTEGER PRIMARY KEY UNIQUE NOT NULL, table_id INTEGER REFERENCES Tables (table_id) ON DELETE CASCADE ON UPDATE CASCADE UNIQUE NOT NULL, name STRING, state_id INTEGER REFERENCES States (id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL)");
            tx.executeSql("CREATE TABLE IF NOT EXISTS States (id INTEGER PRIMARY KEY UNIQUE NOT NULL, state STRING UNIQUE)");

            tx.executeSql("Insert or replace into States(state) values('TODO')");
            tx.executeSql("Insert or replace into States(state) values('DO')");
            tx.executeSql("Insert or replace into States(state) values('DONE')");

            tx.executeSql("Insert or replace Into Tables(Name) values('TestTable')");
            tx.executeSql("Insert or replace Into Tasks(name, table_id, state_id) values('myTask', '1', '1')");

        }
    )
    db.changeVersion("", "1.0");
}
function callback(db){
    console.log("here i am" + db);
}
