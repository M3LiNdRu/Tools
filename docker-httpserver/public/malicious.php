<?php

    $fitxer = './notas.php';

    if (file_exists($fitxer) && is_readable($fitxer)) {

        $contingut = file_get_contents($fitxer);
        
        $contingutEscapat = htmlspecialchars($contingut);

        echo "<pre>$contingutEscapat</pre>";
    } else {
        echo "El fitxer no existeix o no es pot llegir.";
    }
?>
