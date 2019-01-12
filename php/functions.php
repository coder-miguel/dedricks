<?php require ('server.php');?>
<?php
	function validate($sessionid, $myemail){
  		if($sessionid==$myemail){
  			$result=true;
  		}
  		else{
  			$result=false;
  		}
  		return $result;
 	}

 	// function lettersort($val){
 	

 	// exit();
?>