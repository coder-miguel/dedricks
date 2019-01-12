<?php

//did they click the submit button
if(isset($_POST['signup'])){
	//they did in fact click the submit button
	//bring in database connection file to access variable "$con"
	require "../db_con.php";

	//fetch form submission data using global $_POST variable
	//this is an associative array. Items can be accessed using the 
	//"keys" defined as names in the web form
    $fname  = $_POST['fname'];
    $lname  = $_POST['lname'];
    $phone  = $_POST['phone'];
	$email 	= $_POST['mail'];
	$pwd 	= $_POST['pw'];
	$pwd2	= $_POST['pw2'];

	//ERROR HANDLING
	//==============

	//did they fill in all fields? (better handled with JS)
	if(empty($email) || empty($pwd) || empty($pwd2)){
		//they left a field empty
		//send them back to the create account page
		//with the filled in data except for password . . . duh
		header("Location: ../create_account.php?error=emptyfields&uid=".$un."&email".$email);
		//stop the script from executing
		exit();
	}else{
        //does the user name already exist?
        //use PHP Prepared Statement
        $SQL = "SELECT *
                FROM   addressbook
                WHERE  email = ?;"//========================================
                ;//                                                          ||
        //prepare the SELECT statement//                                     ||
        $statement = mysqli_stmt_init($con);//                               ||
        //can the statement object be prepared with no errors?//             ||
        if(!mysqli_stmt_prepare($statement, $SQL)){//                        ||
            //cannot be prepared                                             ||
            header("Location: ../create_account.php?error=skwrl_error");//   ||
        }else{//                                                             ||
            //statement is okay                                              ||
            //bind arguments to "?" in the SQL query                         \/
            //                     sql statement,       "s" for string,    variable to bind
            mysqli_stmt_bind_param($statement,          "s",               $email);
            //execute the statement
            mysqli_stmt_execute($statement);
            mysqli_stmt_store_result($statement);
            //the results
            $results = mysqli_stmt_num_rows($statement);
            if($results > 0){
                //username already exists
                header("Location: ../create_account.php?error=username_exists");
            }else{
                //username is new
                $SQL = "INSERT INTO addressbook(email, password, fname, lname, phone) VALUES (?, ?, ?, ?, ?);";
                //hash the password           BCrypt
                $pw_hash = password_hash($pw, PASSWORD_DEFAULT);
                //prepare the INSERT INTO statement
                //$statement = mysqli_stmt_init($con);
                mysqli_stmt_prepare($statement, $SQL);
                //                     statement,   3 strings,  variables
                mysqli_stmt_bind_param($statement,  "sssss",      $email, $pw_hash, $fname, $lname, $phone);
                mysqli_stmt_execute($statement);
                header("Location: ../create_account.php?josh=wears_hat");
                exit();
            }
        }
    }












    /*-----------------------------------------------------------------------------------------------
	//are both fields invalid?
	else if(!filter_var($email, FILTER_VALIDATE_EMAIL) && !preg_match("/^[a-Z0-9]*$/", $un)){
		header("Location: ../create_account.php?error=invalidemail-uid");
		exit();
	}
	//use function filter_var to validate email
	else if(!filter_var($email, FILTER_VALIDATE_EMAIL)){
		header("Location: ../create_account.php?error=invalidemails&email=".$email);
		exit();
	}
	//use regular expressions to validate user name for accepted characters
	else if(!preg_match("/^[a-zA-Z0-9]*$/", $un)){
		header("Location: ../create_account.php?error=invalid_un&username=".$un);
		exit();
	}
	//check both passwords
	else if($pwd !== $pwd2){
		header("Location: ../create_account.php?error=passwordcheck&uid=".$un."&email".$email);
		exit();
	}

	else{
		//username already exist? Connect and see
		$sql = "SELECT id FROM users WHERE username = ?";
		//use the $con variable from the required 'dbc.inc.php' file
		//use prepared statements for security purposes
		$statement = mysqli_stmt_init($con);
		//can the statement be prepared with no issues?
		if(!mysqli_stmt_prepare($statement, $sql)){
			//there was an issue with the statement
			header("Location: ../create_account.php?error=sqlerror1");
			exit();
		}
		else{
			//statement was fine
			//bind the appropriate (s)tring from user input to SQL
			mysqli_stmt_bind_param($statement, "s", $un);
			//execute the prepared statement
			mysqli_stmt_execute($statement);
			//did we get a match ie. username already exists
			mysqli_stmt_store_result($statement);
			//did we get > 0 results?
			$results = mysqli_stmt_num_rows($statement);
			if($resuts > 0){
				//we got a match. Username already taken
				header("Location: ../create_account.php?error=un_takenemail=".$email);
				exit();
			}
			else{
				//ALL ERROR HANDLING PASSED. CAN INSERT NEW USER
				//use prepared statements. do not insert into pk field
				$sql = "INSERT INTO users (username, email, password) VALUES (?,?,?)";
				$statement = mysqli_stmt_init($con);
				//can the statement be prepared with no issues?
				if(!mysqli_stmt_prepare($statement, $sql)){
					//there was an issue with the statement
					header("Location: ../create_account.php?error=sqlerror2");
					exit();
				}
				else{
					//statement was fine
					//do not use MD5 or SHA256 hashing schemes as they have been cracked
					//use bcrypt instead
					$pw_hash = password_hash($pwd, PASSWORD_DEFAULT);
					//bind the appropriate (s)trings from user input to SQL
					//including hashed pw
					mysqli_stmt_bind_param($statement, "sss", $un, $email, $pw_hash);
					//execute the prepared statement
					mysqli_stmt_execute($statement);
					header("Location: ../create_account.php?signup=success");
					exit();
				}
			}// end insert into 
		}// end 1st prepared statement else
	}// end username already exist test
    *///-----------------------------------------------------------------------------------------------
	//close the statement
	mysqli_stmt_close($statement);
	//close the connection
	mysqli_close($con);
}//end isset test

?>

<?php

    function($caller){
        
    }

?>