<?php require('server.php');?>
<?php require('functions.php');?>

<?php
	//session_start();
	$db = mysqli_connect('localhost', 'root', '', 'dedricks');
	if(!$db){
    die("Connection Failed: ".mysqli_connect_error());
  }
  $adquery = "SELECT Email FROM AddressBook WHERE InfoID = 11;";
  $logresult = mysqli_query($db, $adquery);
  while($row = mysqli_fetch_array($logresult)){
  	$myemail = $row['Email'];
  }
  $sessionid = $_SESSION['email'];
  //TESTING TO CHECK THAT THE LOGIN STATUS IS CORRECT.
 // echo $myemail + " ";
 // echo $sessionid;
  //if($sessionid==$myemail){
  	//echo("  Success.");
  //}
  //else{
  	//echo(" Failure");
  //}
  //END TESTING
?>