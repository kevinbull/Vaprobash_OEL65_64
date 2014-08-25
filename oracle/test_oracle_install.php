<?php
//  Configuration - Start
//$server   = 'dev1.thelogue.com';
$server   = '192.168.100.111';
$username = 'logue_admin';
$password = 'l0guePASSw0rd';
$database = 'logue';
//.thelogue.com';
$table    = 'TEST_TABLE';
$table    = 'user_tables';
$port     = '1542';

//  Configuration - End

$query    = 'Select count(*) from ' . $table;
//$query    = 'select table_name from user_tables order by table_name';
//  Connect to Oracle Database.
/*
$oracledb = '(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = ' . $server . ')(PORT = ' . $port .
			 ')) (CONNECT_DATA = (SERVER = DEDICATED)(SERVICE_NAME = ' . $database . '.' . $server .
			 ')))';
*/
$oracledb = '(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = ' . $server . ')(PORT = ' . $port .
			 ')) (CONNECT_DATA = (SERVER = DEDICATED)(SERVICE_NAME = ' . $database .
			 ')))';

if(function_exists('oci_new_connect')){
	$handle = oci_new_connect($username, $password, $oracledb);
	//  Verify that connection succeeded.
	if ( $handle === false ) {
		$error = oci_error();
		// throw new Exception("Unable to connect to database using '$oracledb', username '{$username}: " . $error['message']);
		print "CONNECT ERROR: (" . $error['message'] . ")\n";
		exit;
	}

	//  Compile the query.
	$compiled_query = oci_parse($handle, $query);
	if ( $compiled_query !== false ){
		if ( oci_execute($compiled_query) === false ) {
			$err = oci_error($compiled_query);
			// throw new Exception("Error executing query '$query': " . $err['message']);
			print "QUERY ERROR: (" . $err['message'] . ")\n";
			exit;
		}
	}else{
		print "oci_parse returned false while attempting to parse query:'" . $query . "'";
	}

	//  Execute the query and gather results into array.
	$rows = array();
	while ( $row = oci_fetch_array($compiled_query, OCI_ASSOC + OCI_RETURN_NULLS) ) {
		$rows[] = $row;
	}

	//  Print first row of results.
	print "Success!!\nThe query $query returned:\n";
	print join(" ",$rows[0]) . "\n";
}else{
	print "oci_new_connect is not found!!!!";
	exit;
}
?>