CREATE SCHEMA com_parameter;

CREATE TABLE com_parameter.convert_harbour_code (
	FAO_code VARCHAR(5),
    BLE_code VARCHAR(10),
    FF50 VARCHAR(8),
    harbour VARCHAR(50),
    state VARCHAR(10)
);

\\copy com_parameter.convert_harbour_code (fao_code, ble_code, ff50, harbour, state) 
FROM '/home/schmedemann/Projekte/dcmap/dcmap/parameter/convert_harbour_code.csv' DELIMITER ';' CSV HEADER QUOTE '\"' ESCAPE '\"';"
