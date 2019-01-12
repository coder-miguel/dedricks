<?php require('../php/validation.php');?>
<?php require('../php/background.php');?>


<?php
           if(isset($_POST['selectval'])){
        $_SESSION['changeback'] = $_POST['selectval'];
      }

     ?>




<!DOCTYPE html>
<html lang="en" >

<head>
  <meta charset="UTF-8">
  <title>Stylish User Settings Dropdown Menu</title>
  
  
  
      <link rel="stylesheet" href="../css/settings.css">


  
<script type="text/javascript">
  function load() {
     
      document.getElementById("selectval").value = '<?php echo $_SESSION['changeback'] ;?>';
      //document.getElementById("selectval").value = '<?php echo $_SESSION['changeback'] ;?>';

}

</script>

</head>

<body onload="load();">


  <!-- <div id="wrap"> -->
  	<br><br><br><br>
    <h1>Admin Settings Menu</h1>
    
    <div id="dropdown" class="ddmenu" onchange="">
      Admin Settings
      <ul>
        <li><a href="picup.php">Upload Pictures</a></li>
        <li><a href="../index.php">Close BBQ</a></li>
        <li><a href="../index.php">Open BBQ</a></li>
        <li><a href="logout.php">Log Out</a></li>
      </ul>
    </div>
 
<br><br><br><br><br><br><br><br><br><br><br><br>

<div id="dropdown2" class="ddmenu">
      Admin Items
      <ul>
      	
        <li><a href="https://onedrive.live.com/edit.aspx?cid=07fb1d119a0e30eb&page=view&resid=7FB1D119A0E30EB!203&parId=7FB1D119A0E30EB!140&app=Excel">My Excel Inventory List</a></li>

        <li><a href="../uploads">My Website Pictures</a></li>

        <li><a href="AdminDatabase.php">Browse Database</a></li>
        <li><a href="../DedricksRegister/checkout/">Checkout</a></li>
        
      </ul>
    </div>
    <br><br><br><br><br><br><br><br><br>
    
      

      <form method="post" action="adminconfig.php" >
        <p>Change Background</p>
        <div id="dropdown3" class="styled-select">

      <select id="selectval" name="selectval" onchange="this.form.submit()">
        <!-- <option value="nothing">nothing</option> -->
        <option value="Spring">Spring</option>
        <option value="Winter">Winter</option>
        <option value="Fall">Fall</option>
        <option value="Summer">Summer</option>

      </select>
      </div>

      </form>
    <!-- ------------------------------------------- -->
    


    <!-- ------------------------------- -->


    
    <!-- <button type="submit" class="btn" name="change">Change</button> -->
    









   
    <form action="../index.php">
    <input type="submit" value="Home" />
    </form>
    
    

<script type="text/javascript">

</script>
  


 <!-- </div> -->
  
</body>
  <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>

  

    <script  src="../js/index.js"></script>






</html>
