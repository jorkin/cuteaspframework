<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">  

<html>  

<head>  

<title><?php echo $title ?></title>  

</head>  

<body>  

<?php if(isset($list)): ?><?php $i = 0; ?><?php if( count($list)==0 ) echo "" ?><?php foreach($list as $key=>$vo): ?><?php ++$i;?><?php $mod = (($i % 2 )==0)?>[ <?php echo is_array($vo)?$vo["title"]:$vo->title ?> ] <?php echo is_array($vo)?$vo["content"]:$vo->content ?><br/><?php endforeach; ?><?php endif; ?>  
</body>  

</html>