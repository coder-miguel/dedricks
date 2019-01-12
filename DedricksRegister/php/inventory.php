<?php
    $upc = $_GET['upc'];
    $results;

    foreach ($_SESSION['inventory'] as $item) {//check all items in the inventory for that upc
           $item_upc   = (int)$item['UPC'];
        if($item_upc  == (int)$upc){
            $results[] = $item;
        }
    }

    if(count($results)==0){

        echo "
                <div class=\"center-modal\" id=\"cm1\" style=\"top:0px\">
                    <form class=\"choose-item animate-zoom\" style=\"width:10%; align-items:center\">
                        <div class=\"container\" style=\"top:0; height:60%\">
                            <h1>Item Not Found</h1>
                        </div>
                        <div class=\"container\" style=\"top:0; padding:0; height:30%\">
                            <button type=\"button\" onclick=\"hideCenterModal()\">Ok</button>
                        </div>
                    </form>
                </div>";
    }else if(count($results)>1){
        echo "
                <div class=\"center-modal\" id=\"cm1\">
                    <form class=\"choose-item animate-zoom\" action=\"index.php\" method=\"get\">
                        <div class=\"container\" style=\"top:0; height:60%\">
                            <h1>Many Items with the Same UPC
                            <br>Select Product</h1><br>
                    ";
        $radio_id = 1;
        foreach ($results as $result) {
            
            $result_itemcode = $result['ItemCode'];
            $result_descript = $result['Description'];
            //$result_price    = htmlspecialchars(money_format('%.2n', $result['Price']));
            $result_price    =number_format($result['Price'], 2, '.', '');

            // <input name="itemcode" value="0001" type="radio" id="1">
            //     <label class="radioitem" for="1">Blueberries</label><br>
            echo "

            <input name=\"itemcode\" value=\"$result_itemcode\" type=\"radio\" id=\"$radio_id\">
                  <label class=\"radioitem\" for=\"$radio_id\"> $result_descript \$$result_price </label><br>";

            $radio_id++;
        }

        echo "
                            <div class=\"container\" style=\"top:0; height:30%\">
                                <button type=\"button\" onclick=\"hideCenterModal()\" class=\"cancelbtn\">Cancel</button>
                                <button type=\"submit\" style=\"right:5px; width:auto\">Sumbit</button>
                            </div>
                        </div>
                    </form>
                </div>";
    }else{

        $_SESSION['results'] = $results;
        header("location: ")
        //var_dump($results);
        //include('place_cart_item.php');
    }
?>