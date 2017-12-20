PRAGMA FOREIGN_KEYS = ON;

CREATE TABLE IF NOT EXISTS Drivers (name TEXT NOT NULL PRIMARY KEY, comment TEXT, used INTEGER NOT NULL, active  INTEGER NOT NULL);

CREATE TABLE IF NOT EXISTS S7Connections (name TEXT NOT NULL PRIMARY KEY, comment TEXT, driver_name TEXT NOT NULL REFERENCES Drivers (name) ON DELETE CASCADE ON UPDATE CASCADE, active INTEGER NOT NULL, ip_address TEXT NOT NULL, port INTEGER NOT NULL, rack INTEGER NOT NULL, slot INTEGER NOT NULL, type TEXT NOT NULL, delay INTEGER NOT NULL, pool_period INTEGER NOT NULL, pool_period_factor INTEGER NOT NULL, begin_offset INTEGER NOT NULL, begin_offset_factor INTEGER NOT NULL, debag_mes INTEGER NOT NULL, redu_chanel INTEGER NOT NULL, err_before_disc INTEGER NOT NULL);

CREATE TABLE IF NOT EXISTS S7Groups (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, comment TEXT, parent_id INTEGER CHECK(parent_id != id) REFERENCES S7Groups (id) ON DELETE CASCADE ON UPDATE CASCADE, conn_name INTEGER NOT NULL REFERENCES S7Connections (name) ON DELETE CASCADE ON UPDATE CASCADE, path TEXT, UNIQUE (name, parent_id));

CREATE TABLE IF NOT EXISTS S7Tags (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, comment TEXT, group_id INTEGER NOT NULL REFERENCES S7Groups (id) ON DELETE CASCADE ON UPDATE CASCADE, access INTEGER NOT NULL, memory_type INTEGER NOT NULL, data_type INTEGER NOT NULL, data_block INTEGER NOT NULL, byte INTEGER NOT NULL, bit INTEGER NOT NULL, active INTEGER NOT NULL, UNIQUE(name, group_id));

CREATE TRIGGER IF NOT EXISTS InsertPathToS7Groups AFTER INSERT ON S7Groups BEGIN UPDATE S7Groups SET path = CASE WHEN NEW.parent_id IS NOT NULL THEN (SELECT path FROM S7Groups WHERE id = NEW.parent_id )||'.'||NEW.name ELSE NEW.path END WHERE id = NEW.id; END;

CREATE TRIGGER IF NOT EXISTS InsertRootToS7Groups AFTER INSERT ON S7Connections BEGIN INSERT INTO S7Groups (name,parent_id, conn_name, path) VALUES (NEW.name, NULL, NEW.name, NEW.driver_name||'.'||NEW.name); END;

CREATE TRIGGER IF NOT EXISTS UpdatePathToS7Groups AFTER UPDATE OF name, parent_id, conn_name ON S7Groups BEGIN UPDATE S7Groups SET path = CASE WHEN S7Groups.parent_id IS NOT NULL THEN (SELECT path FROM S7Groups as g WHERE g.id = S7Groups.parent_id)||'.'||S7Groups.name ELSE (SELECT driver_name FROM S7Connections WHERE S7Connections.name = S7Groups.conn_name ) ||'.'||S7Groups.conn_name END; END;

CREATE TRIGGER IF NOT EXISTS UpdateNameToS7Groups AFTER UPDATE OF name ON S7Connections BEGIN UPDATE S7Groups SET name = NEW.name WHERE conn_name = new.name AND parent_id IS NULL; END;

INSERT INTO Drivers (name, used, active, comment) VALUES ("SIEMENSPLC", 1, 1, 'Driver for Siemens PLC');
INSERT INTO Drivers (name, used, active, comment) VALUES ("MODBUSTCP", 0, 0, 'Driver for Modbus TCP');
INSERT INTO Drivers (name, used, active, comment) VALUES ("MODBUSRTU", 0, 0, 'Driver for Modbus RTU');

INSERT INTO S7Connections (name, driver_name, active, ip_address, port, rack, slot, type, delay, pool_period, pool_period_factor, begin_offset, begin_offset_factor, debag_mes, redu_chanel, err_before_disc) VALUES ("Connection1", "SIEMENSPLC", 1, "192.168.0.1", 102, 0, 3, "ISOTSP", 5000, 1, 1, 0, 1, 0, 1, 3);
INSERT INTO S7Connections (name, driver_name, active, ip_address, port, rack, slot, type, delay, pool_period, pool_period_factor, begin_offset, begin_offset_factor, debag_mes, redu_chanel, err_before_disc) VALUES ("Connection2", "SIEMENSPLC", 1, "127.0.0.1", 102, 0, 3, "ISOTSP243", 5000, 1, 1, 0, 1, 0, 1, 3);

INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group1',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group2',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group3',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group4',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group5',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group1',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group2',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group3',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group4',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group5',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group1',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group2'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group2',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group2'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group3',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group2'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group4',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group2'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group5',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group2'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group1',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group3'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group2',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group3'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group3',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group3'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group4',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group3'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group5',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group3'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group1',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group4'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group2',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group4'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group3',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group4'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group4',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group4'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group5',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group4'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group1',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group5'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group2',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group5'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group3',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group5'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group4',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group5'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group5',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group5'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group1',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group1.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group2',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group1.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group3',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group1.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group4',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group1.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group5',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group1.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group1',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group2.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group2',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group2.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group3',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group2.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group4',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group2.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group5',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group2.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group1',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group3.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group2',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group3.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group3',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group3.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group4',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group3.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group5',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group3.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group1',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group4.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group2',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group4.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group3',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group4.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group4',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group4.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group5',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group4.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group1',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group5.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group2',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group5.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group3',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group5.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group4',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group5.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group5',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection1.Group5.Group1'), "Connection1");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group1',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection2'), "Connection2");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group2',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection2'), "Connection2");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group3',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection2'), "Connection2");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group4',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection2'), "Connection2");
INSERT INTO S7Groups (name,parent_id, conn_name) VALUES ('Group5',(SELECT id FROM S7Groups WHERE path = 'SIEMENSPLC.Connection2'), "Connection2");

INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag1', "1","1","4","1","10","0", "4", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag2', "2","1","4","2","10","4", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag3', "3","2","4","3","10","8", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag4', "4","2","4","4","10","12", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag5', "5","3","4","5","10","16", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag6', "6","3","4","6","10","20", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag7', "7","3","4","7","10","24", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag8', "8","3","1","8","10","28", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag9', "9","3","2","9","10","32", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag10', "10","3","3","10","10","34", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag11', "11","3","5","11","10","38", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag12', "12","3","6","12","10","42", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag13', "13","3","6","13","10","46", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag14', "14","3","6","14","10","50", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag15', "15","3","6","15","10","54", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag16', "16","3","6","16","10","58", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag17', "17","3","6","17","10","62", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag18', "18","3","6","18","10","66", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag19', "19","3","6","19","10","70", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag20', "20","3","6","20","10","74", "0", "1");
INSERT INTO S7Tags  ("name", "group_id", "access", "memory_type", "data_type", "data_block", "byte", "bit", "active") VALUES ('Tag21', "21","3","6","21","10","78", "0", "1");

