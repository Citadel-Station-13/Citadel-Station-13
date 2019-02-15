/*
Player poll module requires the following SQL tables on the database it is set to access:
DATATYPE(length) values are recommendations.
poll_options -
	INT UNSIGNED PRIMARY_KEY NOT_NULL AUTO_INCREMENT id
	INT UNSIGNED KEY NOT_NULL pollid
	TEXT(512) NOT_NULL text


*/
