<?php require ("../php/selection.php"); ?>

			
<?php 
					$server_name = "localhost";
				    $user_name   = "root";
				    $password    = "";
				    $db_name     = "dedricks";

				    // establish a connection with mysql
				    $con = mysqli_connect($server_name,$user_name,$password,$db_name);


			      
$tableChoice	= $_POST["tables"]?? 'nobody';
$attrChoice     = $_POST["tables2"]?? 'nobody';		       
												
$sql = "SELECT ".$attrChoice." FROM ".$tableChoice." ";

$test = "SELECT key_column_usage.column_name
FROM   information_schema.key_column_usage
WHERE  table_schema = schema()             
AND    constraint_name = 'PRIMARY'        
AND    table_name = '".$tableChoice."';";

$testresult = mysqli_query($con,$test);
//echo $testresult;

     $row = $testresult->fetch_assoc();
$a = ($row['column_name']);

//-----This is Used to find ID of Table



//echo $test;
if ($attrChoice == 'NotSet') {
	$sql = "SELECT * FROM ".$tableChoice." ";
}
else{
	$sql = "SELECT ".$a.",".$attrChoice." FROM ".$tableChoice." "; //This is to see the Id along with the Item
	//$sql = "SELECT ".$attrChoice." FROM ".$tableChoice." ";
}


// ----------------------------
 


// -------



?>





<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Dedricks Farm to Market</title>
<link href="../css/databasesettings.css" rel="stylesheet" type="text/css">
<script src="../js/ism-2.2.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    <!-- Start Active Page -->
         <script src=http://code.jquery.com/jquery-2.1.4.min.js></script> <!-- active page element -->
   

<script type="text/javascript">
	
function displaySelect() {
	//window.alert("ranselect");
    var x = document.getElementById("tables");
    var y = document.getElementById("tables2");
    if (x.value != "NotSet")
    {
    	//window.alert("if");
     y.style.visibility = 'visible';
    }
    else
    {
    	//window.alert("else");
    	 y.style.visibility = 'hidden';
    }

}


</script>

<script type="text/javascript">
	


function load() {
    	var x = document.getElementById("tables2");
    	document.getElementById("tables").value = '<?php echo $tableChoice ;?>';

}



</script>







<body onload="load();">

<br><br><br><br><br><br>
<h1>Database Tables</h1>

<br>
<!-- ---------------------------------------------------- -->



<!-- ---------------------------------------------- -->

<form class="demo" method="post">
</style>    
&emsp;<select id="tables" name="tables" onchange="this.form.submit()">
        <option selected value="NotSet">Select Table</option>
        <option value="Category">   		Category 	     	</option>
        <option value="Manufacturer">   	Manufacturer  	 	</option>
        <option value="Measurement">   		Measurement  	 	</option>
        <option value="Picture">   			Picture   		 	</option>
        <option value="Item">  			    Item  			 	</option>
        <option value="Item_Category">   	Item_Category   	</option>
        <option value="Seasonal_Item">   	Seasonal_Item   	</option>
        <option value="ZIP">   				ZIP   			 	</option>
        <option value="AddressBook">   		AddressBook  	 	</option>
        <option value="AddressBook_Optional">   	AddressBook_Optional   </option>
        <option value="Job_Title">   		Job_Title  	 		</option>
        <option value="Salary_Wage">   		Salary_Wage	 		</option>
        <option value="Hours_Log">   		Hours_Log  	 		</option>
        <option value="Employee">   		Employee  		 	</option>
        <option value="Supplier">   		Supplier   	 		</option>
        <option value="Supply_Order">   	Supply_Order    	</option>
        <option value="Supplied_Item">   	Supplied_Item   	</option>
        <option value="Customer">   		Customer   	 		</option>
        <option value="Cart">   			Cart  			 	</option>
        <option value="Customer_Order">   	Customer_Order  	</option>
        <option value="Cart_Item">   		Cart_Item   	 	</option>
</select>

&emsp;<select id="tables2" name="tables2" onchange="this.form.submit()">
        <option selected value="NotSet">Select Table 			</option>
        <option value="*">   				All Data 	     		</option>
        <?php 

        $fields = mysqli_query($con,"SHOW columns FROM ".$tableChoice."");
							while($row = mysqli_fetch_array($fields))
							{
								echo "<option value='". $row['Field'] ."''>" . $row['Field'] . "</option>";
							}



        ?>

        
</select>
</form>


<?php 
if(isset($_POST["tables"]) && $tableChoice != 'NotSet') {
$result = mysqli_query($con,$sql);
echo "<table border='1'>";

$i = 0;
while($row = $result->fetch_assoc())
{
    if ($i == 0) {
      $i++;
      echo "<tr>";
      foreach ($row as $key => $value) {
        echo "<th>" . $key . "</th>";
      }
      echo "</tr>";
    }
    echo "<tr>";
    foreach ($row as $value) {
      echo "<td>" . $value . "</td>";
    }
    echo "</tr>";
}
echo "</table>";
}
mysqli_close($con);

 ?>




						





    
    
    </div>
	
  </div>

</div>

</body></html>