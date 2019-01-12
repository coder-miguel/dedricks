<?php require ("../php/selection.php"); ?>

      
<?php 
          $server_name = "localhost";
            $user_name   = "root";
            $password    = "";
            $db_name     = "dedricks";

            // establish a connection with mysql
            $con = mysqli_connect($server_name,$user_name,$password,$db_name);


            $inventoryQ = mysqli_query($con, "SELECT Description FROM Item");
            $inventory = array(); 

            while($row = mysqli_fetch_assoc($inventoryQ))
            {
              $inventory[] = $row['Description'];
          }  
                  
        function lettersort($val){
    echo "hello" ;
    // if($val){      
      $test1= mysqli_query($db, "SELECT Description FROM Item WHERE Description LIKE '$val%';");
    // }
  }




        ?>





<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Dedricks Farm to Market</title>
<link href="../css/style.css" rel="stylesheet" type="text/css">
<script src="../js/ism-2.2.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
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
 
<!-- -------------OnLoadWebsite------------------------- -->
<SCRIPT language=Javascript>
function Load() 
  {
    
    var spec = document.getElementById('spec') 
    var reset = document.getElementById('reset')
    // spec.setAttribute("disabled", true);
   spec.removeAttribute("disabled");
    // reset.click();
     }
     </SCRIPT>
   
<!-- ----------------------End Web Load-------------------- -->
<!-- -------------FilterLetter------------------------- -->
<!-- -------$nameVar-------------$priceVar---------$itemCodeVar-->
<!-- <SCRIPT>
$(document).ready(function(){
            $('#let').change(function(){
                //Selected value
                var letValue = $(this).val();
                //alert("LET: "+inputValue);
                
    
                
            });

        });
     </SCRIPT>
 -->


<!-- -------------FilterCategory------------------------- -->
<!-- -------$nameVar-------------$priceVar---------$itemCodeVar-->

<!-- -------------SpecificFilter------------------------- -->
<!-- -------$nameVar-------------$priceVar---------$itemCodeVar-->
<SCRIPT language=Javascript>
$(document).ready(function(){
            $('#spec').change(function(){
                //Selected value
                var specValue = $(this).val();
                //alert("Spec: "+inputValue);
                
    
                
            });

        });
     </SCRIPT>
   

<!-- --------------------Read Only------------------- -->

<!-- ------------------------------------Test PHP Ajax----------------------------------------------------- -->
 <script>
      
            $(document).ready(function(){
            $('#cat').change(function(){
                //Selected value
                var catValue = $(this).val();
                // alert("Cat: "+catValue);
                
    
                //Ajax for calling php function
                $.post('../php/selection.php', { 'cat': catValue }, function(data){

                    //alert('ajax completed. Response:  '+data);
                   
                });
            });

        });


        </script>
<!-- ------------------------------------------------------------------------------------------------------------------- -->

<!-- --------------------------------------END OF SCRIPTS-------------------------------------------------------------------------- -->

</head>
<body onload="Load()">
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
       
          <h2>Inventory</h2>
          <p> &emsp; This is our Inventory page allows you to easily find and filter all of our items in our store.</p>
          <br>
         
          <!-- -------------------------Category Dropdown List-------------------------------------- -->
          <form name="catform" action="" method="post">
        <div>


                 &emsp; <label for="cat"><u>Choose a Category:</u></label>
        <select id="cat" name="cat" onchange="this.form.submit()">


            <?php 

              if(isset($categoryVar))
              {
                echo "<option value=".$categoryVar.">".$categoryVar."</option>";
              }
              echo "<option value='Category|Category'>Category</option>";
              $sql = mysqli_query($con, "SELECT CatID, Category FROM Category Where CatID !=0");
              while ($row = $sql->fetch_assoc())
              {
                echo "<option value='".$row['CatID']."|". $row['Category'] ."''>" . $row['Category'] . "</option>";
              }
            ?>
              
        </select>
        <br>

      </form>


        <!-- -----------------------------Filter Specific--------------------------------------------------------- -->
          <form name="specform" action="" method="post">   

       &emsp; <label for="spec"><u>Specific item:</u></label>

      <select id="spec" name="spec" onchange="this.form.submit()">
          


          <?php 

            if(isset($nameVar))
            {
              echo "<option value='".$categoryVar."|" .$nameVar."|".$priceVar."|".$itemCodeVar."'>" .$nameVar. "</option>";
            }

            //if(!($categoryVar = "Category" && $var2 = "Letters"))
            //{
                                // and Description Like \"$var2%\"          '".$post_uri."'
          $sql = mysqli_query($con, "SELECT i.Description AS Description, i.Price AS Price, i.ItemCode AS ItemCode 
                         FROM Item i INNER JOIN Item_Category ic
                         ON i.ItemCode = ic.ItemCode
                         INNER JOIN Category c
                         ON    c.CatID    = ic.CatID
                         WHERE c.Category = \"".$categoryVar."\";");
                         //AND   i.Description LIKE \"".$var2."%\";");
          //}
          //$catIDVar  
            //$categoryVar
          
          echo "<option value='".$categoryVar."|Specific|PriceVar|ItemCodeVar'>Specific</option>";
          while ($row = mysqli_fetch_assoc($sql)){
          echo "<option value='".$categoryVar."|" .$row['Description']."|".$row['Price']."|".$row['ItemCode']."'>" . $row['Description'] . "</option>";
          }

          //          while (($row2 = mysqli_fetch_assoc($sql)) != false) {
          //   if ($id == $row2["Description"]) $selected = " selected";
          //   else $selected = "";

          //   echo "<option value='{$row2['Description']}$selected>{$row2['Description']}</option>";
          // }      
        ?>

      </select>
      </form>
<!-- ----------------------------------------------------------------------------------------------------------------------- -->




    


<!-- ------------------------------------------------------------------------------------------------------------------- -->
      <br><br>


          <!-- -------$nameVar-------------$priceVar---------$itemCodeVar------------------------------- -->
          
          <p> &emsp; &emsp;Item Name:&emsp; <span id="nameVar"><?php if(isset($nameVar) && ($nameVar != '')){echo $nameVar;}else{echo "UknownName";} ?></span>              <br>
            &emsp; &emsp;Price:&emsp;&emsp;&emsp;&emsp;<span id="priceVar"><?php if(isset($priceVar) && ($priceVar!= '')){echo "$".$priceVar."";}else{echo "UknownPrice";} ?></span>    <br>
            &emsp; &emsp;ItemCode:&emsp;&ensp; <span id="itemCodeVar"><?php if(isset($itemCodeVar) && ($itemCodeVar != '')){echo "#".$itemCodeVar."";}else{echo "UknownitemCode";} ?></span>         </p>

          
          
          <?php if(isset($itemCodeVar) && ($itemCodeVar != '') && ($nameVar != 'Specific')){echo "<img src = '../uploads/".$itemCodeVar.".jpg'  width='270' style='margin:30px; display: block; position: relative; top: -70px;  padding-left:310px;'>";}else{echo '<img src="../images/NF2.png"/>';} ?>
          <br>

            
            
            
        <!-- <input type="reset" id="reset" onfocus="Load()" value="Reset!"><br> -->
        </div>
        


    </div>

    <br>
    <br>


            









    <div id="footer">Copyright &copy; 2018. Design by <a href="" target="_blank">JZM</a><br>
    
    </div>
  
  </div>

</div>

</body></html>