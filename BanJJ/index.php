<?php 
// 定义ThinkPHP框架路径
define('THINK_PATH', '../ThinkPHP/ThinkPHP');
//定义项目名称和路径
define('APP_NAME', 'BanJJ');
define('APP_PATH', '.');
define('STRIP_RUNTIME_SPACE',false);
// 加载框架入口文件 
require(THINK_PATH."/ThinkPHP.php");

//实例化一个网站应用实例
$App = new App(); 
//应用程序初始化
$App->run();
?>