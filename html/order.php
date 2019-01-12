<?php 
  require ('../php/server.php');
  if(isset($_SESSION['email'])){
  require ('../php/settings.php');
  }
?>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Dedricks Farm to Market</title>
<link href="../css/style.css" rel="stylesheet" type="text/css">
<script src="../js/ism-2.2.min.js"></script>

    <!-- Start Active Page -->
         <script src=http://code.jquery.com/jquery-2.1.4.min.js></script> <!-- active page element -->
         <script>
            $(function(){
                $('a').each(function(){
                    if ($(this).prop('href') == window.location.href) {
                        $(this).addClass('active'); $(this).parents('li').addClass('active');
                    }
                });
            });
        </script>
    <!-- End Active Page -->
    <!-- mp3 player -->
    
    <!-- End of mp3 -->

</head>
<body>
<div class="navigation" id="nav_bar">
      <ul>
       	<li><a href="../index.php">Home</a></li>
        <li><a href="contact.php">About/Contact</a></li>
        <li><a href="order.php">Order Online</a></li>
        <li><a href="inventory.php">Inventory</a></li>
        <li><a href="bakery.php">Bakery</a></li>
        <li><a href="comments.php">Comments</a></li>
      </ul>
    </div>

        
      <div class="body">
       
          <h2>Chicken BBQ is the only Item available for Online Order at this time....</h2>
          <b><a href="CknBQ.html">-->> Chicken BBQ Online Order Form <<--</a></b><br><br>
          <a href="../images\slides\_u\1522962825379_49703.jpg"><img src="../images\slides\_u\1522962825379_49703.jpg" style="width:350px;height:400px;"></a>
          <a href="../images\slides\_u\1522962825379_49703.jpg"><img src="../images\slides\_u\1522962825379_49703.jpg" style="width:350px;height:400px;"></a>
    </div>

    <br>
    <br>


    <div id="footer">Copyright &copy; 2018. Design by <a href="" target="_blank">JZM</a><br>
            <?php
      if(isset($_SESSION['email'])){
        echo $sessionid . " is logged in.";
        if(validate($sessionid, $myemail)==true){

        }
      }
      ?>
    
    </div>
	
  </div>

</div>

</body></html>