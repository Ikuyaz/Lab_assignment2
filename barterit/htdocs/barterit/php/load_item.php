<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$results_per_page = 6;

if (isset($_POST['pageNo'])) {
    $pageNo = $_POST['pageNo'];
} else {
    $pageNo = 1;
}
$page_first_result = ($pageNo - 1) * $results_per_page;

if (isset($_POST['userid'])) {
    $userid = $_POST['userid'];
    $sqlloaditems = "SELECT * FROM `tbl_items` WHERE user_id = '$userid'";
} else if (isset($_POST['search'])) {
    $search = $_POST['search'];
    $sqlloaditems = "SELECT * FROM `tbl_items` WHERE item_name LIKE '%$search%'";
} else {
    $sqlloaditems = "SELECT * FROM `tbl_items`";
}

$result = $conn->query($sqlloaditems);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloaditems = $sqlloaditems . " LIMIT $page_first_result, $results_per_page";
$result = $conn->query($sqlloaditems);

if ($result->num_rows > 0) {
    $items["items"] = array();
    while ($row = $result->fetch_assoc()) {
        $item = array();
        $item['item_id'] = $row['item_id'];
        $item['userid'] = $row['user_id'];
        $item['item_name'] = $row['item_name'];
        $item['item_type'] = $row['item_type'];
        $item['item_desc'] = $row['item_desc'];
        $item['item_interest'] = $row['item_interest'];
        $item['item_lat'] = $row['item_lat'];
        $item['item_long'] = $row['item_long'];
        $item['item_state'] = $row['item_state'];
        $item['item_locality'] = $row['item_locality'];
        $item['item_date'] = $row['item_date'];

        array_push($items["items"], $item);
    }
    $response = array(
        'status' => 'success',
        'data' => $items,
        'numofpage' => $number_of_page,
        'numberofresult' => $number_of_result
    );
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null, 'sql'=> $sqlloaditems);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
