<?php require ('../php/server.php'); ?>
<!DOCTYPE html>
<html>
<head>
  <title>Registration system PHP and MySQL</title>
  <link rel="stylesheet" type="text/css" href="../css/log-reg.css">
</head>
<body>
  <div class="header">
  	<h2>Register</h2>
    <p> Fields with * next to them are required</p>
  </div>
	
  <form method="post" action="register.php">
  	<?php include('../php/errors.php'); ?>
    <!-- <div class="input-group"> -->
  	  <!-- <label>Username</label> -->
  	  <!-- <input type="text" name="username" value="<?php echo $username; ?>"> -->
  	<!-- </div> -->
    <div class="input-group">
      <label id="req">First Name*</label>
      <input type="text" name="fname">
    </div>
    <div class="input-group">
      <label>Last Name</label>
      <input type="text" name="lname">
    </div>
    <div class="input-group">
      <label id="req">Phone*</label>
      <input type="tel" name="phone">
    </div>
  	<div class="input-group">
  	  <label id="req">Email*</label>
  	  <input type="email" name="email" value="<?php echo $email; ?>">
  	</div>
  	<div class="input-group">
  	  <label id="req">Password*</label>
  	  <input type="password" name="password_1">
  	</div>
  	<div class="input-group">
  	  <label id="req">Confirm password*</label>
  	  <input type="password" name="password_2">
  	</div>
  	<div class="input-group">
  	  <button type="submit" class="btn" name="reg_user">Register</button>
      <a href="../index.php" class="btn" id="btn" name="home" style="text-decoration:none; font: sans-serif;">Home</a>
  	</div>
  	<p>
  		Already a member? <a href="login.php">Sign in</a>
  	</p>
  </form>
</body>
</html>