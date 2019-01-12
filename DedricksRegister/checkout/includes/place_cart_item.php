<!DOCTYPE html>
<html>


    <head>
        <meta charset="UTF-8">
        <title>Checkout</title>
        <link href="../css/style.css" rel="stylesheet" type="text/css">
        <link href="../css/register.css" rel="stylesheet" type="text/css">

    </head>

    <body>

<?php

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }


    //We can get here two ways:
    //UPC scanner scans and brings us here
    //But if there were two items with the same UPC code, 

    if(isset($_GET['upc']))
    {
        $gotupc  = $_GET['upc'];

        
        require("../php/db_con.php");

        $stmt = mysqli_stmt_init($con);
        $stmt = mysqli_prepare($con, "SELECT * FROM Item WHERE UPC = ?;");
        mysqli_stmt_bind_param($stmt, "s", $gotupc);
        mysqli_execute($stmt);
        $getresults = mysqli_stmt_get_result($stmt);

        while ($row = mysqli_fetch_assoc($getresults))
        {
                $results[] = $row;
        }

        //No results found, Item Not Found message, and return
        if(!isset($results) || count($results)==0){

            echo "
                    <div class=\"center-modal\" style=\"top:0px\">
                        <form class=\"choose-item animate-zoom\" id=\"inf\" style=\"width:10%; align-items:center\">
                            <div class=\"container\" style=\"top:0; height:60%\">
                                <h1>Item Not Found</h1>
                            </div>
                            <div class=\"container\" style=\"top:0; padding:0; height:30%\">
                                <button type=\"submit\">Ok</button>
                            </div>
                        </form>
                    </div>";
        //----------------------------------------------------------------------------------------------------------------------------
        //More than one item with the same UPC: Form to choose which item, then form submit back here with $_GET['itemcode']
        }else if(count($results)>1){
            echo "
                    <div class=\"center-modal\">
                        <form class=\"choose-item animate-zoom\" id=\"chs\" action=\"includes/place_cart_item.php\" method=\"get\">
                            <div class=\"container\" style=\"top:0; height:60%\">
                                <h1>Many Items with the Same UPC
                                <br>Select Product</h1><br>
                        ";
            $radio_id = 1;
            foreach ($results as $res) {
                
                $result_itemcode = $res['ItemCode'];
                $result_descript = $res['Description'];
                $result_price    = number_format($res['Price'], 2, '.', '');

                echo "

                <input name=\"itemcode\" value=\"$result_itemcode\" type=\"radio\" id=\"rd".$radio_id."\" required>
                      <label class=\"radioitem\" for=\"rd".$radio_id."\"> $result_descript \$$result_price </label><br>";

                $radio_id++;
            }

            echo "              <div class=\"container\" style=\"top:0; height:30%\">
                                    <button type=\"button\" onclick=\"window.location = '../checkout'\" class=\"cancelbtn\">Cancel</button>
                                    <button type=\"submit\" style=\"right:5px; width:auto\">Sumbit</button>
                                </div>
                            </div>
                        </form>
                    </div>";
        //----------------------------------------------------------------------------------------------------------------------------
        //A Single Result
        }else{
            $result = $results[0];
        }

    //If I got an Item Code, then I have a single Result
    }else if(isset($_GET['itemcode'])){

        $gotitemcode = $_GET['itemcode'];

        require("../../php/db_con.php");

        $stmt = mysqli_stmt_init($con);
        $stmt = mysqli_prepare($con, "SELECT * FROM Item WHERE ItemCode = ?;");
        mysqli_stmt_bind_param($stmt, "s", $gotitemcode);
        mysqli_execute($stmt);
        $result = mysqli_stmt_get_result($stmt);
        $result = mysqli_fetch_assoc($result);

    }else if(isset($_GET['remove']))
    {
        $ic = $_GET['id1'];
        $mq = $_GET['id2'];
        $icmq = $ic."".$mq;
        unset($_SESSION['cart'][$icmq]);
        header("location: ../");
    } 



    //should have a single result by this point
    if(isset($result))
    {


        //determine item
        $finitem = $result;

        //determine meas
        $finmeas = $_SESSION['measurements'][$finitem['MeasID']];



        //If item is sold by weight
        if ($finitem['EaYN'] == 0){

            if(strlen(($finitem['Description']) > 10)){
                $abbrev = substr($finitem['Description'], 0, 10);
            }
            else{
                $abbrev = $finitem['Description'];
            }

            $shprice = number_format($finitem['Price'], 2, '.', '');

            $fweight = $finitem['Weight'];
            if(  (double)$fweight == (double)((int)$fweight)   ){
                $shweight = (int)$fweight;
            }else{
                $shweight = number_format($fweight, 2, '.', '');
            }


            echo "
                <div class=\"center-modal\" onclick=\"gimfocus()\" style=\"top:0px;\" >

                    <form   class=\"choose-item animate-zoom\"
                            id=\"wmf\" style=\"width:30%; height: auto\"
                            action=\"index.php\" method=\"post\">

                        <div class=\"\">
                            <h2 style=\"text-align:center\">Weight Required for<br>"
                            .$abbrev." \$".$shprice."/".$shweight." ".$finmeas." </h2>
                        </div>
                        
                        <div class=\"main_panel\">
                            <input  id=\"enterweight\"
                                    placeholder=\"enter $finmeas\"
                                    type=\"text\"
                                    pattern=\"^\d*(\.\d{0,4})?$\"
                                    min=\"0\"
                                    name=\"measqty\"
                                    style=\"width:95%\" required>
                                    
                            <div class=\"number_button sp\" onmousedown=\"number_write(7);\">7</div>
                            <div class=\"number_button sp\" onmousedown=\"number_write(8);\">8</div>
                            <div class=\"number_button sp\" onmousedown=\"number_write(9);\">9</div>
                            <div class=\"number_button sp\" onmousedown=\"number_write(4);\">4</div>
                            <div class=\"number_button sp\" onmousedown=\"number_write(5);\">5</div>
                            <div class=\"number_button sp\" onmousedown=\"number_write(6);\">6</div>
                            <div class=\"number_button sp\" onmousedown=\"number_write(1);\">1</div>
                            <div class=\"number_button sp\" onmousedown=\"number_write(2);\">2</div>
                            <div class=\"number_button sp\" onmousedown=\"number_write(3);\">3</div>
                            <div class=\"number_button sp\" onmousedown=\"number_clear();\">Clr</div>
                            <div class=\"number_button sp\" onmousedown=\"number_write(0);\">0</div>
                            <div class=\"number_button sp\" onmousedown=\"number_write('.');\">.</div>
                            <div class=\"number_button sp\" onmousedown=\"number_c();\">C</div>

                            <button style=\"position:relative; top:0; width:95%; background-color:green\" type=\"submit\" >Submit</button>
                        </div>


                    </form>



                </div>

                <script type=\"text/javascript\">

                    function gimfocus(){
                        upcfocus = false;
                        document.getElementById(\"enterweight\").focus();
                    }  

                    gimfocus();

                    function number_write(x)
                    {
                        var text_box = document.getElementById(\"enterweight\");
                        text_box.value = text_box.value + \"\" + x;
                      
                    }

                    function number_clear()
                    {
                        document.getElementById(\"enterweight\").value = \"\";
                    }

                    function number_c()
                    {
                        var text_box = document.getElementById(\"enterweight\");
                        text_box.value = text_box.value.slice(0,-1);

                    }                      

                </script>";

                $_SESSION['tempitem'] = $finitem;
                $_SESSION['tempmeas'] = $finmeas;
        }else{     


            //insertion point
            $finmeasqty = $finitem['Weight'];
            $cartindex  = $finitem['ItemCode']."".$finmeasqty;

            if(!isset($_SESSION['cart'][$cartindex])){
                
                $_SESSION['cart'][$cartindex] = array('item' => $finitem,'meas' => $finmeas, 'measqty' => $finmeasqty);
                $_SESSION['cart'][$cartindex]['qty'] = 1;
            }else{
                $_SESSION['cart'][$cartindex]['qty']++;
            }

            //end insertion
            if(isset($_GET['upc']))
                header("location: ?item=found");
            else
                header("location: ../?item=found");
        }

    }

?>
    </body>
    <script type="text/javascript">
        function focus(id){
            document.getElementById(id).focus();
        }

        function keySubmit(e, id){
            if(e.keyCode == 27 || e.keyCode == 13){
                    document.getElementById(id).submit();
                }
        }


    </script>
</html>