<?php 
  require ('php/server.php');
  require ('php/background.php');
  if(isset($_SESSION['email'])){
  require ('php/settings.php');
  }
  //session_start();
  //include ('setpg/settings.php')
  //$Email = $_Session['email'];
  //$message = $Email . " is logged in.";
  //echo "<script type='text/javascript'>alert('$message');</script>";
?>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Dedricks Farm to Market</title>
<link href="css/style.css" rel="stylesheet" type="text/css">
<?php echo $background ?>
<link rel="stylesheet" href="css/my-slider.css"/> <!-- gallery element -->
<script src="js/ism-2.2.min.js"></script> <!-- gallery element -->

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
        <li><a href="index.php">Home</a></li>
        <li><a href="html/contact.php">About/Contact</a></li>
        <li><a href="html/order.php">Order Online</a></li>
        <li><a href="html/inventory.php">Inventory</a></li>
        <li><a href="html/bakery.php">Bakery</a></li>
        <li><a href="html/comments.php">Comments</a></li>    
            
      </ul>
    </div>
<div id="wrapper"> 

  <div id="header"> 

    <div class="top_banner">
      

      <h1 id="text"></h1>
      
      <p id="text"><b></b></p>
    </div>
	
    

  </div>

  <div id="page_content"> 

  <a href=""><img src="images/copyright.gif" class="copyright" alt=""></a>
  
    <div class="left_side_bar"> 

      <div class="col_1">
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        <br>
        
      </div>
            <!-- start new column -->
<div class="col_1">
        <h1>Register/Login</h1>
        <div class="box">
          <!-- textbox -->
           <!-- <form action="register.html">
            <input type="text" name="user" value="Username">
            <input type="text" name="pass" value="Password"> -->
          <!-- txtend -->
          <!-- button -->
            <!--<input type="submit" value="Submit">-->
            <p><a href="html/register.php" class="btn">Register</a></p>
            <p><a href="html/login.php" class="btn" id="loginbtn">Login</a></p>
            <?php
              if(isset($_SESSION['email'])){
                echo "<p><a href='html/logout.php' class='btn'>Logout</a></p>";
              }
            ?>
           <!--</form>-->
          <!-- btnend -->
        </div>
      </div>
    <!-- end new column -->
      <div class="col_1">
        <h1>Visitor Counter</h1>
        <div class="box">
          <p>This counter will tell you how many visitors have visted this page after publishing</p>
          
          <!-- start visitors -->
           <a href='http://www.freevisitorcounters.com'></a> <script type='text/javascript' src='https://www.freevisitorcounters.com/auth.php?id=198ad004bb092b7f296fcf82e38dbff6a5415183'></script>
          <script type="text/javascript" src="https://www.freevisitorcounters.com/en/home/counter/354836/t/5"></script>
          <!-- end Visitors -->

        </div>
      </div>

    </div>

    <div class="right_section">
      <div class="common_content">
      	<h2>Gallery</h2>
        
      	<div class="carosel">
      		

        

        <!-- Gallery Carosel  -->
    <div class="ism-slider" data-transition_type="fade" data-play_type="loop" data-interval="10000" data-image_fx="zoompan" id="my-slider">
      <ol>
       <li>
        <!-- csharp -->
          
            <a href="images/slides/_u/1522962825521_439504.jpg"><img src="images/slides/_u/1522962825521_439504.jpg"></a>
        </li>
        <li>
          <!-- unity -->
         <a href="images/slides/_u/1522962825379_49703.jpg"><img src="images/slides/_u/1522962825379_49703.jpg"></a>
        </li>
        <li>
          <!-- jins -->
          <a href="images/slides/_u/1522963819906_16535.png"><img src="images/slides/_u/1522963819906_16535.png"></a> 
        </li>
        <li>
          <!-- clickbait -->
          <a href="images/slides/_u/1522964169689_194337.png"><img src="images/slides/_u/1522964169689_194337.png"></a>
        </li>
        <li>
          <!-- VS -->
          <a href="images\slides\_u\1522964298398_92795.png"><img src="images/slides/_u/1522964298398_92795.png"></a>
         
        </li>
      </ol>
    </div>
    <p class="ism-badge" id="my-slider-ism-badge"><a class="ism-link" href="" rel="nofollow"></a></p>

    </div>
    </div>
       
        <div class="common_content">
        
        
      </div>



     <!-- Music -->
    
          <!-- End Music -->
        <!-- END Gallery HERE -->
             <div class="top_content">
        <div class="column_one">
          <h2>About Dedricks</h2>
          <p> Dedrick’s Farm Market started over 40 years ago at the corner it still sits on today. It is Located in Dryden, NY across from Tompkins Cortland Community College. We have a market inside and hanging plants and seasonal vegetables outside. We also have Chicken BBQ see events below for more details for more information about our store click the Read More below. </p>
          <br>
          <p><a href="html/contact.php" class="btn">Read more</a></p></div>
        <div class="column_two border_left">
          <h2>Events</h2>
          <p>1. The Chicken BBQ will be going on every other Saturday. <br>
             2. Seasonal Veggies and hanging plants during the warmer months. <br>
             3. Christmas trees and wreaths will be here starting in November. <br>
             4. Apples and fall crops during Autumn.
          </p>
          <br>
          <p><a href="html/contact.php" class="btn">Read more</a></p></div>


    </div>

    <div class="clear"></div>


    <div id="footer">
      <?php
      if(isset($_SESSION['email'])){
        echo $sessionid . " is logged in.";
        if(validate($sessionid, $myemail)==true){
          echo "<a href='html/adminconfig.php' id='adminbtn'>Settings</a>";
        }
      }
      ?>
      Copyright &copy; 2018. Design by <a target="_blank">JZM</a><br>

    
    </div>
	
  </div>

</div>
</body></html>