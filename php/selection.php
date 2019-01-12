

<?php 




function processDrpdown($selectedVal) {
    //echo "Selected value in php ".$selectedVal;
}        
		//$var= "default";


		// 
		// 
		// $var3=$_POST['spec'];

		
		if(isset($_POST["cat"]) && 
		explode("|", $_POST['cat'])[1] !="Category")
		{

			// if ($var !=) {
			// 	# code...
			// }
			
			$var=explode("|", $_POST['cat']);
			$catIDVar    = $var[0];
			$categoryVar = $var[1];
			//echo $categoryVar;
			// echo "cat has been submitted";
			// $var2=$_POST['let'];
		}
		else if (isset($_POST["spec"]))
		{
			//echo "spec has been submitted";
			$var3=explode("|", $_POST['spec']);
			$categoryVar =$var3[0];
			$nameVar     =$var3[1];
			$priceVar    =$var3[2];
			$itemCodeVar =$var3[3];
		}
		else




		// if ($var){
		     
		//    		 processDrpdown($var);
		    
		// 		 }





?>
