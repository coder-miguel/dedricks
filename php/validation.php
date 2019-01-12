<?php require('server.php'); ?>
<?php require('settings.php'); ?>
<?php
	if(validate($sessionid, $myemail) != true){
		header('location: ../index.php?access_denied');	
	}
?>