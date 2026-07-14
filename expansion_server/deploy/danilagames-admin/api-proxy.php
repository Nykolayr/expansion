<?php
/** HTTPS proxy: /admin/api/* → VPS */

function dg_get_authorization_header() {
    if (!empty($_SERVER['HTTP_AUTHORIZATION'])) {
        return $_SERVER['HTTP_AUTHORIZATION'];
    }
    if (!empty($_SERVER['REDIRECT_HTTP_AUTHORIZATION'])) {
        return $_SERVER['REDIRECT_HTTP_AUTHORIZATION'];
    }
    if (function_exists('apache_request_headers')) {
        $headers = apache_request_headers();
        if (is_array($headers)) {
            foreach ($headers as $key => $value) {
                if (strtolower($key) === 'authorization') {
                    return $value;
                }
            }
        }
    }
    return null;
}

$vpsBase = 'http://46.173.25.193/api';
$requestUri = isset($_SERVER['REQUEST_URI']) ? $_SERVER['REQUEST_URI'] : '';
$prefix = '/admin/api';
$pos = strpos($requestUri, $prefix);
$path = ($pos === false) ? '' : substr($requestUri, $pos + strlen($prefix));
if ($path === '' || $path[0] !== '/') {
    $path = '/' . ltrim($path, '/');
}
$target = $vpsBase . $path;

$method = isset($_SERVER['REQUEST_METHOD']) ? $_SERVER['REQUEST_METHOD'] : 'GET';
$headers = array('Accept: application/json');

$auth = dg_get_authorization_header();
if (!empty($auth)) {
    $headers[] = 'Authorization: ' . $auth;
}

$contentType = isset($_SERVER['CONTENT_TYPE']) ? $_SERVER['CONTENT_TYPE'] : '';
if (!empty($contentType)) {
    $headers[] = 'Content-Type: ' . $contentType;
}

$body = file_get_contents('php://input');

$ch = curl_init($target);
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch, CURLOPT_TIMEOUT, 30);
if ($method !== 'GET' && $method !== 'HEAD' && $body !== false) {
    curl_setopt($ch, CURLOPT_POSTFIELDS, $body);
}

$response = curl_exec($ch);
if ($response === false) {
    http_response_code(502);
    header('Content-Type: application/json');
    echo json_encode(array('error' => 'proxy failed', 'code' => 'PROXY'));
    exit;
}

$status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$headerSize = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
curl_close($ch);

$responseBody = substr($response, $headerSize);

http_response_code($status);
header('Content-Type: application/json');
echo $responseBody;
