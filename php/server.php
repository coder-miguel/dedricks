<?php
if(!isset($_SESSION)){
session_start();
}
// initializing variables
// $username = "";
$email  = "";
$fn     = "";
$ln     ="";
$phone  = "";
$errors = array(); 

// connect to the database
$db = mysqli_connect('localhost', 'root', '', 'dedricks');

if(!$db){
    die("Connection Failed: ".mysqli_connect_error());
  }

// REGISTER USER
if (isset($_POST['reg_user'])) {
  // receive all input values from the form
  // $username = mysqli_real_escape_string($db, $_POST['username']);
  $email = mysqli_real_escape_string($db, $_POST['email']);
  $fn    = mysqli_real_escape_string($db, $_POST['fname']);
  $ln    = mysqli_real_escape_string($db, $_POST['lname']);
  $phone = mysqli_real_escape_string($db, $_POST['phone']);
  $password_1 = mysqli_real_escape_string($db, $_POST['password_1']);
  $password_2 = mysqli_real_escape_string($db, $_POST['password_2']);

  // form validation: ensure that the form is correctly filled ...
  // by adding (array_push()) corresponding error unto $errors array
  // if (empty($username)) { array_push($errors, "Username is required"); }
  if (empty($email)) { array_push($errors, "Email is required"); }
  if (empty($password_1)) { array_push($errors, "Password is required"); }
  if (empty($fn)) {array_push($errors, "First Name is required"); }
  if (empty($phone)) {array_push($errors, "Phone Number is required"); }
  if ($password_1 != $password_2) {
  array_push($errors, "The two passwords do not match");
  }

  // first check the database to make sure 
  // a user does not already exist with the same username and/or email
  $user_check_query = "SELECT * FROM AddressBook WHERE email='$email' LIMIT 1";
  $result = mysqli_query($db, $user_check_query);
  $user = mysqli_fetch_assoc($result);
  
  if ($user) { // if user exists
    // if ($user['username'] === $username) {
    //  array_push($errors, "Username already exists");
    //}

    if ($user['email'] === $email) {
      array_push($errors, "email already exists");
    }
  }

  // Finally, register user if there are no errors in the form
  if (count($errors) == 0) {
    $password = password_hash($password_1, PASSWORD_BCRYPT);//encrypt the password before saving in the database

    $query = "INSERT INTO AddressBook (Email, Password, FName, LName, Phone) 
          VALUES('$email', '$password', '$fn', '$ln', '$phone')";
    mysqli_query($db, $query);
    $_SESSION['email'] = $email;
    $_SESSION['success'] = "You are now logged in";
    header('location: ../index.php?registration_successful');
  }
}

// ... 
// LOGIN USER
if (isset($_POST['login_user'])) {
  $Email = mysqli_real_escape_string($db, $_POST['email']);
  $Password = mysqli_real_escape_string($db, $_POST['password']);

  if (empty($Email)) {
    array_push($errors, "Email is required");
  }
  if (empty($Password)) {
    array_push($errors, "Password is required");
  }

  if (count($errors) == 0) {
      //$Password = password_hash($Password, PASSWORD_DEFAULT);
      $query = "SELECT Password FROM AddressBook WHERE Email='$Email'";
      $results = mysqli_query($db, $query);
      $row = mysqli_fetch_assoc($results);
      if(password_verify($Password, $row['Password'])){
          $_SESSION['email'] = $Email;
          $_SESSION['success'] = "You are now logged in";
          header('location: ../index.php?login_successful');
      }
    else {
      array_push($errors, "Wrong email/password combination");
    }
  }
}
?>