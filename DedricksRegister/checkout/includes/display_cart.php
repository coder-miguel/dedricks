<?php
    
    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }

    $cartindex = 0;
    foreach ($_SESSION['cart'] as $cart) {

        if( isset($cart['item']) && isset($cart['meas']) &&isset($cart['qty']) && isset($cart['measqty']) ) {

            $item  = $cart['item'];

            $itemcode  = $item['ItemCode'];
            $showitemcode = sprintf("%04d",$itemcode);

            $price     = $item['Price'];
            $showprice = number_format($price, 2, '.', '');
            
            $qty       = $cart['qty'];
            $meas      = $cart['meas'];

            $measqty   = $cart['measqty'];
            if((double)$measqty == (double)((int)$measqty))
                $showmeasqty = (int)$measqty;
            else
                $showmeasqty = $measqty;

            $weight = $item['Weight'];
            if((double)$weight == (double)((int)$weight))
                $showweight = (int)$weight;
            else
                $showweight = $weight;
            
            
            $descr         = $item['Description'];
            $fulldescript1 = $showitemcode." ".$descr." (".$showmeasqty." ".$meas.")";
            $fulldescript2 = "  \$".$showprice."/".$showweight." ".$meas;

            $val   = "$itemcode|$measqty";
            
            echo "<div style='position:relative;width:100%; height:100%'>

                        <label class='itemrow' for='$cartindex' style='width:100%;height:100%; position:relative'>
                            <span class='pb' style='float:right' onclick='addTo(\"$cartindex\")'>+&nbsp</span>
                            <span class='mb' style='float:right' onclick='rmFrom(\"$cartindex\")'>-&nbsp</span>
                            <span            style='margin-left: 16px; float:left; font-size:18px'>  $fulldescript1</span>
                            <span            style='margin-left: 16px; float:right'                id='qty$cartindex'>$qty</span>
                            <span            style='margin-left: 16px; float:right; font-size:18px;'> $fulldescript2</span>
                        </label>
                        <span style='display:none; margin-left: 16px; float:left'        id='mqt$cartindex'>$measqty</span>
                        <span style='display:none; margin-left: 16px; float:left'        id='wgt$cartindex'>$weight</span>
                        <span style='display:none; style='margin-left: 16px; float:left' id='prc$cartindex'>$price</span>
                    
                    ";
            echo "<input type='hidden' id ='$cartindex' name='$cartindex' value='$val'></div>";
            $cartindex++;
        }
    }
    //

?>