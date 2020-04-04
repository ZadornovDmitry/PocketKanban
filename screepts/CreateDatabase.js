var db_ = 0;
var data = 0;


function getDatabase()
{
    if (!db_)
       db_ = Sql.LocalStorage.openDatabaseSync("Kanban", "1.0", "Kanban tables and tasks", 1000000, function callback(db_){fillDatabase(db_);});
    return db_;
}

function fillDatabase(db) {
console.log("fill db")
    db.transaction(
        function(tx) {
            // Create the database if it doesn't already exist

            tx.executeSql("CREATE TABLE IF NOT EXISTS Boards (board_id INTEGER PRIMARY KEY NOT NULL UNIQUE, name STRING)");
            tx.executeSql("CREATE TABLE IF NOT EXISTS Tasks (task_id INTEGER PRIMARY KEY UNIQUE NOT NULL, board_id INTEGER REFERENCES Boards (board_id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL, name STRING, state_id INTEGER REFERENCES States (id) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL, priority INTEGER DEFAULT (0), color STRING DEFAULT ('#b2ebf2'))");
            tx.executeSql("CREATE TABLE IF NOT EXISTS States (id INTEGER PRIMARY KEY UNIQUE NOT NULL, state STRING UNIQUE)");
            tx.executeSql("CREATE TABLE IF NOT EXISTS ActiveBoard (id INTEGER PRIMARY KEY NOT NULL UNIQUE, board_id INTEGER REFERENCES Boards (board_id) ON DELETE CASCADE)");

            tx.executeSql("CREATE TRIGGER AI_Tasks AFTER INSERT ON Tasks BEGIN UPDATE Tasks SET priority = (SELECT MAX(task_id) FROM Tasks) WHERE priority == 0 OR priority ISNULL; END;");

            tx.executeSql("Insert or replace into States(state) values('TODO')");
            tx.executeSql("Insert or replace into States(state) values('DOING')");
            tx.executeSql("Insert or replace into States(state) values('DONE')");

            tx.executeSql("Insert or replace Into Boards(name) values('Главная доска')");
            tx.executeSql("Insert or replace Into ActiveBoard(board_id) values('1')");
            tx.executeSql("Insert  Into Tasks(name, board_id, state_id) values('myTask', '1', '1')");
            tx.executeSql("Insert  Into Tasks(name, board_id, state_id) values('myTask1', '1', '2')");
            tx.executeSql("Insert  Into Tasks(name, board_id, state_id) values('myTask2', '1', '1')");
        }
    )
    db.changeVersion("", "1.0");
}

