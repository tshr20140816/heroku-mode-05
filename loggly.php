<?php

$pid = getmypid();

error_log($pid . ' ***** LOGGLY STDIN START ***** ');
error_log($pid . ' ' . file_get_contents('php://stdin'));
error_log($pid . ' ***** LOGGLY STDIN FINISH ***** ');

?>