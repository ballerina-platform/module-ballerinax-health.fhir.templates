import ballerina/sql;

public final sql:ParameterizedQuery QUERY_CREATE_CODESYSTEM_TABLE = `
CREATE TABLE code_system (
  id int NOT NULL AUTO_INCREMENT,
  cs_id varchar(45) NOT NULL,
  url varchar(100) NOT NULL,
  version varchar(45) NOT NULL,
  name varchar(100) NOT NULL,
  title varchar(100) DEFAULT NULL,
  status varchar(100) NOT NULL,
  date varchar(100) DEFAULT NULL,
  publisher varchar(100) DEFAULT NULL,
  data json NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY db_id_UNIQUE (id),
  UNIQUE KEY UC_code_system (cs_id,url,version)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
`;

public final sql:ParameterizedQuery QUERY_CREATE_CONCEPT_TABLE = `
CREATE TABLE concept (
  code varchar(45) NOT NULL,
  data json NOT NULL,
  codesystem_id int NOT NULL,
  PRIMARY KEY (code),
  UNIQUE KEY UC_concept (code,codesystem_id),
  KEY codesystem_id (codesystem_id),
  CONSTRAINT concept_ibfk_2 FOREIGN KEY (codesystem_id) REFERENCES code_system (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
`;

public final sql:ParameterizedQuery QUERY_CREATE_VALUESET_TABLE = `
CREATE TABLE value_set (
  id int NOT NULL AUTO_INCREMENT,
  vs_id varchar(45) NOT NULL,
  url varchar(45) NOT NULL,
  version varchar(45) NOT NULL,
  name varchar(100) NOT NULL,
  title varchar(100) DEFAULT NULL,
  status varchar(100) NOT NULL,
  date varchar(100) DEFAULT NULL,
  publisher varchar(100) DEFAULT NULL,
  data json NOT NULL,
  description varchar(45) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY id_UNIQUE (id),
  UNIQUE KEY UC_code_system (vs_id,url,version)
) ENGINE=InnoDB AUTO_INCREMENT=423 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
`;

public final sql:ParameterizedQuery IS_CODESYSTEM_TABLE_EXIST = `
SELECT count(*)
FROM information_schema.Tables
WHERE TABLE_SCHEMA = ${DB_NAME} AND TABLE_NAME = ${TABLE_NAME_CODESYSTEM}
LIMIT 1;
`;

public final sql:ParameterizedQuery IS_VALUESET_TABLE_EXIST = `
SELECT count(*)
FROM information_schema.Tables
WHERE TABLE_SCHEMA = ${DB_NAME} AND TABLE_NAME = ${TABLE_NAME_VALUESET}
LIMIT 1;
`;

public final sql:ParameterizedQuery IS_CONCEPT_TABLE_EXIST = `
SELECT count(*)
FROM information_schema.Tables
WHERE TABLE_SCHEMA = ${DB_NAME} AND TABLE_NAME = ${TABLE_NAME_CONCEPT}
LIMIT 1;
`;

sql:ParameterizedQuery QUERY_RETRIEVE_CONCEPT = `
SELECT * 
from concept 
WHERE (code = ?) AND (codesystem_id = ?)`;
