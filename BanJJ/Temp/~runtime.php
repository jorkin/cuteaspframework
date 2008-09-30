<?php 
// +----------------------------------------------------------------------
// | ThinkPHP                                                             
// +----------------------------------------------------------------------
// | Copyright (c) 2008 http://thinkphp.cn All rights reserved.      
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>                                  
// +----------------------------------------------------------------------
// $Id$

/**
 +------------------------------------------------------------------------------
 * 系统定义文件
 +------------------------------------------------------------------------------
 * @category   Think
 * @package  Common
 * @author   liu21st <liu21st@gmail.com>
 * @version  $Id$
 +------------------------------------------------------------------------------
 */
if (!defined('THINK_PATH')) exit();
//	 系统信息
@set_magic_quotes_runtime (0);
define('MAGIC_QUOTES_GPC',get_magic_quotes_gpc()?True:False);
define('OUTPUT_GZIP_ON',ini_get('output_handler') || ini_get('zlib.output_compression') );
define('MEMORY_LIMIT_ON',function_exists('memory_get_usage')?true:false);
// 记录内存初始使用
if(MEMORY_LIMIT_ON) {
	 $GLOBALS['_startUseMems'] = memory_get_usage();
}
define('PHP_SAPI_NAME',php_sapi_name());
define('IS_APACHE',strstr($_SERVER['SERVER_SOFTWARE'], 'Apache') || strstr($_SERVER['SERVER_SOFTWARE'], 'LiteSpeed') );
define('IS_IIS',PHP_SAPI_NAME =='isapi' ? 1 : 0);
define('IS_CGI',substr(PHP_SAPI_NAME, 0,3)=='cgi' ? 1 : 0 );
define('IS_WIN',strstr(PHP_OS, 'WIN') ? 1 : 0 );
define('IS_LINUX',strstr(PHP_OS, 'Linux') ? 1 : 0 );
define('IS_FREEBSD',strstr(PHP_OS, 'FreeBSD') ? 1 : 0 );
define('NOW',time() );

// 当前文件名
if(!defined('_PHP_FILE_')) {
	if(IS_CGI) {
		//CGI/FASTCGI模式下
		$_temp  = explode('.php',$_SERVER["PHP_SELF"]);
		define('_PHP_FILE_',  rtrim(str_replace($_SERVER["HTTP_HOST"],'',$_temp[0].'.php'),'/'));
	}else {
		define('_PHP_FILE_',	rtrim($_SERVER["SCRIPT_NAME"],'/'));
	}
}
if(!defined('WEB_URL')) {
	// 网站URL根目录
	if( strtoupper(APP_NAME) == strtoupper(basename(dirname(_PHP_FILE_))) ) {
		$_root = dirname(dirname(_PHP_FILE_));
	}else {
		$_root = dirname(_PHP_FILE_);
	}
	define('WEB_URL',	(($_root=='/' || $_root=='\\')?'':$_root));
}

define('VENDOR_PATH',THINK_PATH.'/Vendor/');
// 为了方便导入第三方类库 设置Vendor目录到include_path
set_include_path(get_include_path() . PATH_SEPARATOR . VENDOR_PATH);

// 目录设置
define('CACHE_DIR',  'Cache'); 
define('HTML_DIR',    'Html'); 
define('CONF_DIR',    'Conf');
define('LIB_DIR',        'Lib');
define('LOG_DIR',      'Logs');
define('LANG_DIR',    'Lang');
define('TEMP_DIR',    'Temp');
define('TMPL_DIR',     'Tpl'); 
// 路径设置
if (!defined('ADMIN_PATH')) define('ADMIN_PATH', APP_PATH.'/../Admin/');
define('TMPL_PATH',APP_PATH.'/'.TMPL_DIR.'/'); 
define('HTML_PATH',APP_PATH.'/'.HTML_DIR.'/'); //
define('COMMON_PATH',	APP_PATH.'/Common/'); // 项目公共目录
define('LIB_PATH',         APP_PATH.'/'.LIB_DIR.'/'); //
define('CACHE_PATH',   APP_PATH.'/'.CACHE_DIR.'/'); //
define('CONFIG_PATH',  APP_PATH.'/'.CONF_DIR.'/'); //
define('LOG_PATH',       APP_PATH.'/'.LOG_DIR.'/'); //
define('LANG_PATH',     APP_PATH.'/'.LANG_DIR.'/'); //
define('TEMP_PATH',      APP_PATH.'/'.TEMP_DIR.'/'); //
define('UPLOAD_PATH', APP_PATH.'/Uploads/'); //
define('PLUGIN_PATH', APP_PATH.'/PlugIns/'); //
define('DATA_PATH', APP_PATH.'/Data/'); //


// 	调试和Log设置
define('WEB_LOG_ERROR',0);
define('WEB_LOG_DEBUG',1);
define('SQL_LOG_DEBUG',2);

define('SYSTEM_LOG',0);
define('MAIL_LOG',1);
define('TCP_LOG',2);
define('FILE_LOG',3);

define('DATA_TYPE_OBJ',1);
define('DATA_TYPE_ARRAY',0);

//支持的URL模式
define('URL_COMMON',      0);   //普通模式
define('URL_PATHINFO',    1);   //PATHINFO模式
define('URL_REWRITE',     2);   //REWRITE模式

//	版本信息
define('THINK_VERSION', '1.0.4');
?><?php 
// +----------------------------------------------------------------------
// | ThinkPHP                                                             
// +----------------------------------------------------------------------
// | Copyright (c) 2008 http://thinkphp.cn All rights reserved.      
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>                                  
// +----------------------------------------------------------------------
// $Id$

/**
 +------------------------------------------------------------------------------
 * Think公共函数库
 +------------------------------------------------------------------------------
 * @category   Think
 * @package  Common
 * @author   liu21st <liu21st@gmail.com>
 * @version  $Id$
 +------------------------------------------------------------------------------
 */

function mk_dir($dir, $mode = 0755)
{
  if (is_dir($dir) || @mkdir($dir,$mode)) return true;
  if (!mk_dir(dirname($dir),$mode)) return false;
  return @mkdir($dir,$mode);
}

/**
 +----------------------------------------------------------
 * 判断目录是否为空
 +----------------------------------------------------------
 * @return void
 +----------------------------------------------------------
 */
function empty_dir($directory)
{
    $handle = opendir($directory);
    while (($file = readdir($handle)) !== false)
    {
        if ($file != "." && $file != "..")
        {
            closedir($handle);
            return false;
        }
    }
    closedir($handle);
    return true;
}

function get_client_ip(){
   if (getenv("HTTP_CLIENT_IP") && strcasecmp(getenv("HTTP_CLIENT_IP"), "unknown"))
       $ip = getenv("HTTP_CLIENT_IP");
   else if (getenv("HTTP_X_FORWARDED_FOR") && strcasecmp(getenv("HTTP_X_FORWARDED_FOR"), "unknown"))
       $ip = getenv("HTTP_X_FORWARDED_FOR");
   else if (getenv("REMOTE_ADDR") && strcasecmp(getenv("REMOTE_ADDR"), "unknown"))
       $ip = getenv("REMOTE_ADDR");
   else if (isset($_SERVER['REMOTE_ADDR']) && $_SERVER['REMOTE_ADDR'] && strcasecmp($_SERVER['REMOTE_ADDR'], "unknown"))
       $ip = $_SERVER['REMOTE_ADDR'];
   else
       $ip = "unknown";
   return($ip);
}

/**
 +----------------------------------------------------------
 * URL组装 支持不同模式和路由
 +----------------------------------------------------------
 * @param string $action 操作名
 * @param string $module 模块名
 * @param string $app 项目名
 * @param string $route 路由名
 * @param array $params 其它URL参数
 +----------------------------------------------------------
 * @return string
 +----------------------------------------------------------
 */
function url($action=ACTION_NAME,$module=MODULE_NAME,$route='',$app=APP_NAME,$params=array()) {
	if(C('DISPATCH_ON') && C('URL_MODEL')>0) {
		switch(C('PATH_MODEL')) {
			case 1:// 普通PATHINFO模式
				$str	=	'/';
				foreach ($params as $var=>$val)
					$str .= $var.'/'.$val.'/';
				$str = substr($str,0,-1);
				if(!empty($route)) {
					$url	=	str_replace(APP_NAME,$app,__APP__).'/'.C('VAR_ROUTER').'/'.$route.'/'.$str;
				}else{
					$url	=	str_replace(APP_NAME,$app,__APP__).'/'.C('VAR_MODULE').'/'.$module.'/'.C('VAR_ACTION').'/'.$action.$str;
				}
				break;
			case 2:// 智能PATHINFO模式
				$depr	=	C('PATH_DEPR');
				$str	=	$depr;
				foreach ($params as $var=>$val)
					$str .= $var.$depr.$val.$depr;
				$str = substr($str,0,-1);
				if(!empty($route)) {
					$url	=	str_replace(APP_NAME,$app,__APP__).'/'.$route.$depr.$str;
				}else{
					$url	=	str_replace(APP_NAME,$app,__APP__).'/'.$module.$depr.$action.$str;
				}
				break;
		}
		if(C('HTML_URL_SUFFIX')) {
			$url .= C('HTML_URL_SUFFIX');
		}	
	}else{
		$params	=	http_build_query($params);
		if(!empty($route)) {
			$url	=	str_replace(APP_NAME,$app,__APP__).'?'.C('VAR_ROUTER').'='.$route.'&'.$params;
		}else{
			$url	=	str_replace(APP_NAME,$app,__APP__).'?'.C('VAR_MODULE').'='.$module.'&'.C('VAR_ACTION').'='.$action.'&'.$params;
		}
	}
	return $url;
}

/**
 +----------------------------------------------------------
 * 错误输出 
 * 在调试模式下面会输出详细的错误信息
 * 否则就定向到指定的错误页面
 +----------------------------------------------------------
 * @param mixed $error 错误信息 可以是数组或者字符串
 * 数组格式为异常类专用格式 不接受自定义数组格式
 +----------------------------------------------------------
 * @return void
 +----------------------------------------------------------
 */
function halt($error) {
    $e = array();
    if(C('DEBUG_MODE')){
        //调试模式下输出错误信息
        if(!is_array($error)) {
            $trace = debug_backtrace();
            $e['message'] = $error;
            $e['file'] = $trace[0]['file'];
            $e['class'] = $trace[0]['class'];
            $e['function'] = $trace[0]['function'];
            $e['line'] = $trace[0]['line'];
            $traceInfo='';
            $time = date("y-m-d H:i:m");
            foreach($trace as $t)
            {
                $traceInfo .= '['.$time.'] '.$t['file'].' ('.$t['line'].') ';
                $traceInfo .= $t['class'].$t['type'].$t['function'].'(';
                $traceInfo .= implode(', ', $t['args']);
                $traceInfo .=")<br/>";
            }
            $e['trace']  = $traceInfo;
        }else {
        	$e = $error;
        }
		if(C('EXCEPTION_TMPL_FILE')) {
			// 定义了异常页面模板
			include C('EXCEPTION_TMPL_FILE');
		}else{
			// 使用默认的异常模板文件
	        include THINK_PATH.'/Tpl/ThinkException.tpl.php';
		}
    }
    else 
    {
        //否则定向到错误页面
		$error_page	=	C('ERROR_PAGE');
        if(!empty($error_page)){
            redirect($error_page); 
        }else {
            $e['message'] = C('ERROR_MESSAGE');
			if(C('EXCEPTION_TMPL_FILE')) {
				// 定义了异常页面模板
				include C('EXCEPTION_TMPL_FILE');
			}else{
				// 使用默认的异常模板文件
				include THINK_PATH.'/Tpl/ThinkException.tpl.php';
			}
        }
    }
    exit;    	
}

/**
 +----------------------------------------------------------
 * URL重定向
 +----------------------------------------------------------
 * @static
 * @access public 
 +----------------------------------------------------------
 * @param string $url  要定向的URL地址
 * @param integer $time  定向的延迟时间，单位为秒
 * @param string $msg  提示信息
 +----------------------------------------------------------
 */
function redirect($url,$time=0,$msg='')
{
    //多行URL地址支持
    $url = str_replace(array("\n", "\r"), '', $url);
    if(empty($msg)) {
        $msg    =   "系统将在{$time}秒之后自动跳转到{$url}！";
    }
    if (!headers_sent()) {
        // redirect
        header("Content-Type:text/html; charset=".C('OUTPUT_CHARSET'));
        if(0===$time) {
        	header("Location: ".$url); 
        }else {
            header("refresh:{$time};url={$url}");
            echo($msg);
        }
        exit();
    }else {
        $str    = "<meta http-equiv='Refresh' content='{$time};URL={$url}'>";
        if($time!=0) {
            $str   .=   $msg;
        }
        exit($str);
    }
}

/**
 +----------------------------------------------------------
 * 自定义异常处理
 +----------------------------------------------------------
 * @param string $msg 错误信息
 * @param string $type 异常类型 默认为ThinkException
 * 如果指定的异常类不存在，则直接输出错误信息
 +----------------------------------------------------------
 * @return void
 +----------------------------------------------------------
 */
function throw_exception($msg,$type='ThinkException',$code=0)
{
    if(isset($_REQUEST[C('VAR_AJAX_SUBMIT')])) {
        header("Content-Type:text/html; charset=utf-8");
        exit($msg);
    }
	if(class_exists($type,false)){
		throw new $type($msg,$code,true);
	}else {
		// 异常类型不存在则输出错误信息字串
		halt($msg);
	}
}

/**
 +----------------------------------------------------------
 *  区间调试开始
 +----------------------------------------------------------
 * @param string $label  标记名称
 +----------------------------------------------------------
 * @return void
 +----------------------------------------------------------
 */
function debug_start($label='')
{
    $GLOBALS[$label]['_beginTime'] = microtime(TRUE);
    if ( MEMORY_LIMIT_ON )	$GLOBALS[$label]['memoryUseStartTime'] = memory_get_usage();
}

/**
 +----------------------------------------------------------
 *  区间调试结束，显示指定标记到当前位置的调试
 +----------------------------------------------------------
 * @param string $label  标记名称
 +----------------------------------------------------------
 * @return void
 +----------------------------------------------------------
 */
function debug_end($label='')
{
    $GLOBALS[$label]['_endTime'] = microtime(TRUE);
    echo '<div style="text-align:center;width:100%">Process '.$label.': Times '.number_format($GLOBALS[$label]['_endTime']-$GLOBALS[$label]['_beginTime'],6).'s ';
    if ( MEMORY_LIMIT_ON )	{
        $GLOBALS[$label]['memoryUseEndTime'] = memory_get_usage();
        echo ' Memories '.number_format(($GLOBALS[$label]['memoryUseEndTime']-$GLOBALS[$label]['memoryUseStartTime'])/1024).' k';
    }
	echo '</div>';
}

/**
 +----------------------------------------------------------
 * 系统调试输出 Log::record 的一个调用方法
 +----------------------------------------------------------
 * @param string $msg 调试信息
 +----------------------------------------------------------
 * @return void
 +----------------------------------------------------------
 */
function system_out($msg)
{
    if(!empty($msg))
        Log::record($msg,WEB_LOG_DEBUG);
}

/**
 +----------------------------------------------------------
 * 变量输出
 +----------------------------------------------------------
 * @param string $var 变量名
 * @param string $label 显示标签
 * @param string $echo 是否显示
 +----------------------------------------------------------
 * @return string
 +----------------------------------------------------------
 */
function dump($var, $echo=true,$label=null, $strict=true)
{
    $label = ($label===null) ? '' : rtrim($label) . ' ';
    if(!$strict) {
        if (ini_get('html_errors')) {
            $output = print_r($var, true);
            $output = "<pre>".$label.htmlspecialchars($output,ENT_QUOTES,C('OUTPUT_CHARSET'))."</pre>";
        } else {
            $output = $label . " : " . print_r($var, true);
        }    	
    }else {
        ob_start();
        var_dump($var);
        $output = ob_get_clean();
        if(!extension_loaded('xdebug')) {
            $output = preg_replace("/\]\=\>\n(\s+)/m", "] => ", $output);
            $output = '<pre>'
                    . $label
                    . htmlspecialchars($output, ENT_QUOTES,C('OUTPUT_CHARSET'))
                    . '</pre>';    	
        }    	
    }
    if ($echo) {
        echo($output);
        return null;
    }else {
    	return $output;
    }
}

/**
 +----------------------------------------------------------
 * 自动转换字符集 支持数组转换
 * 需要 iconv 或者 mb_string 模块支持
 * 如果 输出字符集和模板字符集相同则不进行转换
 +----------------------------------------------------------
 * @param string $fContents 需要转换的字符串
 +----------------------------------------------------------
 * @return string
 +----------------------------------------------------------
 */
function auto_charset($fContents,$from='',$to=''){
	if(empty($from)) $from = C('TEMPLATE_CHARSET');
	if(empty($to))  $to	=	C('OUTPUT_CHARSET');
    if( strtoupper($from) === strtoupper($to) || empty($fContents) || (is_scalar($fContents) && !is_string($fContents)) ){
        //如果编码相同或者非字符串标量则不转换
        return $fContents;
    }
    $from   =  strtoupper($from)=='UTF8'? 'utf-8':$from;
    $to       =  strtoupper($to)=='UTF8'? 'utf-8':$to;
    if(is_string($fContents) ) {
		if(function_exists('mb_convert_encoding')){
            return mb_convert_encoding ($fContents, $to, $from);
        }elseif(function_exists('iconv')){
            return iconv($from,$to,$fContents);
        }else{
            halt(L('_NO_AUTO_CHARSET_'));
            return $fContents;
        }
    }
    elseif(is_array($fContents)){
        foreach ( $fContents as $key => $val ) {
			$_key = 	auto_charset($key,$from,$to);
            $fContents[$_key] = auto_charset($val,$from,$to);
			if($key != $_key ) {
				unset($fContents[$key]);
			}
        }
        return $fContents;
    }
    elseif(is_object($fContents)) {
		$vars = get_object_vars($fContents);
        foreach($vars as $key=>$val) {
            $fContents->$key = auto_charset($val,$from,$to);
        }
        return $fContents;
    }
    else{
        //halt('系统不支持对'.gettype($fContents).'类型的编码转换！');
        return $fContents;
    }
}

/**
 +----------------------------------------------------------
 * 取得对象实例 支持调用类的静态方法
 +----------------------------------------------------------
 * @param string $className 对象类名
 * @param string $method 类的静态方法名
 +----------------------------------------------------------
 * @return object
 +----------------------------------------------------------
 */
function get_instance_of($className,$method='',$args=array()) 
{
    static $_instance = array();
	if(empty($args)) {
		$identify	=	$className.$method;
	}else{
		$identify	=	$className.$method.to_guid_string($args);
	}
    if (!isset($_instance[$identify])) {
        if(class_exists($className)){
            $o = new $className();
            if(method_exists($o,$method)){
                if(!empty($args)) {
                	$_instance[$identify] = call_user_func_array(array(&$o, $method), $args);;
                }else {
                	$_instance[$identify] = $o->$method();
                }
            }
            else 
                $_instance[$identify] = $o;
        }
        else 
            halt(L('_CLASS_NOT_EXIST_'));
    }
    return $_instance[$identify];
}

/**
 +----------------------------------------------------------
 * 系统自动加载ThinkPHP基类库和当前项目的model和Action对象
 * 并且支持配置自动加载路径
 +----------------------------------------------------------
 * @param string $classname 对象类名
 +----------------------------------------------------------
 * @return void
 +----------------------------------------------------------
 */
function __autoload($classname)
{
	// 自动加载当前项目的Actioon类和Dao类
	if(substr($classname,-5)=="Model") {
		if(!import('@.Model.'.$classname)){
			// 如果加载失败 尝试加载组件Dao类库
			import("@.*.Model.".$classname);
		}
	}elseif(substr($classname,-6)=="Action"){
		if(!import('@.Action.'.$classname)) {
			// 如果加载失败 尝试加载组件Action类库
			import("@.*.Action.".$classname);
		}
	}else {
		// 根据自动加载路径设置进行尝试搜索
		if(C('AUTO_LOAD_PATH')) {
			$paths	=	explode(',',C('AUTO_LOAD_PATH'));
			foreach ($paths as $path){
				if(import($path.$classname)) {
					// 如果加载类成功则返回
					return ;
				}
			}
		}
	}
	return ;
}

/**
 +----------------------------------------------------------
 * 反序列化对象时自动回调方法 
 +----------------------------------------------------------
 * @param string $classname 对象类名
 +----------------------------------------------------------
 * @return void
 +----------------------------------------------------------
 */
function unserialize_callback($classname) 
{
	// 根据自动加载路径设置进行尝试搜索
	if(C('CALLBACK_LOAD_PATH')) {
		$paths	=	explode(',',C('CALLBACK_LOAD_PATH'));
		foreach ($paths as $path){
			if(import($path.$classname)) {
				// 如果加载类成功则返回
				return ;
			}
		}
	}
}

/**
 +----------------------------------------------------------
 * 优化的include_once
 +----------------------------------------------------------
 * @param string $filename 文件名
 +----------------------------------------------------------
 * @return boolen
 +----------------------------------------------------------
 */
function include_cache($filename)
{
    static $_importFiles = array();
    if(file_exists($filename)){
        if (!isset($_importFiles[$filename])) {
            include $filename;
            $_importFiles[$filename] = true;
            return true;
        }
        return false;
    }
    return false;
}

$GLOBALS['include_file'] = 0;
/**
 +----------------------------------------------------------
 * 优化的require_once
 +----------------------------------------------------------
 * @param string $filename 文件名
 +----------------------------------------------------------
 * @return boolen
 +----------------------------------------------------------
 */
function require_cache($filename)
{
    static $_importFiles = array();
    if(file_exists($filename)){
        if (!isset($_importFiles[$filename])) {
            require $filename;
			$GLOBALS['include_file']++;
            $_importFiles[$filename] = true;
            return true;
        }
        return false;
    }
    return false;
}

/**
 +----------------------------------------------------------
 * 导入所需的类库 支持目录和* 同java的Import
 * 本函数有缓存功能 
 +----------------------------------------------------------
 * @param string $class 类库命名空间字符串
 * @param string $baseUrl 起始路径
 * @param string $appName 项目名
 * @param string $ext 导入的文件扩展名
 * @param string $subdir 是否导入子目录 默认false
 +----------------------------------------------------------
 * @return boolen
 +----------------------------------------------------------
 */
function import($class,$baseUrl = '',$ext='.class.php',$subdir=false)
{
      //echo('<br>'.$class.$baseUrl);
      static $_file = array();
	  static $_class = array();
      if(isset($_file[strtolower($class.$baseUrl)]))
            return true;
      else 
            $_file[strtolower($class.$baseUrl)] = true;
      //if (preg_match('/[^a-z0-9\-_.*]/i', $class)) throw_exception('Import非法的类名或者目录！');
      if( 0 === strpos($class,'@')) 	$class =  str_replace('@',APP_NAME,$class);
      if(empty($baseUrl)) {
            // 默认方式调用应用类库
      	    $baseUrl   =  dirname(LIB_PATH);
      }else {
            //相对路径调用
      	    $isPath =  true;
      }
      $class_strut = explode(".",$class);
      if('*' == $class_strut[0] || isset($isPath) ) {
      	//多级目录加载支持
        //用于子目录递归调用
      }
      elseif(APP_NAME == $class_strut[0]) {
          //加载当前项目应用类库
          $class =  str_replace(APP_NAME.'.',LIB_DIR.'.',$class);
      }
      elseif(in_array(strtolower($class_strut[0]),array('think','org','com'))) {
          //加载ThinkPHP基类库或者公共类库
		  // think 官方基类库 org 第三方公共类库 com 企业公共类库
          $baseUrl =  THINK_PATH.'/'.LIB_DIR.'/';
      }else {
          // 加载其他项目应用类库
          $class =  str_replace($class_strut[0],'',$class);
          $baseUrl =  APP_PATH.'/../'.$class_strut[0].'/'.LIB_DIR.'/';
      }
      if(substr($baseUrl, -1) != "/")    $baseUrl .= "/";
      $classfile = $baseUrl.str_replace('.', '/', $class).$ext;
	  if(false !== strpos($classfile,'*') || false !== strpos($classfile,'?') ) {
			// 导入匹配的文件
			$match	=	glob($classfile);
			if($match) {
			   foreach($match as $key=>$val) {
				   if(is_dir($val)) {
					   if($subdir) import('*',$val.'/',$ext,$subdir);
				   }else{
					   if($ext == '.class.php') {
							// 冲突检测
							$class = basename($val,$ext);
							if(isset($_class[$class])) {
								throw_exception($class.'类名冲突');
							}
							$_class[$class] = $val;
					   }
						//导入类库文件
						$result	=	require_cache($val);
				   }
			   } 
	           return $result;
			}else{
	           return false;
			}
	  }else{
		  if($ext == '.class.php' && file_exists($classfile)) {
				// 冲突检测
				$class = basename($classfile,$ext);
				if(isset($_class[strtolower($class)])) {
					throw_exception('类名冲突:'.$_class[strtolower($class)].' '.$classfile);
				}
				$_class[strtolower($class)] = $classfile;
		  }
            //导入目录下的指定类库文件
            return require_cache($classfile);      
	  }
} 

/**
 +----------------------------------------------------------
 * import方法的别名 
 +----------------------------------------------------------
 * @param string $package 包名
 * @param string $baseUrl 起始路径
 * @param string $ext 导入的文件扩展名
 * @param string $subdir 是否导入子目录 默认false
 +----------------------------------------------------------
 * @return boolean
 +----------------------------------------------------------
 */
function using($class,$baseUrl = LIB_PATH,$ext='.class.php',$subdir=false)
{
    return import($class,$baseUrl,$ext,$subdir);
}

// 快速导入第三方框架类库
// 所有第三方框架的类库文件统一放到 基类库Vendor目录下面
// 并且默认都是以.php后缀导入
function vendor($class,$baseUrl = '',$ext='.php',$subdir=false)
{
	if(empty($baseUrl)) {
		$baseUrl	=	VENDOR_PATH;
	}
	return import($class,$baseUrl,$ext,$subdir);
}

/**
 +----------------------------------------------------------
 * 根据PHP各种类型变量生成唯一标识号 
 +----------------------------------------------------------
 * @param mixed $mix 变量
 +----------------------------------------------------------
 * @return string
 +----------------------------------------------------------
 */
function to_guid_string($mix)
{
	if(is_object($mix) && function_exists('spl_object_hash')) {
		return spl_object_hash($mix);
	}elseif(is_resource($mix)){
        $mix = get_resource_type($mix).strval($mix);
    }else{
        $mix = serialize($mix);
    }
    return md5($mix);
}

/**
 +----------------------------------------------------------
 * 获得迭代因子  使用foreach遍历对象
 +----------------------------------------------------------
 * @param mixed $values 对象元素
 +----------------------------------------------------------
 * @return string
 +----------------------------------------------------------
 */
function get_iterator($values) 
{
	return new ArrayObject($values);
}

/**
 +----------------------------------------------------------
 * 判断是否为对象实例
 +----------------------------------------------------------
 * @param mixed $object 实例对象
 * @param mixed $className 对象名
 +----------------------------------------------------------
 * @return boolean
 +----------------------------------------------------------
 */
function is_instance_of($object, $className)
{
    return $object instanceof $className;
}

/**
 +----------------------------------------------------------
 * 读取插件
 +----------------------------------------------------------
 * @param string $path 插件目录
 * @param string $app 所属项目名
 +----------------------------------------------------------
 * @return Array
 +----------------------------------------------------------
 */
function get_plugins($path=PLUGIN_PATH,$app=APP_NAME,$ext='.php') 
{
	static $plugins = array ();
    if(isset($plugins[$app])) {
    	return $plugins[$app];
    }
    // 如果插件目录为空 返回空数组
    if(empty_dir($path)) {
        return array();
    }
    $path = realpath($path);

    // 缓存无效 重新读取插件文件
    /*
    $dir = glob ( $path . '/*' );
    if($dir) {
       foreach($dir as $val) {
            if(is_dir($val)){    
                $subdir = glob($val.'/*'.$ext);
                if($subdir) {
                    foreach($subdir as $file) 
                        $plugin_files[] = $file;
                }
            }else{    
                if (strrchr($val, '.') == $ext) 
                    $plugin_files[] = $val;
            }
       } 
       */

    $dir = dir($path);
    if($dir) {
        $plugin_files = array();
        while (false !== ($file = $dir->read())) {
            if($file == "." || $file == "..")   continue;
            if(is_dir($path.'/'.$file)){    
                    $subdir =  dir($path.'/'.$file);
                    if ($subdir) {
                        while (($subfile = $subdir->read()) !== false) {
                            if($subfile == "." || $subfile == "..")   continue;
                            if (preg_match('/\.php$/', $subfile))
                                $plugin_files[] = "$file/$subfile";
                        }
                        $subdir->close();
                    }            
            }else{    
                $plugin_files[] = $file;
            }
        }    
        $dir->close(); 

        //对插件文件排序
        if(count($plugin_files)>1) {
            sort($plugin_files);
        }
        $plugins[$app] = array();
        foreach ($plugin_files as $plugin_file) {
            if ( !is_readable("$path/$plugin_file"))		continue;
            //取得插件文件的信息
            $plugin_data = get_plugin_info("$path/$plugin_file");
            if (empty ($plugin_data['name'])) {
                continue;
            }
            $plugins[$app][] = $plugin_data;
        }
       return $plugins[$app];    	
    }else {
    	return array();
    }
}

/**
 +----------------------------------------------------------
 * 获取插件信息
 +----------------------------------------------------------
 * @param string $plugin_file 插件文件名
 +----------------------------------------------------------
 * @return Array
 +----------------------------------------------------------
 */
function get_plugin_info($plugin_file) {

	$plugin_data = file_get_contents($plugin_file);
	preg_match("/Plugin Name:(.*)/i", $plugin_data, $plugin_name);
    if(empty($plugin_name)) {
    	return false;
    }
	preg_match("/Plugin URI:(.*)/i", $plugin_data, $plugin_uri);
	preg_match("/Description:(.*)/i", $plugin_data, $description);
	preg_match("/Author:(.*)/i", $plugin_data, $author_name);
	preg_match("/Author URI:(.*)/i", $plugin_data, $author_uri);
	if (preg_match("/Version:(.*)/i", $plugin_data, $version))
		$version = trim($version[1]);
	else
		$version = '';
    if(!empty($author_name)) {
        if(!empty($author_uri)) {
            $author_name = '<a href="'.trim($author_uri[1]).'" target="_blank">'.$author_name[1].'</a>';
        }else {
            $author_name = $author_name[1];
        }    	
    }else {
    	$author_name = '';
    }
	return array ('file'=>$plugin_file,'name' => trim($plugin_name[1]), 'uri' => trim($plugin_uri[1]), 'description' => trim($description[1]), 'author' => trim($author_name), 'version' => $version);
}

/**
 +----------------------------------------------------------
 * 动态添加模版编译引擎
 +----------------------------------------------------------
 * @param string $tag 模版引擎定义名称
 * @param string $compiler 编译器名称
 +----------------------------------------------------------
 * @return boolean
 +----------------------------------------------------------
 */
function add_compiler($tag,$compiler) 
{
	$GLOBALS['template_compiler'][strtoupper($tag)] = $compiler ;
    return ;
}

/**
 +----------------------------------------------------------
 * 使用模版编译引擎
 +----------------------------------------------------------
 * @param string $tag 模版引擎定义名称
 +----------------------------------------------------------
 * @return boolean
 +----------------------------------------------------------
 */
function use_compiler($tag) 
{
	$args = array_slice(func_get_args(), 1);
	if(is_callable($GLOBALS['template_compiler'][strtoupper($tag)])) {
		call_user_func_array($GLOBALS['template_compiler'][strtoupper($tag)],$args);    
	}else{
		throw_exception('模板引擎错误：'.C('TMPL_ENGINE_TYPE'));
	}
    return ;
}

/**
 +----------------------------------------------------------
 * 动态添加过滤器
 +----------------------------------------------------------
 * @param string $tag 过滤器标签
 * @param string $function 过滤方法名
 * @param integer $priority 执行优先级
 * @param integer $args 参数
 +----------------------------------------------------------
 * @return boolean
 +----------------------------------------------------------
 */
function add_filter($tag,$function,$priority = 10,$args = 1) 
{
    static $_filter = array();
	if ( isset($_filter[APP_NAME.'_'.$tag]["$priority"]) ) {
		foreach($_filter[APP_NAME.'_'.$tag]["$priority"] as $filter) {
			if ( $filter['function'] == $function ) {
				return true;
			}
		}
	}
    $_filter[APP_NAME.'_'.$tag]["$priority"][] = array('function'=> $function,'args'=> $args);
    $_SESSION['_filters']	=	$_filter;
    return true;
}

/**
 +----------------------------------------------------------
 * 删除动态添加的过滤器
 +----------------------------------------------------------
 * @param string $tag 过滤器标签
 * @param string $function 过滤方法名
 * @param integer $priority 执行优先级
 +----------------------------------------------------------
 * @return boolean
 +----------------------------------------------------------
 */
function remove_filter($tag, $function_to_remove, $priority = 10) {
	$_filter  = $_SESSION['_filters'];
	if ( isset($_filter[APP_NAME.'_'.$tag]["$priority"]) ) {
		$new_function_list = array();
		foreach($_filter[APP_NAME.'_'.$tag]["$priority"] as $filter) {
			if ( $filter['function'] != $function_to_remove ) {
				$new_function_list[] = $filter;
			}
		}
		$_filter[APP_NAME.'_'.$tag]["$priority"] = $new_function_list;
	}
    $_SESSION['_filters']	=	$_filter;
	return true;
}

/**
 +----------------------------------------------------------
 * 执行过滤器
 +----------------------------------------------------------
 * @param string $tag 过滤器标签
 * @param string $string 参数
 +----------------------------------------------------------
 * @return boolean
 +----------------------------------------------------------
 */
function apply_filter($tag,$string='') 
{
	if (!isset($_SESSION['_filters']) ||  !isset($_SESSION['_filters'][APP_NAME.'_'.$tag]) ) {
		return $string;
	}
	$_filter  = $_SESSION['_filters'][APP_NAME.'_'.$tag];
    ksort($_filter);
    $args = array_slice(func_get_args(), 2);
	foreach ($_filter as $priority => $functions) {
		if ( !is_null($functions) ) {
			foreach($functions as $function) {
                if(is_callable($function['function'])) {
                    $args = array_merge(array($string), $args);
                    $string = call_user_func_array($function['function'],$args);                 	
                }
			}
		}
	}
	return $string;	
}

/**
 +----------------------------------------------------------
 * 字符串截取，支持中文和其他编码
 +----------------------------------------------------------
 * @static
 * @access public 
 +----------------------------------------------------------
 * @param string $str 需要转换的字符串
 * @param string $start 开始位置
 * @param string $length 截取长度
 * @param string $charset 编码格式
 * @param string $suffix 截断显示字符
 +----------------------------------------------------------
 * @return string
 +----------------------------------------------------------
 */
function msubstr($str, $start=0, $length, $charset="utf-8", $suffix=true)
{
	if(function_exists("mb_substr"))
		return mb_substr($str, $start, $length, $charset);
	elseif(function_exists('iconv_substr')) {
		return iconv_substr($str,$start,$length,$charset);
	}
	$re['utf-8']   = "/[\x01-\x7f]|[\xc2-\xdf][\x80-\xbf]|[\xe0-\xef][\x80-\xbf]{2}|[\xf0-\xff][\x80-\xbf]{3}/";
	$re['gb2312'] = "/[\x01-\x7f]|[\xb0-\xf7][\xa0-\xfe]/";
	$re['gbk']	  = "/[\x01-\x7f]|[\x81-\xfe][\x40-\xfe]/";
	$re['big5']	  = "/[\x01-\x7f]|[\x81-\xfe]([\x40-\x7e]|\xa1-\xfe])/";
	preg_match_all($re[$charset], $str, $match);
	$slice = join("",array_slice($match[0], $start, $length));
	if($suffix) return $slice."…";
	return $slice;
}

/**
 +----------------------------------------------------------
 * 产生随机字串，可用来自动生成密码 默认长度6位 字母和数字混合
 +----------------------------------------------------------
 * @param string $len 长度 
 * @param string $type 字串类型 
 * 0 字母 1 数字 其它 混合
 * @param string $addChars 额外字符 
 +----------------------------------------------------------
 * @return string
 +----------------------------------------------------------
 */
function rand_string($len=6,$type='',$addChars='') { 
    $str ='';
    switch($type) { 
        case 0:
            $chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.$addChars; 
            break;
        case 1:
            $chars= str_repeat('0123456789',3); 
            break;
        case 2:
            $chars='ABCDEFGHIJKLMNOPQRSTUVWXYZ'.$addChars; 
            break;
        case 3:
            $chars='abcdefghijklmnopqrstuvwxyz'.$addChars; 
            break;
		case 4:
			$chars = "们以我到他会作时要动国产的一是工就年阶义发成部民可出能方进在了不和有大这主中人上为来分生对于学下级地个用同行面说种过命度革而多子后自社加小机也经力线本电高量长党得实家定深法表着水理化争现所二起政三好十战无农使性前等反体合斗路图把结第里正新开论之物从当两些还天资事队批点育重其思与间内去因件日利相由压员气业代全组数果期导平各基或月毛然如应形想制心样干都向变关问比展那它最及外没看治提五解系林者米群头意只明四道马认次文通但条较克又公孔领军流入接席位情运器并飞原油放立题质指建区验活众很教决特此常石强极土少已根共直团统式转别造切九你取西持总料连任志观调七么山程百报更见必真保热委手改管处己将修支识病象几先老光专什六型具示复安带每东增则完风回南广劳轮科北打积车计给节做务被整联步类集号列温装即毫知轴研单色坚据速防史拉世设达尔场织历花受求传口断况采精金界品判参层止边清至万确究书术状厂须离再目海交权且儿青才证低越际八试规斯近注办布门铁需走议县兵固除般引齿千胜细影济白格效置推空配刀叶率述今选养德话查差半敌始片施响收华觉备名红续均药标记难存测士身紧液派准斤角降维板许破述技消底床田势端感往神便贺村构照容非搞亚磨族火段算适讲按值美态黄易彪服早班麦削信排台声该击素张密害侯草何树肥继右属市严径螺检左页抗苏显苦英快称坏移约巴材省黑武培著河帝仅针怎植京助升王眼她抓含苗副杂普谈围食射源例致酸旧却充足短划剂宣环落首尺波承粉践府鱼随考刻靠够满夫失包住促枝局菌杆周护岩师举曲春元超负砂封换太模贫减阳扬江析亩木言球朝医校古呢稻宋听唯输滑站另卫字鼓刚写刘微略范供阿块某功套友限项余倒卷创律雨让骨远帮初皮播优占死毒圈伟季训控激找叫云互跟裂粮粒母练塞钢顶策双留误础吸阻故寸盾晚丝女散焊功株亲院冷彻弹错散商视艺灭版烈零室轻血倍缺厘泵察绝富城冲喷壤简否柱李望盘磁雄似困巩益洲脱投送奴侧润盖挥距触星松送获兴独官混纪依未突架宽冬章湿偏纹吃执阀矿寨责熟稳夺硬价努翻奇甲预职评读背协损棉侵灰虽矛厚罗泥辟告卵箱掌氧恩爱停曾溶营终纲孟钱待尽俄缩沙退陈讨奋械载胞幼哪剥迫旋征槽倒握担仍呀鲜吧卡粗介钻逐弱脚怕盐末阴丰雾冠丙街莱贝辐肠付吉渗瑞惊顿挤秒悬姆烂森糖圣凹陶词迟蚕亿矩康遵牧遭幅园腔订香肉弟屋敏恢忘编印蜂急拿扩伤飞露核缘游振操央伍域甚迅辉异序免纸夜乡久隶缸夹念兰映沟乙吗儒杀汽磷艰晶插埃燃欢铁补咱芽永瓦倾阵碳演威附牙芽永瓦斜灌欧献顺猪洋腐请透司危括脉宜笑若尾束壮暴企菜穗楚汉愈绿拖牛份染既秋遍锻玉夏疗尖殖井费州访吹荣铜沿替滚客召旱悟刺脑措贯藏敢令隙炉壳硫煤迎铸粘探临薄旬善福纵择礼愿伏残雷延烟句纯渐耕跑泽慢栽鲁赤繁境潮横掉锥希池败船假亮谓托伙哲怀割摆贡呈劲财仪沉炼麻罪祖息车穿货销齐鼠抽画饲龙库守筑房歌寒喜哥洗蚀废纳腹乎录镜妇恶脂庄擦险赞钟摇典柄辩竹谷卖乱虚桥奥伯赶垂途额壁网截野遗静谋弄挂课镇妄盛耐援扎虑键归符庆聚绕摩忙舞遇索顾胶羊湖钉仁音迹碎伸灯避泛亡答勇频皇柳哈揭甘诺概宪浓岛袭谁洪谢炮浇斑讯懂灵蛋闭孩释乳巨徒私银伊景坦累匀霉杜乐勒隔弯绩招绍胡呼痛峰零柴簧午跳居尚丁秦稍追梁折耗碱殊岗挖氏刃剧堆赫荷胸衡勤膜篇登驻案刊秧缓凸役剪川雪链渔啦脸户洛孢勃盟买杨宗焦赛旗滤硅炭股坐蒸凝竟陷枪黎救冒暗洞犯筒您宋弧爆谬涂味津臂障褐陆啊健尊豆拔莫抵桑坡缝警挑污冰柬嘴啥饭塑寄赵喊垫丹渡耳刨虎笔稀昆浪萨茶滴浅拥穴覆伦娘吨浸袖珠雌妈紫戏塔锤震岁貌洁剖牢锋疑霸闪埔猛诉刷狠忽灾闹乔唐漏闻沈熔氯荒茎男凡抢像浆旁玻亦忠唱蒙予纷捕锁尤乘乌智淡允叛畜俘摸锈扫毕璃宝芯爷鉴秘净蒋钙肩腾枯抛轨堂拌爸循诱祝励肯酒绳穷塘燥泡袋朗喂铝软渠颗惯贸粪综墙趋彼届墨碍启逆卸航衣孙龄岭骗休借".$addChars;
			break;
        default :
            // 默认去掉了容易混淆的字符oOLl和数字01，要添加请使用addChars参数
            $chars='ABCDEFGHIJKMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789'.$addChars; 
            break;
    }
    if($len>10 ) {//位数过长重复字符串一定次数
        $chars= $type==1? str_repeat($chars,$len) : str_repeat($chars,5); 
    }
	if($type!=4) {
		$chars   =   str_shuffle($chars);
		$str     =   substr($chars,0,$len);
	}else{
		// 中文随机字
		for($i=0;$i<$len;$i++){   
		  $str.= msubstr($chars, floor(mt_rand(0,mb_strlen($chars,'utf-8')-1)),1);   
		} 
	}
    return $str;
}

/**
 +----------------------------------------------------------
 * 获取登录验证码 默认为4位数字
 +----------------------------------------------------------
 * @param string $fmode 文件名
 +----------------------------------------------------------
 * @return string
 +----------------------------------------------------------
 */
function build_verify ($length=4,$mode=1) { 
    return rand_string($length,$mode);
}

/**
 +----------------------------------------------------------
 * stripslashes扩展 可用于数组 
 +----------------------------------------------------------
 * @param mixed $value 变量
 +----------------------------------------------------------
 * @return mixed
 +----------------------------------------------------------
 */
if(!function_exists('stripslashes_deep')) {
    function stripslashes_deep($value) {
       $value = is_array($value) ? array_map('stripslashes_deep', $value) : stripslashes($value);
       return $value;
    }	
}

function D($className='',$appName='@') 
{
	static $_model = array();
	if(empty($className)) {
		return new  Model();
	}else{
	   	$className =  C('MODEL_CLASS_PREFIX').$className.C('MODEL_CLASS_SUFFIX');
	}
	if(isset($_model[$className])) {
		return $_model[$className];
	}
	if(strpos($className,C('COMPONENT_DEPR'))) {
		$array	=	explode(C('COMPONENT_DEPR'),$className);
		$className = array_pop($array);
		import($appName.'.'.implode('.',$array).'.Model.'.$className);
	}else{
		if(!import($appName.'.Model.'.$className)) {
			// 如果加载失败 尝试自动匹配
			import($appName.'.*.Model.'.$className);
		}
	}
    if(class_exists($className)) {
        $model = new $className();
		$_model[$className] =	$model;
        return $model;    	
    }else {
    	return false;
    }
}

function A($className,$appName='@') 
{
	static $_action = array();
	$className =  C('CONTR_CLASS_PREFIX').$className.C('CONTR_CLASS_SUFFIX');
	if(isset($_action[$className])) {
		return $_action[$className];
	}
	if(strpos($className,C('COMPONENT_DEPR'))) {
		$array	=	explode(C('COMPONENT_DEPR'),$className);
		$className = array_pop($array);
		import($appName.'.'.implode('.',$array).'.Action.'.$className);
	}else{
		if(!import($appName.'.Action.'.$className)) {
			// 如果加载失败 尝试加载组件类库
			import($appName.'.*.Action.'.$className);
		}
	}
    if(class_exists($className)) {
        $action = new $className();
		$_actioin[$className] =	$action;
        return $action;    	
    }else {
    	return false;
    }
}

// 获取语言定义
function L($name='',$value=null) {
	static $_lang = array();
	if(!is_null($value)) {
		$_lang[strtolower($name)]	=	$value;
		return;
	}
	if(empty($name)) {
		return $_lang;
	}
	if(is_array($name)) {
		$_lang = array_merge($_lang,array_change_key_case($name));
		return;
	}
	if(isset($_lang[strtolower($name)])) {
		return $_lang[strtolower($name)];
	}else{
		return false;
	}
}

// 获取配置值
function C($name='',$value=null) {
	static $_config = array();
	if(!is_null($value)) {
		$_config[strtolower($name)]	=	$value;
		return ;
	}
	if(empty($name)) {
		return $_config;
	}
	// 缓存全部配置值
	if(is_array($name)) {
		$_config = array_merge($_config,array_change_key_case($name));
		return $_config;
	}
	if(isset($_config[strtolower($name)])) {
		return $_config[strtolower($name)];
	}else{
		return false;
	}
}

// 全局缓存设置和读取
function S($name,$value='',$expire='',$type='') {
	static $_cache = array();
	import('Think.Util.Cache');
	//取得缓存对象实例
	$cache  = Cache::getInstance($type);
	if('' !== $value) {
		if(is_null($value)) {
			// 删除缓存
			$result	=	$cache->rm($name);
			if($result) {
				unset($_cache[$type.'_'.$name]);
			}
			return $result;
		}else{
			// 缓存数据
			$cache->set($name,$value,$expire);
			$_cache[$type.'_'.$name]	 =	 $value;
		}
		return ;
	}
	if(isset($_cache[$type.'_'.$name])) {
		return $_cache[$type.'_'.$name];
	}
	// 获取缓存数据
	$value      =  $cache->get($name);
	$_cache[$type.'_'.$name]	 =	 $value;
	return $value;
}

// 快速文件数据读取和保存 针对简单类型数据 字符串、数组
function F($name,$value='',$expire=-1,$path=DATA_PATH) {
	static $_cache = array();
	$filename	=	$path.$name.'.php';
	if('' !== $value) {
		if(is_null($value)) {
			// 删除缓存
			$result	=	unlink($filename);
			if($result) {
				unset($_cache[$name]);
			}
			return $result;
		}else{
			// 缓存数据
			$content   =   "<?php\nif (!defined('THINK_PATH')) exit();\n//".sprintf('%012d',$expire)."\nreturn ".var_export($value,true).";\n?>";
			$result  =   file_put_contents($filename,$content);
			$_cache[$name]	 =	 $value;
		}
		return ;
	}
	if(isset($_cache[$name])) {
		return $_cache[$name];
	}
	// 获取缓存数据
	if(file_exists($filename) && false !== $content = file_get_contents($filename)) {
		$expire  =  (int)substr($content,44, 12);
		if($expire != -1 && time() > filemtime($filename) + $expire) { 
			//缓存过期删除缓存文件
			unlink($filename);
			return false;
		}
		$value	=	 eval(substr($content,57,-2));
		$_cache[$name]	 =	 $value;
	}else{
		$value	=	false;
	}
	return $value;
}

// 快速创建一个对象实例
function I($class,$baseUrl = '',$ext='.class.php') {
	static $_class = array();
	if(isset($_class[$baseUrl.$class])) {
		return $_class[$baseUrl.$class];
	}
	$class_strut = explode(".",$class);
	$className	=	array_pop($class_strut);
	if($className != '*') {
		import($class,$baseUrl,$ext,false);
		if(class_exists($className)) {
			$_class[$baseUrl.$class] = new $className();
			return $_class[$baseUrl.$class];
		}else{
			return false;
		}
	}else {
		return false;
	}
}

// xml编码
function xml_encode($data,$encoding='utf-8',$root="think") {
	$xml = '<?xml version="1.0" encoding="'.$encoding.'"?>';
	$xml.= '<'.$root.'>';
	$xml.= data_to_xml($data);   
	$xml.= '</'.$root.'>'; 
	return $xml;
}

function data_to_xml($data) {
	if(is_object($data)) {
		$data = get_object_vars($data);
	}
	$xml = '';
	foreach($data as $key=>$val) {
		is_numeric($key) && $key="item id=\"$key\"";
		$xml.="<$key>";
		$xml.=(is_array($val)||is_object($val))?data_to_xml($val):$val;
		list($key,)=explode(' ',$key);
		$xml.="</$key>";
	}
	return $xml;
}

// 清除缓存目录
function clearCache($type=0,$path=NULL) {
		if(is_null($path)) {
			switch($type) {
			case 0:// 模版缓存目录
				$path = CACHE_PATH;
				break;
			case 1:// 数据缓存目录
				$path	=	TEMP_PATH;
				break;
			case 2://  日志目录
				$path	=	LOG_PATH;
				break;
			case 3://  数据目录
				$path	=	DATA_PATH;
			}
		}
		import("ORG.Io.Dir");
		Dir::del($path);   
	}

// 创建项目目录结构
function buildAppDir() {
	// 没有创建项目目录的话自动创建
	if(!is_dir(APP_PATH)){
		mk_dir(APP_PATH,0777);
	}
	if(is_writeable(APP_PATH)) {
		if(!is_dir(LIB_PATH)) 
			mkdir(LIB_PATH,0777);				// 创建项目应用目录
		if(!is_dir(CONFIG_PATH)) 
			mkdir(CONFIG_PATH,0777);		//	创建项目配置目录
		if(!is_dir(COMMON_PATH)) 
			mkdir(COMMON_PATH,0777);	//	创建项目公共目录
		if(!is_dir(LANG_PATH)) 
			mkdir(LANG_PATH,0777);			//	创建项目语言包目录
		if(!is_dir(CACHE_PATH)) 
			mkdir(CACHE_PATH,0777);		//	创建模板缓存目录
		if(!is_dir(TMPL_PATH)) 
			mkdir(TMPL_PATH,0777);			//	创建模板目录
		if(!is_dir(TMPL_PATH.'default/')) 
			mkdir(TMPL_PATH.'default/',0777);			//	创建模板默认主题目录
		if(!is_dir(LOG_PATH)) 
			mkdir(LOG_PATH,0777);			//	创建项目日志目录
		if(!is_dir(TEMP_PATH)) 
			mkdir(TEMP_PATH,0777);			//	创建临时缓存目录
		if(!is_dir(DATA_PATH)) 
			mkdir(DATA_PATH,0777);			//	创建数据缓存目录
		if(!is_dir(LIB_PATH.'Model/')) 
			mkdir(LIB_PATH.'Model/',0777);	//	创建模型目录
		if(!is_dir(LIB_PATH.'Action/')) 
			mkdir(LIB_PATH.'Action/',0777);	//	创建控制器目录
		// 目录安全写入
		if(!defined('BUILD_DIR_SECURE')) define('BUILD_DIR_SECURE',false);
		if(BUILD_DIR_SECURE) {
			if(!defined('DIR_SECURE_FILENAME')) define('DIR_SECURE_FILENAME','index.html');
			if(!defined('DIR_SECURE_CONTENT')) define('DIR_SECURE_CONTENT',' ');
			// 自动写入目录安全文件
			$content		=	DIR_SECURE_CONTENT;
			$a = explode(',', DIR_SECURE_FILENAME);
			foreach ($a as $filename){
				file_put_contents(LIB_PATH.$filename,$content);
				file_put_contents(LIB_PATH.'Action/'.$filename,$content);
				file_put_contents(LIB_PATH.'Model/'.$filename,$content);
				file_put_contents(CACHE_PATH.$filename,$content);
				file_put_contents(LANG_PATH.$filename,$content);
				file_put_contents(TEMP_PATH.$filename,$content);
				file_put_contents(TMPL_PATH.$filename,$content);
				file_put_contents(TMPL_PATH.'default/'.$filename,$content);
				file_put_contents(DATA_PATH.$filename,$content);
				file_put_contents(COMMON_PATH.$filename,$content);
				file_put_contents(CONFIG_PATH.$filename,$content);
				file_put_contents(LOG_PATH.$filename,$content);
			}
		}
		// 写入测试Action
		if(!file_exists(LIB_PATH.'Action/IndexAction.class.php')) {
			$content	 =	 
'<?php 
// 本类由系统自动生成，仅供测试用途
class IndexAction extends Action{
	public function index(){
		header("Content-Type:text/html; charset=utf-8");
		echo "<div style=\'font-weight:normal;color:blue;float:left;width:345px;text-align:center;border:1px solid silver;background:#E8EFFF;padding:8px;font-size:14px;font-family:Tahoma\'>^_^ Hello,欢迎使用<span style=\'font-weight:bold;color:red\'>ThinkPHP</span></div>";
	}
} 
?>';
			file_put_contents(LIB_PATH.'Action/IndexAction.class.php',$content);
		}
	}else{
		header("Content-Type:text/html; charset=utf-8");
		exit('<div style=\'font-weight:bold;float:left;width:345px;text-align:center;border:1px solid silver;background:#E8EFFF;padding:8px;color:red;font-size:14px;font-family:Tahoma\'>项目目录不可写，目录无法自动生成！<BR>请使用项目生成器或者手动生成项目目录~</div>');
	}
}
?><?php 
// +----------------------------------------------------------------------
// | ThinkPHP                                                             
// +----------------------------------------------------------------------
// | Copyright (c) 2008 http://thinkphp.cn All rights reserved.      
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>                                  
// +----------------------------------------------------------------------
// $Id$

/**
 +------------------------------------------------------------------------------
 * ThinkPHP系统基类 抽象类
 +------------------------------------------------------------------------------
 * @category   Think
 * @package  Think
 * @subpackage  Core
 * @author    liu21st <liu21st@gmail.com>
 * @version   $Id$
 +------------------------------------------------------------------------------
 */
abstract class Base
{

    /**
     +----------------------------------------------------------
     * 自动变量设置
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param $name 属性名称
     * @param $value  属性值
     +----------------------------------------------------------
     */
    private function __set($name ,$value)
    {
        if(property_exists($this,$name)){
            $this->$name = $value;
        }
    }

    /**
     +----------------------------------------------------------
     * 自动变量获取
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param $name 属性名称
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     */
    private function __get($name)
    {
        if(isset($this->$name)){
            return $this->$name;
        }else {
            return null;
        }
    }

}//类定义结束
?><?php 
// +----------------------------------------------------------------------
// | ThinkPHP                                                             
// +----------------------------------------------------------------------
// | Copyright (c) 2008 http://thinkphp.cn All rights reserved.      
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>                                  
// +----------------------------------------------------------------------
// $Id$

/**
 +------------------------------------------------------------------------------
 * ThinkPHP系统异常基类
 +------------------------------------------------------------------------------
 * @category   Think
 * @package  Think
 * @subpackage  Exception
 * @author    liu21st <liu21st@gmail.com>
 * @version   $Id$
 +------------------------------------------------------------------------------
 */
class ThinkException extends Exception
{//类定义开始

	/**
	 +----------------------------------------------------------
	 * 异常类型
	 +----------------------------------------------------------
	 * @var string
	 * @access private
	 +----------------------------------------------------------
	 */
	private $type;

	// 是否存在多余调试信息
	private $extra;

	/**
	 +----------------------------------------------------------
	 * 架构函数
	 +----------------------------------------------------------
	 * @access public 
	 +----------------------------------------------------------
	 * @param string $message  异常信息
	 +----------------------------------------------------------
	 */
	public function __construct($message,$code=0,$extra=false) 
	{
		parent::__construct($message,$code);
		$this->type = get_class($this);
		$this->extra = $extra;
	}
	
	/**
	 +----------------------------------------------------------
	 * 异常输出 所有异常处理类均通过__toString方法输出错误
	 * 每次异常都会写入系统日志
	 * 该方法可以被子类重载
	 +----------------------------------------------------------
	 * @access public 
	 +----------------------------------------------------------
	 * @return array
	 +----------------------------------------------------------
	 */
	public function __toString() 
	{
		$trace = $this->getTrace();
		if($this->extra) {
			// 通过throw_exception抛出的异常要去掉多余的调试信息
			array_shift($trace);
		}
		$this->class = $trace[0]['class'];
		$this->function = $trace[0]['function'];
		$this->file = $trace[0]['file'];
		$this->line = $trace[0]['line'];
		$file   =   file($this->file);
		$traceInfo='';
		$time = date("y-m-d H:i:m");
		foreach($trace as $t) {
			$traceInfo .= '['.$time.'] '.$t['file'].' ('.$t['line'].') ';
			$traceInfo .= $t['class'].$t['type'].$t['function'].'(';
			$traceInfo .= implode(', ', $t['args']);
			$traceInfo .=")\n";
		}
		$error['message']   = $this->message;
		$error['type']      = $this->type;
		$error['detail']    = L('_MODULE_').'['.MODULE_NAME.'] '.L('_ACTION_').'['.ACTION_NAME.']'."\n";
		$error['detail']   .=   ($this->line-2).': '.$file[$this->line-3];
		$error['detail']   .=   ($this->line-1).': '.$file[$this->line-2];        
		$error['detail']   .=   '<font color="#FF6600" >'.($this->line).': <b>'.$file[$this->line-1].'</b></font>';
		$error['detail']   .=   ($this->line+1).': '.$file[$this->line];
		$error['detail']   .=   ($this->line+2).': '.$file[$this->line+1];
		$error['class']     =   $this->class;
		$error['function']  =   $this->function;
		$error['file']      = $this->file;
		$error['line']      = $this->line;
		$error['trace']     = $traceInfo;

		//记录系统日志            
		$errorStr   = "\n".L('_ERROR_INFO_')."[ ".APP_NAME.' '.MODULE_NAME.' '.ACTION_NAME.' ]'.$this->message."\n";
		$errorStr  .= L('_ERROR_URL_').WEB_URL.$_SERVER["PHP_SELF"]."\n";
		$errorStr  .= L('_ERROR_TYPE_').$this->type."\n";
		$errorStr  .= L('_ERROR_TRACE_')."\n".$traceInfo;
		Log::Write($errorStr);

		return $error ;
	}

}//类定义结束
 
?><?php 
// +----------------------------------------------------------------------
// | ThinkPHP                                                             
// +----------------------------------------------------------------------
// | Copyright (c) 2008 http://thinkphp.cn All rights reserved.      
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>                                  
// +----------------------------------------------------------------------
// $Id$

/**
 +------------------------------------------------------------------------------
 * 日志处理类
 * 支持下面的日志类型
 * WEB_LOG_DEBUG 调试信息
 * WEB_LOG_ERROR 错误信息
 * SQL_LOG_DEBUG SQL调试
 * 分别对象的默认日志文件为
 * 调试日志文件 systemOut.log
 * 错误日志文件  systemErr.log
 * SQL日志文件  systemSql.log
 +------------------------------------------------------------------------------
 * @category   Think
 * @package  Think
 * @subpackage  Util
 * @author    liu21st <liu21st@gmail.com>
 * @version   $Id$
 +------------------------------------------------------------------------------
 */
class Log extends Base
{//类定义开始

	static $log	=	array();

    /**
     +----------------------------------------------------------
     * 记录日志
     +----------------------------------------------------------
     * @static
     * @access public 
     +----------------------------------------------------------
     * @param string $message 日志信息
     * @param string $type  日志类型
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	static function record($message,$type=WEB_LOG_ERROR) {
        $now = date('[ y-m-d H:i:s ]');
		self::$log[$type][]	=	"\n$now\n$message";
	}

    /**
     +----------------------------------------------------------
     * 日志保存
     +----------------------------------------------------------
     * @static
     * @access public 
     +----------------------------------------------------------
     * @param string $message 日志信息
     * @param string $type  日志类型
     * @param string $file  写入文件 默认取定义日志文件
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
    static function save()
    {	
		$day	=	date('y_m_d');
		$_type	=	array(
			WEB_LOG_DEBUG	=>	realpath(LOG_PATH).'/'.$day."_systemOut.log",
			SQL_LOG_DEBUG	=>	realpath(LOG_PATH).'/'.$day."_systemSql.log",
			WEB_LOG_ERROR	=>	realpath(LOG_PATH).'/'.$day."_systemErr.log",
			);
        if(!is_writable(LOG_PATH)){
            halt(L('_FILE_NOT_WRITEABLE_').':'.LOG_PATH);
        }
		foreach (self::$log as $type=>$logs){
			//检测日志文件大小，超过配置大小则备份日志文件重新生成
			$destination	=	$_type[$type];
			if(file_exists($destination) && floor(C('LOG_FILE_SIZE')) <= filesize($destination) ){
				  rename($destination,dirname($destination).'/'.time().'-'.basename($destination));
			}
	        error_log(implode('',$logs), FILE_LOG,$destination );
		}
		clearstatcache();
    }

    /**
     +----------------------------------------------------------
     * 日志直接写入
     +----------------------------------------------------------
     * @static
     * @access public 
     +----------------------------------------------------------
     * @param string $message 日志信息
     * @param string $type  日志类型
     * @param string $file  写入文件 默认取定义日志文件
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
    static function write($message,$type=WEB_LOG_ERROR,$file='')
    {
        $now = date('[ y-m-d H:i:s ]');
        switch($type){
            case WEB_LOG_DEBUG:
                $logType ='[调试]';
                $destination = $file == ''? LOG_PATH.date('y_m_d')."_systemOut.log" : $file;
                break;
			case SQL_LOG_DEBUG:
				// 调试SQL记录
                $logType ='[SQL]';
                $destination = $file == ''? LOG_PATH.date('y_m_d')."_systemSql.log" : $file;
                break;
			case WEB_LOG_ERROR:
                $logType ='[错误]';
                $destination = $file == ''? LOG_PATH.date('y_m_d')."_systemErr.log" : $file;
				break;
        }
        if(!is_writable(LOG_PATH)){
            halt(L('_FILE_NOT_WRITEABLE_').':'.$destination);
        }
        //检测日志文件大小，超过配置大小则备份日志文件重新生成
		if(file_exists($destination) && floor(C('LOG_FILE_SIZE')) <= filesize($destination) ){
			  rename($destination,dirname($destination).'/'.time().'-'.basename($destination));
		}        	
        error_log("$now\n$message\n", FILE_LOG,$destination );
		clearstatcache();
    }


}//类定义结束
?><?php 
// +----------------------------------------------------------------------
// | ThinkPHP                                                             
// +----------------------------------------------------------------------
// | Copyright (c) 2008 http://thinkphp.cn All rights reserved.      
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>                                  
// +----------------------------------------------------------------------
// $Id$

/**
 +------------------------------------------------------------------------------
 * ThinkPHP 应用程序类 执行应用过程管理
 +------------------------------------------------------------------------------
 * @category   Think
 * @package  Think
 * @subpackage  Core
 * @author    liu21st <liu21st@gmail.com>
 * @version   $Id$
 +------------------------------------------------------------------------------
 */
class App extends Base 
{//类定义开始

    /**
     +----------------------------------------------------------
     * 应用程序名称
     +----------------------------------------------------------
     * @var string
     * @access protected
     +----------------------------------------------------------
     */
    protected $name ;

    /**
     +----------------------------------------------------------
     * 应用程序标识号
     +----------------------------------------------------------
     * @var string
     * @access protected
     +----------------------------------------------------------
     */
    protected $id;

    /**
     +----------------------------------------------------------
     * 架构函数
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $name 应用名称
     * @param string $id  应用标识号
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
    public function __construct($name='App',$id='')
    {    
        $this->name = $name;
        $this->id   =  $id ;//| create_guid();
    }

    /**
     +----------------------------------------------------------
     * 取得应用实例对象 
     * 静态方法
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return App
     +----------------------------------------------------------
     */
    public static function  getInstance() 
    {
        return get_instance_of(__CLASS__);
    }

    /**
     +----------------------------------------------------------
     * 应用程序初始化
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
    public function init()
    {
        // 设定错误和异常处理
        set_error_handler(array(&$this,"appError"));
		set_exception_handler(array(&$this,"appException"));

		// 检查项目是否编译过
		// 在部署模式下会自动在第一次执行的时候编译项目
		if(file_exists(RUNTIME_PATH.'~app.php') && filemtime(RUNTIME_PATH.'~app.php')>filemtime(CONFIG_PATH.'config.php')) {
			// 直接读取编译后的项目文件
			C(array_change_key_case(include RUNTIME_PATH.'~app.php'));
		}else{
			// 预编译项目
			$this->build();
		}

        // 设置系统时区 PHP5支持
        if(function_exists('date_default_timezone_set')) 
            date_default_timezone_set(C('TIME_ZONE'));

        if('FILE' != strtoupper(C('SESSION_TYPE'))) {
			// 其它方式Session支持 目前支持Db 通过过滤器方式扩展
			import("Think.Util.Filter");
			Filter::load(ucwords(C('SESSION_TYPE')).'Session');
        }
        // Session初始化
		session_start();

        // 加载插件 必须在Session开启之后加载插件
		if(C('THINK_PLUGIN_ON')) {
	        $this->loadPlugIn();  
		}

        // 应用调度过滤器
        // 如果没有加载任何URL调度器
        // 默认只支持 QUERY_STRING 方式
        // 例如 ?m=user&a=add
		if(C('DISPATCH_ON')) {
			if( 'Think'== C('DISPATCH_NAME') ) {
				// 使用内置的ThinkDispatcher调度器
				import('Think.Core.Dispatcher');
				Dispatcher::dispatch();
			}else{
				// 加载第三方调度器
		        apply_filter('app_dispatch');
			}
		}

        if(!defined('PHP_FILE')) {
            // PHP_FILE 由内置的Dispacher定义
            // 如果不使用该插件，需要重新定义
        	define('PHP_FILE',_PHP_FILE_);
        }

        // 取得模块和操作名称 如果有伪装 则返回真实的名称
		// 可以在Dispatcher中定义获取规则
		if(!defined('MODULE_NAME')) define('MODULE_NAME',   $this->getModule());       // Module名称
        if(!defined('ACTION_NAME')) define('ACTION_NAME',   $this->getAction());        // Action操作

		// 加载模块配置文件 并自动生成配置缓存文件
		if(file_exists(CONFIG_PATH.MODULE_NAME.'_config.php')) {
			C(array_change_key_case(include CONFIG_PATH.MODULE_NAME.'_config.php'));
		}

		//	启用页面防刷新机制
		if(C('LIMIT_RESFLESH_ON')) {
			//	启用页面防刷新机制
			$guid	=	md5($_SERVER['PHP_SELF']);
			// 检查页面刷新间隔
			if(Cookie::is_set('_last_visit_time_'.$guid) && Cookie::get('_last_visit_time_'.$guid)>time()-C('LIMIT_REFLESH_TIMES')) {
				// 页面刷新读取浏览器缓存
				header('HTTP/1.1 304 Not Modified');
				exit;
			}else{
				// 缓存当前地址访问时间
				Cookie::set('_last_visit_time_'.$guid,$_SERVER['REQUEST_TIME'],$_SERVER['REQUEST_TIME']+3600);
				header('Last-Modified:'.(date('D,d M Y H:i:s',$_SERVER['REQUEST_TIME']-C('LIMIT_REFLESH_TIMES'))).' GMT');
			}
		}

        // 系统检查
		$this->checkLanguage();     //语言检查
        $this->checkTemplate();     //模板检查

		if(C('USER_AUTH_ON')) {
			// 启用权限认证 调用RBAC组件
			import('ORG.RBAC.RBAC');
			RBAC::AccessDecision();
		}

		if(C('HTML_CACHE_ON')) {
			import('Think.Util.HtmlCache');
			HtmlCache::readHTMLCache();
		}
        // 应用初始化过滤插件
        apply_filter('app_init');

		// 记录应用初始化时间
		$GLOBALS['_initTime'] = microtime(TRUE);

        return ;
    }

    /**
     +----------------------------------------------------------
	 * 读取配置信息 编译项目
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     */
	private function build() 
	{
		// 加载惯例配置文件
		C(array_change_key_case(include THINK_PATH.'/Common/convention.php'));

        // 加载项目配置文件
		if(file_exists(CONFIG_PATH.'config.php')) {
			C(array_change_key_case(include CONFIG_PATH.'config.php'));
		}
        // 加载项目公共文件
		if(file_exists(APP_PATH.'/Common/common.php')) {
	       	include APP_PATH.'/Common/common.php';
			if(!C('DEBUG_MODE')) {
				if(defined('STRIP_RUNTIME_SPACE') && STRIP_RUNTIME_SPACE == false ) {
					$common	= file_get_contents(APP_PATH.'/Common/common.php');
				}else{
					$common	= php_strip_whitespace(APP_PATH.'/Common/common.php');
				}
			}
		}
		// 如果是调试模式加载调试模式配置文件
		if(C('DEBUG_MODE')) {
			// 加载系统默认的开发模式配置文件
			C(array_change_key_case(include THINK_PATH.'/Common/debug.php'));
			if(file_exists(CONFIG_PATH.'debug.php')) {
				// 允许项目增加开发模式配置定义
				C(array_change_key_case(include CONFIG_PATH.'debug.php'));
			}
		}else{
			// 部署模式下面生成编译文件
			// 下次直接加载项目编译文件
			$content  = $common."<?php\nreturn ".var_export(C(),true).";\n?>";
			file_put_contents(RUNTIME_PATH.'~app.php',$content);
		}
		return ;
	}

    /**
     +----------------------------------------------------------
     * 获得实际的模块名称
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     */
    private function getModule()
    {
        $module = isset($_POST[C('VAR_MODULE')]) ? 
            $_POST[C('VAR_MODULE')] :
            (isset($_GET[C('VAR_MODULE')])? $_GET[C('VAR_MODULE')]:'');
        // 如果 $module 为空，则赋予默认值
        if (empty($module)) $module = C('DEFAULT_MODULE'); 
		// 检查组件模块
		if(strpos($module,C('COMPONENT_DEPR'))) {
			// 记录完整的模块名
			define('C_MODULE_NAME',$module);
			$array	=	explode(C('COMPONENT_DEPR'),$module);
			// 实际的模块名称
			$module	=	array_pop($array);
		}
		// 检查模块URL伪装
		if(C('MODULE_REDIRECT')) {
            $res = preg_replace('@(\w+):([^,\/]+)@e', '$modules[\'\\1\']="\\2";', C('MODULE_REDIRECT'));
			if(array_key_exists($module,$modules)) {
				// 记录伪装的模块名称
				define('P_MODULE_NAME',$module);
				$module	=	$modules[$module];
			}
		}
        return $module; 
    }

    /**
     +----------------------------------------------------------
     * 获得实际的操作名称
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     */
    private function getAction()
    {
        $action   = isset($_POST[C('VAR_ACTION')]) ? 
            $_POST[C('VAR_ACTION')] : 
            (isset($_GET[C('VAR_ACTION')])?$_GET[C('VAR_ACTION')]:'');
        // 如果 $action 为空，则赋予默认值
        if (empty($action)) $action = C('DEFAULT_ACTION');
		// 检查操作链
		if(strpos($action,C('COMPONENT_DEPR'))) {
			// 记录完整的操作名
			define('C_ACTION_NAME',$action);
			$array	=	explode(C('COMPONENT_DEPR'),$action);
			// 实际的模块名称
			$action	=	array_pop($array);
		}
		// 检查操作URL伪装
		if(C('ACTION_REDIRECT')) {
            $res = preg_replace('@(\w+):([^,\/]+)@e', '$actions[\'\\1\']="\\2";', C('ACTION_REDIRECT'));
			if(array_key_exists($action,$actions)) {
				// 记录伪装的操作名称
				define('P_ACTION_NAME',$action);
				$action	=	$actions[$action];
			}
		}
        return $action; 
    }

    /**
     +----------------------------------------------------------
     * 语言检查
     * 检查浏览器支持语言，并自动加载语言包
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
    private function checkLanguage()
    {
		if(C('LANG_SWITCH_ON')) {
			// 使用语言包功能
			$defaultLang = C('DEFAULT_LANGUAGE');
			//检测浏览器支持语言
			if(isset($_GET[C('VAR_LANGUAGE')])) {
				// 有在url 里面设置语言
				$langSet = $_GET[C('VAR_LANGUAGE')];
				// 记住用户的选择
				Cookie::set('think_language',$langSet,time()+3600);
			}elseif ( Cookie::is_set('think_language') ) {
				// 获取上次用户的选择
				$langSet = Cookie::get('think_language');
			}else {
				if(C('AUTO_DETECT_LANG') && isset($_SERVER['HTTP_ACCEPT_LANGUAGE'])) {
					// 启用自动侦测浏览器语言
					preg_match('/^([a-z\-]+)/i', $_SERVER['HTTP_ACCEPT_LANGUAGE'], $matches);
					$langSet = $matches[1];
					Cookie::set('think_language',$langSet,time()+3600);
				}else{
					// 采用系统设置的默认语言
					$langSet = $defaultLang;
				}
			}

			// 定义当前语言
			define('LANG_SET',$langSet);
			if(file_exists(TEMP_PATH.MODULE_NAME.'_'.LANG_SET.'_lang.php')) {
				// 加载语言包缓存文件
				L(include TEMP_PATH.MODULE_NAME.'_'.LANG_SET.'_lang.php');
			}else{
				// 加载框架语言包
				if (file_exists(THINK_PATH.'/Lang/'.LANG_SET.'.php')){
					L(include THINK_PATH.'/Lang/'.LANG_SET.'.php');
				}else{
					L(include THINK_PATH.'/Lang/'.$defaultLang.'.php');    
				}

			// 读取项目（公共）语言包
			if (file_exists(LANG_PATH.LANG_SET.'/common.php'))
				L(include LANG_PATH.LANG_SET.'/common.php');  
			else
				L(include LANG_PATH.$defaultLang.'/common.php');

			// 读取当前模块的语言包
			if (file_exists(LANG_PATH.LANG_SET.'/'.strtolower(MODULE_NAME).'.php'))
				L(include LANG_PATH.LANG_SET.'/'.strtolower(MODULE_NAME).'.php');  

				// 写入语言包缓存文件
				$content  = "<?php\nreturn ".var_export(L(),true).";\n?>";
				file_put_contents(TEMP_PATH.MODULE_NAME.'_'.LANG_SET.'_lang.php',$content);
			}
		}else{
			// 不使用语言包功能，仅仅加载框架语言文件
			L(include THINK_PATH.'/Lang/'.C('DEFAULT_LANGUAGE').'.php');
		}
		return ;
    }

    /**
     +----------------------------------------------------------
     * 模板检查，如果不存在使用默认
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
    private function checkTemplate()
    {
		if(C('TMPL_SWITCH_ON')) {
			// 启用多模版
			$t = C('VAR_TEMPLATE');
			if ( isset($_GET[$t]) ) {
				$templateSet = $_GET[$t];
				Cookie::set('think_template',$templateSet,time()+3600);
			} else {
				if(Cookie::is_set('think_template')) {
					$templateSet = Cookie::get('think_template');
				}else {
					$templateSet =    C('DEFAULT_TEMPLATE');
					Cookie::set('think_template',$templateSet,time()+3600);
				}
			}
			if (!is_dir(TMPL_PATH.$templateSet)) {
				//模版不存在的话，使用默认模版
				$templateSet =    C('DEFAULT_TEMPLATE');
			}
			//模版名称
			define('TEMPLATE_NAME',$templateSet); 
			// 当前模版路径
			define('TEMPLATE_PATH',TMPL_PATH.TEMPLATE_NAME.'/'); 
			if(defined('C_MODULE_NAME')) {
				$array	=	explode(C('COMPONENT_DEPR'),C_MODULE_NAME);
				$tmplDir	=	TMPL_DIR.'/'.TEMPLATE_NAME.'/'.$array[0].'/';
			}else{
				$tmplDir	=	TMPL_DIR.'/'.TEMPLATE_NAME.'/';
			}
		}else{
			// 把模版目录直接放置项目模版文件
			// 该模式下面没有TEMPLATE_NAME常量
			define('TEMPLATE_PATH',TMPL_PATH); 
			$tmplDir	=	TMPL_DIR.'/';
		}

        //当前网站地址
        define('__ROOT__',WEB_URL);
        //当前项目地址
        define('__APP__',PHP_FILE);

		$module	=	defined('P_MODULE_NAME')?P_MODULE_NAME:MODULE_NAME;
		$action		=	defined('P_ACTION_NAME')?P_ACTION_NAME:ACTION_NAME;

        //当前页面地址
        define('__SELF__',$_SERVER['PHP_SELF']);
        // 默认加载的模板文件名
		if(defined('C_MODULE_NAME')) {
	        // 当前模块地址
	        define('__URL__',PHP_FILE.'/'.C_MODULE_NAME);
		    //当前操作地址
	        define('__ACTION__',__URL__.'/'.$action);  
	        C('TMPL_FILE_NAME',TEMPLATE_PATH.'/'.str_replace(C('COMPONENT_DEPR'),'/',C_MODULE_NAME).'/'.ACTION_NAME.C('TEMPLATE_SUFFIX'));
	        define('__CURRENT__', WEB_URL.'/'.APP_NAME.'/'.$tmplDir.str_replace(C('COMPONENT_DEPR'),'/',C_MODULE_NAME));
		}else{
		    // 当前模块地址
	        define('__URL__',PHP_FILE.'/'.$module);
		    //当前操作地址
	        define('__ACTION__',__URL__.'/'.$action);  
	        C('TMPL_FILE_NAME',TEMPLATE_PATH.'/'.MODULE_NAME.'/'.ACTION_NAME.C('TEMPLATE_SUFFIX'));
	        define('__CURRENT__', WEB_URL.'/'.APP_NAME.'/'.$tmplDir.MODULE_NAME);
		}

        //网站公共文件地址
        define('WEB_PUBLIC_URL', WEB_URL.'/Public');
        //项目公共文件地址
        define('APP_PUBLIC_URL', WEB_URL.'/'.APP_NAME.'/'.$tmplDir.'Public'); 

        return ;
    }

    /**
     +----------------------------------------------------------
     * 加载插件
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
    private function loadPlugIn()
    {
        //加载有效插件文件
		if(file_exists(RUNTIME_PATH.'~plugins.php')) {
			include RUNTIME_PATH.'~plugins.php';
		}else{
			// 检查插件数据
			$common_plugins = get_plugins(THINK_PATH.'/PlugIns','Think');// 公共插件
			$app_plugins = get_plugins();// 项目插件
			// 合并插件数据
			$plugins    = array_merge($common_plugins,$app_plugins);   
			// 缓存插件数据
			$content	=	'';
			foreach($plugins as $key=>$val) {
				include $val['file'];
				$content	.=	php_strip_whitespace($val['file']);
			}
			file_put_contents(RUNTIME_PATH.'~plugins.php',$content);
		}
        return ;
    }

    /**
     +----------------------------------------------------------
     * 执行应用程序
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
    public function exec()
    {
        //创建Action控制器实例
		if(defined('C_MODULE_NAME')) {
			$module  =  A(C_MODULE_NAME);
		}else{
			$module  =  A(MODULE_NAME);
		}
		if(!$module) {
			// 是否定义Empty模块
			$module	=	A("Empty");
			if(!$module) {
				// 模块不存在 抛出异常
				throw_exception(L('_MODULE_NOT_EXIST_').MODULE_NAME);    
			}
		}

        //获取当前操作名
        $action = ACTION_NAME.C('ACTION_SUFFIX');
		if(defined('C_ACTION_NAME')) {
			// 执行操作链 最多只能有一个输出
			$actionList	=	explode(C('COMPONENT_DEPR'),C_ACTION_NAME);
			foreach ($actionList as $action){
				$module->$action();
			}
		}else{
			//如果存在前置操作，首先执行
			if (method_exists($module,'_before_'.$action)) {    
				$module->{'_before_'.$action}();
			}
			//执行操作
			$module->{$action}();
			//如果存在后置操作，继续执行
			if (method_exists($module,'_after_'.$action)) {
				$module->{'_after_'.$action}();
			}  
		}
        // 执行应用结束过滤器
        apply_filter('app_end');

		// 写入错误日志
        if(C('WEB_LOG_RECORD'))
            Log::save();

        return ;
    }

    /**
     +----------------------------------------------------------
     * 运行应用实例 入口文件使用的快捷方法
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function run() {
		$this->init();
		$this->exec();
		return ;
	}

    /**
     +----------------------------------------------------------
     * 自定义异常处理
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $e 异常对象
     +----------------------------------------------------------
     */
    public function appException($e)
    {
        halt($e->__toString());
    }

    /**
     +----------------------------------------------------------
     * 自定义错误处理
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param int $errno 错误类型
     * @param string $errstr 错误信息
     * @param string $errfile 错误文件
     * @param int $errline 错误行数
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
    public function appError($errno, $errstr, $errfile, $errline)
    {
      switch ($errno) {
          case E_ERROR: 
          case E_USER_ERROR: 
              $errorStr = "错误：[$errno] $errstr ".basename($errfile)." 第 $errline 行.\n";
              if(C('WEB_LOG_RECORD')){
                 Log::record($errorStr);
				 Log::save();
              }
              halt($errorStr);
              break;
          case E_STRICT:
          case E_USER_WARNING:
          case E_USER_NOTICE:
          default: 
			$errorStr = "注意：[$errno] $errstr ".basename($errfile)." 第 $errline 行.\n";
			Log::record($errorStr);
             break;
      }
    }

};//类定义结束
?><?php 
// +----------------------------------------------------------------------
// | ThinkPHP                                                             
// +----------------------------------------------------------------------
// | Copyright (c) 2008 http://thinkphp.cn All rights reserved.      
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>                                  
// +----------------------------------------------------------------------
// $Id$

/**
 +------------------------------------------------------------------------------
 * ThinkPHP Action控制器基类 抽象类
 +------------------------------------------------------------------------------
 * @category   Think
 * @package  Think
 * @subpackage  Core
 * @author   liu21st <liu21st@gmail.com>
 * @version  $Id$
 +------------------------------------------------------------------------------
 */
abstract class Action extends Base
{//类定义开始

	// Action控制器名称
	protected $name;

    // 模板实例对象
    protected $tpl;

	// 需要缓存的action
	protected $_cacheAction = array();

    // 上次错误信息
    protected $error;

   /**
     +----------------------------------------------------------
     * 架构函数 取得模板对象实例
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     */
    public function __construct()
    {
        //实例化模板类
        $this->tpl = View::getInstance();    
		$this->name	=	$this->getActionName();
        //控制器初始化
        $this->_initialize();
    }

	/**
     +----------------------------------------------------------
     * 得到当前的Action对象名称
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     */
	public function getActionName() {
		if(empty($this->name)) {
			$prefix		=	C('CONTR_CLASS_PREFIX');
			$suffix		=	C('CONTR_CLASS_SUFFIX');
			if($suffix) {
				$this->name	=	substr(substr(get_class($this),strlen($prefix)),0,-strlen($suffix));
			}else{
				$this->name	=	substr(get_class($this),strlen($prefix));
			}
		}
		return $this->name;
	}

    /**
     +----------------------------------------------------------
     * 控制器初始化操作
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
    protected function _initialize() 
    {
		//判断是否有Action缓存
		if(C('ACTION_CACHE_ON') && in_array(ACTION_NAME,$this->_cacheAction,true)) {
			$content	=	S(md5(__SELF__));
			if($content) {
				echo $content;
				exit;
			}
		}
        return ;
    }

	protected function isAjax() {
		if(isset($_SERVER['HTTP_X_REQUESTED_WITH']) ) {
			if(strtolower($_SERVER['HTTP_X_REQUESTED_WITH'])=='xmlhttprequest')
				return true;
		}
        if(!empty($_POST[C('VAR_AJAX_SUBMIT')]) || !empty($_GET[C('VAR_AJAX_SUBMIT')])) {
            // 判断Ajax方式提交
            return true;
        }
		return false;
	}

    /**
     +----------------------------------------------------------
     * 记录乐观锁
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $data 数据对象
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	protected function cacheLockVersion($data) {
		$model	=	D($this->name);
		if($model->optimLock) {
			if(is_object($data))	$data	=	get_object_vars($data);
			if(isset($data[$model->optimLock]) && isset($data[$model->getPk()])) {
				$_SESSION[$model->getModelName().'_'.$data[$model->getPk()].'_lock_version']	=	$data[$model->optimLock];
			}
		}
	}

    /**
     +----------------------------------------------------------
     * 取得数据访问类的实例
     +----------------------------------------------------------
     * @access protected 
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
    protected function getModelClass() 
    {
        $model        = D($this->name);
        return $model;
    }

    /**
     +----------------------------------------------------------
     * 取得操作成功后要返回的URL地址
     * 默认返回当前模块的默认操作 
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
    protected function getReturnUrl() 
    {
		return url(C('DEFAULT_ACTION'));
    }

    /**
     +----------------------------------------------------------
     * 模板显示
     * 调用内置的模板引擎显示方法，
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $templateFile 指定要调用的模板文件
     * 默认为空 由系统自动定位模板文件
     * @param string $charset 输出编码
     * @param string $contentType 输出类型
     * @param string $varPrefix 模板变量前缀
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
    public function display($templateFile='',$charset='',$contentType='text/html',$varPrefix='')
    {
		if(C('ACTION_CACHE_ON') && in_array(ACTION_NAME,$this->_cacheAction,true)) {
			// 启用Action缓存
			$content	=	$this->fetch($templateFile,$charset,$contentType,$varPrefix);
			S(md5(__SELF__),$content);
			echo $content;
		}else{
	        $this->tpl->display($templateFile,$charset,$contentType,$varPrefix);
		}
    }

    /**
     +----------------------------------------------------------
     *  获取输出页面内容
     * 调用内置的模板引擎fetch方法，
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $templateFile 指定要调用的模板文件
     * 默认为空 由系统自动定位模板文件
     * @param string $charset 输出编码
     * @param string $contentType 输出类型
     * @param string $varPrefix 模板变量前缀
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
    public function fetch($templateFile='',$charset='',$contentType='text/html',$varPrefix='')
    {
        return $this->tpl->fetch($templateFile,$charset,$contentType,$varPrefix,false);
    }

    /**
     +----------------------------------------------------------
     *  输出布局页面内容
     * 调用内置的模板引擎fetch方法，
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $templateFile 指定要调用的布局模板文件
     * @param string $charset 输出编码
     * @param string $contentType 输出类型
     * @param string $varPrefix 模板变量前缀
     * @param boolean $display 是否输出
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
    public function layout($templateFile,$charset='',$contentType='text/html',$varPrefix='',$display=true)
    {
        return $this->tpl->layout($templateFile,$charset,$contentType,$varPrefix,$display);
    }

    /**
     +----------------------------------------------------------
     * 模板变量赋值
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $name 要显示的模板变量
     * @param mixed $value 变量的值
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
    public function assign($name,$value='')
    {
        $this->tpl->assign($name,$value);
    }

    /**
     +----------------------------------------------------------
     * Trace变量赋值
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $name 要显示的模板变量
     * @param mixed $value 变量的值
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
    public function trace($name,$value='')
    {
        $this->tpl->trace($name,$value);
    }

    /**
     +----------------------------------------------------------
     * 取得模板显示变量的值
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $name 模板显示变量
     +----------------------------------------------------------
     * @return mixed 
     +----------------------------------------------------------
     */
    public function get($name)
    {
        return $this->tpl->get($name);
    }

	protected function __set($name,$value) {
		$this->assign($name,$value);
	}

	protected function __get($name) {
		return $this->get($name);
	}
	
    /**
     +----------------------------------------------------------
     * 魔术方法 有不存在的操作的时候执行
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $name 模板显示变量
     +----------------------------------------------------------
     * @return mixed 
     +----------------------------------------------------------
     */
	private function __call($method,$parms) {
		if(strtolower($method) == strtolower(ACTION_NAME.C('ACTION_SUFFIX'))) {
			// 如果定义了_empty操作 则调用
			if(method_exists($this,'_empty')) {
				$this->_empty();
			}else {
				// 检查是否存在模版 如果有直接输出模版
				if(file_exists(C('TMPL_FILE_NAME'))) {
					$this->display();
				}else{
					// 调试模式抛出异常
					throw_exception(L('_ERROR_ACTION_').ACTION_NAME);      
				}
			}
		}
	}

    /**
     +----------------------------------------------------------
     * 操作错误跳转的快捷方法
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $errorMsg 错误信息
     * @param Boolean $ajax 是否为Ajax方式
     +----------------------------------------------------------
     * @return void 
     +----------------------------------------------------------
     */
    public function error($errorMsg,$ajax=false) 
    {
        if($ajax || $this->isAjax()) {
        	$this->ajaxReturn('',$errorMsg,0);
        }else {
            $this->assign('error',$errorMsg);
            $this->forward();        	
        }
    }

    /**
     +----------------------------------------------------------
     * 操作成功跳转的快捷方法
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $message 提示信息
     * @param Boolean $ajax 是否为Ajax方式
     +----------------------------------------------------------
     * @return void 
     +----------------------------------------------------------
     */
    public function success($message,$ajax=false) 
    {
        if($ajax || $this->isAjax()) {
        	$this->ajaxReturn('',$message,1);
        }else {
        	$this->assign('message',$message);
            $this->forward();
        }
    }

    /**
     +----------------------------------------------------------
     * Ajax方式返回数据到客户端
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $data 要返回的数据
     * @param String $info 提示信息
     * @param String $status 返回状态
     * @param String $status ajax返回类型 JSON XML
     +----------------------------------------------------------
     * @return void 
     +----------------------------------------------------------
     */
    public function ajaxReturn($data='',$info='',$status='',$type='') 
    {
		// 保存日志
		Log::save();
        $result  =  array();
        if($status === '') {
        	$status  = $this->get('error')?0:1;
        }
        if($info=='') {
            if($this->get('error')) { 
                $info =   $this->get('error');                	
            }elseif($this->get('message')) {
                $info =   $this->get('message');                	
            }         	
        }
        $result['status']  =  $status;
   	    $result['info'] =  $info;
        $result['data'] = $data;
		if(empty($type)) $type	=	C('AJAX_RETURN_TYPE');
		if(strtoupper($type)=='JSON') {
			// 返回JSON数据格式到客户端 包含状态信息
			header("Content-Type:text/html; charset=".C('OUTPUT_CHARSET'));
			exit(json_encode($result));
		}elseif(strtoupper($type)=='XML'){
			// 返回xml格式数据
			header("Content-Type:text/xml; charset=".C('OUTPUT_CHARSET'));
			exit(xml_encode($result));
		}else{
			// TODO 增加其它格式
		}
    }

    /**
     +----------------------------------------------------------
     * 执行某个Action操作（隐含跳转） 支持指定模块和延时执行
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $action 要跳转的Action 默认为_dispatch_jump
     * @param string $module 要跳转的Module 默认为当前模块
     * @param string $app 要跳转的App 默认为当前项目
     * @param boolean $exit  是否继续执行
     * @param integer $delay 延时跳转的时间 单位为秒
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
    public function forward($action='_dispatch_jump',$module=MODULE_NAME,$app=APP_NAME,$exit=false,$delay=0)
    {
        if(!empty($delay)) {
            //指定延时跳转 单位为秒
        	sleep(intval($delay));
        }
        if(is_array($action)) {
            //通过类似 array(&$module,$action)的方式调用
        	call_user_func($action);
        }else {
            if( MODULE_NAME!= $module) {
				$class =	 A($module,$app);
                call_user_func(array(&$class,$action));
            }else {
                // 执行当前模块操作
                $this->{$action}();
            }
        }
        if($exit) {
        	exit();
        }else {
        	return ;
        }
    }

    /**
     +----------------------------------------------------------
     * Action跳转(URL重定向） 支持指定模块和延时跳转
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $action 要跳转的Action 
     * @param string $module 要跳转的Module 默认为当前模块
     * @param string $app 要跳转的App 默认为当前项目
     * @param string $route 路由名
     * @param array $params 其它URL参数
     * @param integer $delay 延时跳转的时间 单位为秒
     * @param string $msg 跳转提示信息
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
	public function redirect($action,$module=MODULE_NAME,$route='',$app=APP_NAME,$params=array(),$delay=0,$msg='') {
		$url	=	url($action,$module,$route,$app,$params);
		redirect($url,$delay,$msg);
	}

    /**
     +----------------------------------------------------------
     * 默认跳转操作 支持错误导向和正确跳转 
     * 调用模板显示 默认为public目录下面的success页面
     * 提示页面为可配置 支持模板标签
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
    private function _dispatch_jump() 
    {
        if($this->isAjax() ) {
            // 用于Ajax附件上传 显示信息
            if($this->get('_ajax_upload_')) {
                header("Content-Type:text/html; charset=".C('OUTPUT_CHARSET'));
            	exit($this->get('_ajax_upload_'));
            }else {
            	$this->ajaxReturn();
            }
        }
        if($this->get('error') ) {
            $msgTitle    =   L('_OPERATION_FAIL_');
        }else {
            $msgTitle    =   L('_OPERATION_SUCCESS_');
        }
        //提示标题
        $this->assign('msgTitle',$msgTitle);
        if($this->get('message')) { //发送成功信息
            //成功操作后停留1秒
            if(!$this->get('waitSecond')) 
                $this->assign('waitSecond',"1");
            //默认操作成功自动返回操作前页面
            if(!$this->get('jumpUrl')) 
                $this->assign("jumpUrl",$_SERVER["HTTP_REFERER"]);
        }
        if($this->get('error')) { //发送错误信息
            //发生错误时候停留3秒
            if(!$this->get('waitSecond')) 
                $this->assign('waitSecond',"3");
            //默认发生错误的话自动返回上页
            if(!$this->get('jumpUrl')) 
                $this->assign('jumpUrl',"javascript:history.back(-1);");
        }
        //如果设置了关闭窗口，则提示完毕后自动关闭窗口
        if($this->get('closeWin')) {
            $this->assign('jumpUrl','javascript:window.close();');
        }
    	$this->display(C('ACTION_JUMP_TMPL'));
        // 中止执行  避免出错后继续执行
        exit ;       
    }
	
	// 404 错误定向
	protected function _404($message='',$jumpUrl='',$waitSecond=3) {
		$this->assign('msg',$message);
		if(!empty($jumpUrl)) {
			$this->assign('jumpUrl',$jumpUrl);
			$this->assign('waitSecond',$waitSecond);
		}
    	$this->display(C('ACTION_404_TMPL'));
	}

}//类定义结束
?><?php 
// +----------------------------------------------------------------------
// | ThinkPHP                                                             
// +----------------------------------------------------------------------
// | Copyright (c) 2008 http://thinkphp.cn All rights reserved.      
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>                                  
// +----------------------------------------------------------------------
// $Id$

define('HAS_ONE',1);
define('BELONGS_TO',2);
define('HAS_MANY',3);
define('MANY_TO_MANY',4);

define('MUST_TO_VALIDATE',1);	 // 必须验证
define('EXISTS_TO_VAILIDATE',0);		// 表单存在字段则验证
define('VALUE_TO_VAILIDATE',2);		// 表单值不为空则验证

/**
 +------------------------------------------------------------------------------
 * ThinkPHP Model模型类 抽象类
 * 实现了ORM和ActiveRecords模式
 +------------------------------------------------------------------------------
 * @category   Think
 * @package  Think
 * @subpackage  Core
 * @author    liu21st <liu21st@gmail.com>
 * @version   $Id$
 +------------------------------------------------------------------------------
 */
class Model extends Base  implements IteratorAggregate
{
	// 数据库连接对象列表
	protected $_db = array();

	// 当前数据库操作对象
	protected $db = null;

	// 数据表前缀
	protected $tablePrefix	=	'';

	// 数据表后缀
	protected $tableSuffix = '';

	// 模型名称
	protected $name	= '';

	// 数据表名（不包含表前缀）
	protected $tableName = '';

	// 实际数据表名（包含表前缀）
	protected $trueTableName ='';

	// 字段信息
	protected $fields = array();

	// 字段类型信息
	protected $type	 =	 array();

	// 数据信息
	protected $data	=	array();

	// 查询表达式参数
	protected $options	=	array();
	
	// 数据列表信息
	protected $dataList	=	array();

	// 上次错误信息
	protected $error = '';

	// 包含的聚合对象
	protected $aggregation = array();
	// 是否为复合对象
	protected $composite = false;
	// 是否为静态模型
	protected $staticModel = false;
	// 是否为视图模型
	protected $viewModel = false;

	// 乐观锁
	protected $optimLock = 'lock_version';
	// 悲观锁
	protected $pessimisticLock = false;

	protected $autoSaveRelations	= false;		// 自动关联保存
	protected $autoDelRelations		= false;		// 自动关联删除
	protected $autoAddRelations	= false;		// 自动关联写入
	protected $autoReadRelations	= false;		// 自动关联查询
	protected $lazyQuery	=	false;					// 是否启用惰性查询

	// 自动写入时间戳
	protected $autoCreateTimestamps = array('create_at','create_on','cTime');
	protected $autoUpdateTimestamps = array('update_at','update_on','mTime');
	protected $autoTimeFormat = '';

	protected $blobFields	 =	 null;
	protected $blobValues = null;

	/**
     +----------------------------------------------------------
     * 架构函数 
	 * 取得DB类的实例对象 数据表字段检查
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $data 要创建的数据对象内容
     +----------------------------------------------------------
     */
	public function __construct($data='')
	{
		// 模型初始化
		$this->_initialize();
		// 模型名称获取
		$this->name	=	$this->getModelName();
		// 如果不是复合对象进行数据库初始化操作
		if(!$this->composite) {
			// 静态模型
			if($this->staticModel && S($this->name)) {
				// 获取数据后生成静态缓存
				$this->dataList	=	S($this->name);
			}else{
				import("Think.Db.Db");
				// 获取数据库操作对象
				if(!empty($this->connection)) {
					// 当前模型有独立的数据库连接信息
					$this->db = Db::getInstance($this->connection);
				}else{
					$this->db = Db::getInstance();
				}
				// 设置数据库的返回数据格式
				$this->db->resultType	=	C('DATA_RESULT_TYPE');
				// 设置默认的数据库连接
				$this->_db[0]	=	&$this->db;
				// 设置表前后缀
				$this->tablePrefix = C('DB_PREFIX')|'';
				$this->tableSuffix = C('DB_SUFFIX')|'';
				// 数据表字段检测
				$this->_checkTableInfo();
				// 静态模型
				if($this->staticModel) {
					// 获取数据后生成静态缓存
					S($this->name,$this->findAll());
				}
			}
		}
		// 如果有data数据进行实例化，则创建数据对象
		if(!empty($data)) {
			$this->create($data);
		}
	}

	/**
     +----------------------------------------------------------
     * 取得模型实例对象
     +----------------------------------------------------------
     * @static
     * @access public 
     +----------------------------------------------------------
     * @return mixed 返回数据模型实例
     +----------------------------------------------------------
     */
	public static function getInstance()
	{
		return get_instance_of(__CLASS__);
	}

	/**
     +----------------------------------------------------------
     * 设置数据对象的值 （魔术方法）
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @param string $name 名称
     * @param mixed $value 值
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
	private function __set($name,$value) {
		// 设置数据对象属性
		$this->data[$name]	=	$value;
	}

	/**
     +----------------------------------------------------------
     * 获取数据对象的值 （魔术方法）
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @param string $name 名称
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     */
	private function __get($name) {
		if(isset($this->data[$name])) {
			return $this->data[$name];
		}elseif(property_exists($this,$name)){
			return $this->$name;
		}else{
			return null;
		}
	}

	/**
     +----------------------------------------------------------
     * 利用__call方法重载 实现一些特殊的Model方法 （魔术方法）
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @param string $method 方法名称
     * @param mixed $args 调用参数
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     */
	private function __call($method,$args) {
		if(strtolower(substr($method,0,5))=='getby') {
			// 根据某个字段获取记录
			$field	 =	 strtolower(substr($method,5));
			if(in_array($field,$this->fields,true)) {
				array_unshift($args,$field);
				return call_user_func_array(array(&$this, 'getBy'), $args);
			}
		}elseif(strtolower(substr($method,0,6))=='getsby') {
			// 根据某个字段获取记录
			$field	 =	 strtolower(substr($method,6));
			if(in_array($field,$this->fields,true)) {
				array_unshift($args,$field);
				return call_user_func_array(array(&$this, 'getByAll'), $args);
			}
		}elseif(strtolower(substr($method,0,3))=='get'){
			// getter 模拟 仅针对数据对象
			$field	 =	 strtolower(substr($method,3));
			return $this->__get($field);
		}elseif(strtolower(substr($method,0,3))=='top'){
			// 获取前N条记录
			$count = substr($method,3);
			array_unshift($args,$count);
			return call_user_func_array(array(&$this, 'topN'), $args);
		}elseif(strtolower(substr($method,0,5))=='setby'){
			// 保存记录的某个字段
			$field	 =	 strtolower(substr($method,5));
			if(in_array($field,$this->fields,true)) {
				array_unshift($args,$field);
				return call_user_func_array(array(&$this, 'setField'), $args);
			}
		}elseif(strtolower(substr($method,0,3))=='set'){
			// setter 模拟 仅针对数据对象
			$field	 =	 strtolower(substr($method,3));
			array_unshift($args,$field);
			return call_user_func_array(array(&$this, '__set'), $args);
		}elseif(strtolower(substr($method,0,5))=='delby'){
			// 根据某个字段删除记录
			$field	 =	 strtolower(substr($method,5));
			if(in_array($field,$this->fields,true)) {
				array_unshift($args,$field);
				return call_user_func_array(array(&$this, 'deleteBy'), $args);
			}
		}elseif(strtolower(substr($method,0,3))=='del'){
			// unset 数据对象
			$field	 =	 strtolower(substr($method,3));
			if(in_array($field,$this->fields,true)) {
				if(isset($this->data[$field])) {
					unset($this->data[$field]);
				}
			}
		}
		return;
	}

	// 回调方法 初始化模型
	protected function _initialize() {}

	/**
     +----------------------------------------------------------
     * 数据库Create操作入口
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @param array $data 要create的数据
     * @param boolean $autoLink 是否关联写入
     +----------------------------------------------------------
     * @return false|integer
     +----------------------------------------------------------
     */
	private function _create(&$data,$autoLink=false,$multi=false) {
		// 前置调用
		if(!$this->_before_create($data)) {
			return false;
		}
		// 插入数据库
		if(false === $result = $this->db->add($data,$this->getTableName(),$multi)){
			// 数据库插入操作失败
			$this->error = L('_OPERATION_WRONG_');
			return false;
		}else {
			$insertId	=	$this->getLastInsID();
			if($insertId && !isset($data[$this->getPk()])) {
				$data[$this->getPk()]	=	 $insertId;
			}
			$this->saveBlobFields($data);
			// 保存关联记录
			if ($this->autoAddRelations || $autoLink){
				$this->opRelation('ADD',$data);
			}
			// 后置调用
			$this->_after_create($data);
			//成功后返回插入ID
			return $insertId ?	$insertId	: $result;
		}
	}
	// Create回调方法 before after 
	protected function _before_create(&$data) {return true;}
	protected function _after_create(&$data) {}

	/**
     +----------------------------------------------------------
     * 数据库Update操作入口
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @param array $data 要create的数据
     * @param mixed $where 更新条件
     * @param string $limit limit
     * @param string $order order
     * @param boolean $autoLink 是否关联写入
     * @param boolean $lock 是否加锁
     +----------------------------------------------------------
     * @return boolean
     +----------------------------------------------------------
     */
	private function _update(&$data,$where='',$limit='',$order='',$autoLink=false,$lock=false) {
		$table		=	$this->getTableName();
		if(!empty($this->options)) {
			// 已经有定义的查询表达式
			$where	=	isset($this->options['where'])?		$this->options['where']:	$where;
			$limit		=	isset($this->options['limit'])?		$this->options['limit']:		$limit;
			$order	=	isset($this->options['order'])?		$this->options['order']:	$order;
			$lock		=	isset($this->options['lock'])?		$this->options['lock']:	 	$lock;
			$autoLink=	isset($this->options['link'])?			$this->options['link']:		$autoLink;
			$table		=	isset($this->options['table'])?		$this->options['table']:	$this->getTableName();
			$this->options	=	array();
		}
		// 前置调用
		if(!$this->_before_update($data,$where)) {
			return false;
		}
		$lock	 =	 ($this->pessimisticLock || $lock);
		if($this->viewModel) {
			$where	=	$this->checkCondition($where);
		}
		if(false === $this->db->save($data,$table,$where,$limit,$order,$lock)){
			$this->error = L('_OPERATION_WRONG_');
			return false;
		}else {
			$this->saveBlobFields($data);
			// 保存关联记录
			if ($this->autoSaveRelations || $autoLink){
				$this->opRelation('SAVE',$data);
			}
			// 后置调用
			$this->_after_update($data,$where);
			return true;
		}
	}
	// 更新回调方法 
	protected function _before_update(&$data,$where) {return true;}
	protected function _after_update(&$data,$where) {}

	/**
     +----------------------------------------------------------
     * 数据库Read操作入口
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @param mixed $condition 查询条件
     * @param string $fields 查询字段
     * @param boolean $all 是否返回多个数据
     * @param string $order 
     * @param string $limit 
     * @param string $group 
     * @param string $having 
     * @param string $join 
     * @param boolean $cache 是否查询缓存
     * @param boolean $relation 是否关联查询
     * @param boolean $lazy 是否惰性查询
     * @param boolean $lock 是否加锁
     +----------------------------------------------------------
     * @return boolean
     +----------------------------------------------------------
     */
	private function _read($condition='',$fields='*',$all=false,$order='',$limit='',$group='',$having='',$join='',$cache=false,$relation=false,$lazy=false,$lock=false) {
		$table		=	$this->getTableName();
		if(!empty($this->options)) {
			// 已经有定义的查询表达式
			$condition	=	isset($this->options['where'])?			$this->options['where']:	$condition;
			$table			=	isset($this->options['table'])?			$this->options['table']:	$this->getTableName();
			$fields		=	isset($this->options['field'])?			$this->options['field']:	$fields;
			$limit			=	isset($this->options['limit'])?			$this->options['limit']:		$limit;
			$order		=	isset($this->options['order'])?			$this->options['order']:	$order;
			$group		=	isset($this->options['group'])?			$this->options['group']:	$group;
			$having		=	isset($this->options['having'])?		$this->options['having']:	$having;
			$join			=	isset($this->options['join'])?			$this->options['join']:		$join;
			$cache		=	isset($this->options['cache'])?			$this->options['cache']:	$cache;
			$lock			=	isset($this->options['lock'])?			$this->options['lock']:		$lock;
			$lazy			=	isset($this->options['lazy'])?			$this->options['lazy']:	$lazy;
			$relation		=	isset($this->options['link'])?				$this->options['link']:		$relation;
			$this->options	=	array();
		}
		// 前置调用
		if(!$this->_before_read($condition)) {
			// 如果返回false 中止
			return false;
		}
		if($cache) {//启用动态数据缓存
			if($all) {
				$identify   = $this->name.'List_'.to_guid_string(func_get_args());
			}else{
				$identify   = $this->name.'_'.to_guid_string($condition);
			}
			$result  =  S($identify);
			if(false !== $result) {
				if(!$all) {
					$this->cacheLockVersion($result);
				}
				// 后置调用
				$this->_after_read($condition,$result);
				return $result;
			}
		}
		if($this->viewModel) {
			$condition	=	$this->checkCondition($condition);
			$fields	=	$this->checkFields($fields);
			$order	=	$this->checkOrder($order);
			$group	=	$this->checkGroup($group);
		}
		$lazy	 =	 ($this->lazyQuery || $lazy);
		$lock	 =	 ($this->pessimisticLock || $lock);
		$rs = $this->db->find($condition,$table,$fields,$order,$limit,$group,$having,$join,$cache,$lazy,$lock);
		$result	=	$this->rsToVo($rs,$all,0,$relation);
		// 后置调用
		$this->_after_read($condition,$result);
		if($result && $cache) {
			S($identify,$result);
		}
		return $result;
	}
	// Read回调方法
	protected function _before_read(&$condition) {return true;}
	protected function _after_read(&$condition,$result) {}

	/**
     +----------------------------------------------------------
     * 数据库Delete操作入口
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @param mixed $data 删除的数据
     * @param mixed $condition 查询条件
     * @param string $limit 
     * @param string $order 
     * @param boolean $autoLink 是否关联删除
     +----------------------------------------------------------
     * @return boolean
     +----------------------------------------------------------
     */
	private function _delete($data,$where='',$limit=0,$order='',$autoLink=false) {
		$table		=	$this->getTableName();
		if(!empty($this->options)) {
			// 已经有定义的查询表达式
			$where		=	isset($this->options['where'])?		$this->options['where']:	$where;
			$table			=	isset($this->options['table'])?		$this->options['table']:	$this->getTableName();
			$limit			=	isset($this->options['limit'])?		$this->options['limit']:		$limit;
			$order		=	isset($this->options['order'])?		$this->options['order']:	$order;
			$autoLink	=	isset($this->options['link'])?			$this->options['link']:		$autoLink;
			$this->options	=	array();
		}
		// 前置调用
		if(!$this->_before_delete($where)) {
			return false;
		}
		if($this->viewModel) {
			$where	=	$this->checkCondition($where);
		}
		$result=    $this->db->remove($where,$table,$limit,$order);
		if(false === $result ){
			$this->error =  L('_OPERATION_WRONG_');
			return false;
		}else {
			// 删除Blob数据
			$this->delBlobFields($data);
			// 删除关联记录
			if ($this->autoDelRelations || $autoLink){
				$this->opRelation('DEL',$data);
			}
			// 后置调用
			$this->_after_delete($where);
			//返回删除记录个数
			return $result;
		}
	}
	// Delete回调方法
	protected function _before_delete(&$where) {return true;}
	protected function _after_delete(&$where) {}

	/**
     +----------------------------------------------------------
     * 数据库Query操作入口(使用SQL语句的Query）
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @param mixed $sql 查询的SQL语句
     * @param boolean $cache 是否使用查询缓存
     * @param boolean $lazy 是否惰性查询
     * @param boolean $lock 是否加锁
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     */
	private function _query($sql='',$cache=false,$lazy=false,$lock=false) {
		if(!empty($this->options)) {
			$sql		=	isset($this->options['sql'])?			$this->options['sql']:		$sql;
			$cache	=	isset($this->options['cache'])?		$this->options['cache']:	$cache;
			$lazy		=	isset($this->options['lazy'])?		$this->options['lazy']:	$lazy;
			$lock		=	isset($this->options['lock'])?		$this->options['lock']:		$lock;
			$this->options	=	array();
		}
		if(!$this->_before_query($sql)) {
			return false;
		}
		if($cache) {//启用动态数据缓存
			$identify   = md5($sql);
			$result =   S($identify);
			if(false !== $result) {
				return $result;
			}
		}
		$lazy	 =	 ($this->lazyQuery || $lazy);
		$lock	 =	 ($this->pessimisticLock || $lock);
		$result =   $this->db->query($sql,$cache,$lazy,$lock);
		if($cache)    S($identify,$result);
		$this->_after_query($result);
		return $result;
	}
	// Query回调方法
	protected function _before_query(&$sql) {return true;}
	protected function _after_query(&$result) {}

	/**
     +----------------------------------------------------------
     * 数据表字段检测 并自动缓存
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @return boolean
     +----------------------------------------------------------
     */
	private function _checkTableInfo() {
		// 如果不是Model类 自动记录数据表信息
		// 只在第一次执行记录
		if(empty($this->fields) && strtolower(get_class($this))!='model') {
			// 如果数据表字段没有定义则自动获取
			if(C('DB_FIELDS_CACHE')) {
				$identify	=	$this->name.'_fields';
				$this->fields = F($identify);
				if(!$this->fields) {
					$this->flush();
				}
			}else{
				// 每次都会读取数据表信息
				$this->flush();
			}
		}
	}

	/**
     +----------------------------------------------------------
     * 强制刷新数据表信息
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
	public function flush() {
		// 缓存不存在则查询数据表信息
		if($this->viewModel) {
			// 缓存视图模型的字段信息
			$this->fields = array();
			$this->fields['_autoInc'] = false;
			foreach ($this->viewFields as $name=>$val){
				foreach ($val as $key=>$field){
					if(is_numeric($key)) {
						$this->fields[]	=	$name.'.'.$field;
					}else{
						$this->fields[]	=	$name.'.'.$key;
					}
				}
			}
		}else{
			$fields	=	$this->db->getFields($this->getTableName());
			$this->fields	=	array_keys($fields);
			$this->fields['_autoInc'] = false;
			foreach ($fields as $key=>$val){
				// 记录字段类型
				$this->type[$key]	 =	 $val['type'];
				if($val['primary']) {
					$this->fields['_pk']	=	$key;
					if($val['autoInc'])	$this->fields['_autoInc']	=	true;
				}
			}
		}
		// 2008-3-7 增加缓存开关控制
		if(C('DB_FIELDS_CACHE')) {
			// 永久缓存数据表信息
			// 2007-10-31 更改为F方法保存，保存在项目的Data目录，并且始终采用文件形式
			$identify	=	$this->name.'_fields';
			F($identify,$this->fields);
		}
	}

	/**
     +----------------------------------------------------------
     * 获取数据集的文本字段
     +----------------------------------------------------------
     * @access pubic 
     +----------------------------------------------------------
     * @param mixed $resultSet 查询的数据
     * @param string $field 查询的字段
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
	public function getListBlobFields(&$resultSet,$field='') {
		if(!empty($this->blobFields)) {
			foreach ($resultSet as $key=>$result){
				$result	=	$this->getBlobFields($result,$field);
				$resultSet[$key]	=	$result;
			}
		}
	}

	/**
     +----------------------------------------------------------
     * 获取数据的文本字段
     +----------------------------------------------------------
     * @access pubic 
     +----------------------------------------------------------
     * @param mixed $data 查询的数据
     * @param string $field 查询的字段
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
	public function getBlobFields(&$data,$field='') {
		if(!empty($this->blobFields)) {
			$pk	=	$this->getPk();
			$id	=	is_array($data)?$data[$pk]:$data->$pk;
			if(empty($field)) {
				foreach ($this->blobFields as $field){
					if($this->viewModel) {
						$identify	=	$this->masterModel.'_'.$id.'_'.$field;
					}else{
						$identify	=	$this->name.'_'.$id.'_'.$field;
					}
					if(is_array($data)) {
						$data[$field]	=	F($identify);
					}else{
						$data->$field	 =	 F($identify);
					}
				}
				return $data;
			}else{
				$identify	=	$this->name.'_'.$id.'_'.$field;
				return F($identify);
			}
		}
	}

	/**
     +----------------------------------------------------------
     * 保存File方式的字段
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $data 保存的数据
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
	public function saveBlobFields(&$data) {
		if(!empty($this->blobFields)) {
			foreach ($this->blobValues as $key=>$val){
				if(strpos($key,'@@_?id_@@')) {
					$key	=	str_replace('@@_?id_@@',$data[$this->getPk()],$key);
				}
				F($key,$val);
			}
		}
	}

	/**
     +----------------------------------------------------------
     * 删除File方式的字段
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $data 保存的数据
     * @param string $field 查询的字段
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
	public function delBlobFields(&$data,$field='') {
		if(!empty($this->blobFields)) {
			$pk	=	$this->getPk();
			$id	=	is_array($data)?$data[$pk]:$data->$pk;
			if(empty($field)) {
				foreach ($this->blobFields as $field){
					$identify	=	$this->name.'_'.$id.'_'.$field;
					F($identify,null);
				}
			}else{
				$identify	=	$this->name.'_'.$id.'_'.$field;
				F($identify,null);
			}
		}
	}

	/**
     +----------------------------------------------------------
     * 获取Iterator因子
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return Iterate
     +----------------------------------------------------------
     */
	public function getIterator()
	{
		if(!empty($this->dataList)) {
			// 存在数据集则返回数据集
			return new ArrayObject($this->dataList);
		}elseif(!empty($this->data)){
			// 存在数据对象则返回对象的Iterator
			return new ArrayObject($this->data);
		}else{
			// 否则返回字段名称的Iterator
			$fields = $this->fields;
			unset($fields['_pk'],$fields['_autoInc']);
			return new ArrayObject($fields);
		}
	}

	/**
     +----------------------------------------------------------
     * 把数据对象转换成数组
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return array
     +----------------------------------------------------------
     */
	public function toArray()
	{
		if(!empty($this->dataList)) {
			return $this->dataList;
		}elseif (!empty($this->data)){
			return $this->data;
		}
		return false;
	}

	/**
     +----------------------------------------------------------
     * 新增数据 支持数组、HashMap对象、std对象、数据对象
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $data 数据
     * @param boolean $autoLink 自动关联写入
     * @param boolean $multi 多数据写入
     +----------------------------------------------------------
     * @return int
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function add($data=null,$autoLink=false,$multi=false)
	{
		if(empty($data)) {
			// 没有传递数据，获取当前数据对象的值
			if(!empty($this->options['data'])) {
				$data	 =	 $this->options['data'];
			}elseif(!empty($this->data)) {
				$data	 =	 $this->data;
			}elseif(!empty($this->dataList)){
				return $this->addAll($this->dataList);
			}else{
				$this->error = L('_DATA_TYPE_INVALID_');
				return false;
			}
		}
		// 对保存到数据库的数据对象进行处理
		$data	=	$this->_facade($data);
		if(!$data) {
			$this->error = L('_DATA_TYPE_INVALID_');
			return false;
		}
		if($this->fields['_autoInc'] && isset($data[$this->getPk()])) {
			//如果主键为自动增长类型
			//删除主键属数据 由数据库自动生成
			unset($data[$this->getPk()]);
		}
		// 记录乐观锁
		if($this->optimLock && !isset($data[$this->optimLock]) ) {
			if(in_array($this->optimLock,$this->fields,true)) {
				$data[$this->optimLock]	 =	 0;
			}
		}
		return $this->_create($data,$autoLink);
	}

	/**
     +----------------------------------------------------------
     * 对保存到数据库的数据对象进行处理
	 * 统一使用数组方式到数据库中间层 facade字段支持
     +----------------------------------------------------------
     * @access protected 
     +----------------------------------------------------------
     * @param mixed $data 要操作的数据
     +----------------------------------------------------------
     * @return boolean
     +----------------------------------------------------------
     */
	protected function _facade($data) {
		if(is_instance_of($data,'HashMap')){
			// Map对象转换为数组
			$data = $data->toArray();
		}elseif(is_object($data)) {
			$data	 =	 get_object_vars($data);
		}elseif(is_string($data)){
			parse_str($data,$data);
		}elseif(!is_array($data)){
			return false;
		}
		// 检查聚合对象
		if(!empty($this->aggregation)) {
			foreach ($this->aggregation as $name){
				if(is_array($name)) {
					$fields	=	$name[1];
					$name	=	$name[0];
					if(is_string($fields)) $fields = explode(',',$fields);
				}
				if(!empty($data[$name])) {
					$combine = (array)$data[$name];
					if(!empty($fields)) {
						// 限制聚合对象的字段属性
						foreach ($fields as $key=>$field){
							if(is_int($key)) $key = $field;
							if(isset($combine[$key])) {
								$data[$field]	=	$combine[$key];
							}
						}
					}else{
						// 直接合并数据
						$data = $data+$combine;
					}
					unset($data[$name]);
				}
			}
		}
		// 检查非数据字段
		foreach ($data as $key=>$val){
			if(!$this->viewModel && empty($this->_link)) {
				if(!in_array($key,$this->fields,true)) {
					unset($data[$key]);
				}
			}
		}
		// 检查Blob文件保存字段
		if(!empty($this->blobFields)) {
			foreach ($this->blobFields as $field){
				if(isset($data[$field])) {
					if(isset($data[$this->getPk()])) {
						$this->blobValues[$this->name.'_'.$data[$this->getPk()].'_'.$field]	=	$data[$field];
					}else{
						$this->blobValues[$this->name.'_@@_?id_@@_'.$field]	=	$data[$field];
					}
					unset($data[$field]);
				}
			}
		}
		// 检查字段映射
		if(isset($this->_map)) {
			foreach ($this->_map as $key=>$val){
				if(isset($data[$key])) {
					$data[$val]	=	$data[$key];
					unset($data[$key]);
				}
			}
		}
		return $data;
	}

	/**
     +----------------------------------------------------------
     * 检查条件中的视图字段
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $data 条件表达式
     +----------------------------------------------------------
     * @return array
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */	
	public function checkCondition($data) {
		 if((empty($data) || (is_instance_of($data,'HashMap') && $data->isEmpty())) && !empty($this->viewCondition)) {
			 $data = $this->viewCondition;
		 }elseif(!is_string($data)) {
			$data	 =	 $this->_facade($data);
			$baseCondition = $this->viewCondition;
			$view	=	array();
			// 检查视图字段
			foreach ($this->viewFields as $key=>$val){
				foreach ($data as $name=>$value){
					if(false !== $field = array_search($name,$val)) {
						// 存在视图字段
						if(is_numeric($field)) {
							$_key	=	$key.'.'.$name;
						}else{
							$_key	=	$key.'.'.$field;
						}
						$view[$_key]	=	$value;
						unset($data[$name]);
						if(is_array($baseCondition) && isset($baseCondition[$_key])) {
							// 组合条件处理
							$view[$_key.','.$_key]	=	array($value,$baseCondition[$_key]);
							unset($baseCondition[$_key]);
							unset($view[$_key]);
						}
					}
				}
			}
			//if(!empty($view) && !empty($baseCondition)) {
				$data	 =	 array_merge($data,$baseCondition,$view);
			//}
		 }
		return $data;
	}

	/**
     +----------------------------------------------------------
     * 检查fields表达式中的视图字段
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $fields 字段
     +----------------------------------------------------------
     * @return array
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */	
	public function checkFields($fields) {
		if(empty($fields) || '*'==$fields ) {
			// 获取全部视图字段
			$fields	=	array();
			foreach ($this->viewFields as $name=>$val){
				foreach ($val as $key=>$field){
					if(is_numeric($key)) {
						$fields[]	 =	 $name.'.'.$field.' AS '.$field;
					}else{
						$fields[]	 =	 $name.'.'.$key.' AS '.$field;
					}
				}
			}
		}else{
			$fields	=	explode(',',$fields);
			// 解析成视图字段
			foreach ($this->viewFields as $name=>$val){
				foreach ($fields as $key=>$field){
					if(false !== $_field = array_search($field,$val)) {
						// 存在视图字段
						if(is_numeric($_field)) {
							$fields[$key]	 =	 $name.'.'.$field.' AS '.$field;
						}else{
							$fields[$key]	 =	 $name.'.'.$_field.' AS '.$field;
						}
					}
				}
			}
		}
		$fields = implode(',',$fields);
		return $fields;
	}

	/**
     +----------------------------------------------------------
     * 检查Order表达式中的视图字段
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $order 字段
     +----------------------------------------------------------
     * @return array
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */	
	public function checkOrder($order) {
		 if(!empty($order)) {
			$orders = explode(',',$order);
			$_order = array();
			foreach ($orders as $order){
				$array = explode(' ',$order);
				$field	 =	 $array[0];
				$sort	 =	 isset($array[1])?$array[1]:'ASC';
				// 解析成视图字段
				foreach ($this->viewFields as $name=>$val){
					if(false !== $_field = array_search($field,$val)) {
						// 存在视图字段
						if(is_numeric($_field)) {
							$field =	 $name.'.'.$field;
						}else{
							$field	 =	 $name.'.'.$_field;
						}
						break;
					}
				}
				$_order[] = $field.' '.$sort;
			}
			$order = implode(',',$_order);
		 }
		return $order;
	}

	/**
     +----------------------------------------------------------
     * 检查Group表达式中的视图字段
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $group 字段
     +----------------------------------------------------------
     * @return array
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */	
	public function checkGroup($group) {
		 if(empty($group)) {
			 $group = $this->getPk();
		 }
		$groups = explode(',',$group);
		$_group = array();
		foreach ($groups as $group){
			$array = explode(' ',$group);
			$field	 =	 $array[0];
			$sort	 =	 isset($array[1])?$array[1]:'';
			// 解析成视图字段
			foreach ($this->viewFields as $name=>$val){
				if(false !== $_field = array_search($field,$val)) {
					// 存在视图字段
					if(is_numeric($_field)) {
						$field =	 $name.'.'.$field;
					}else{
						$field	 =	 $name.'.'.$_field;
					}
					break;
				}
			}
			$_group[$field] = $field.' '.$sort;
		}
		$group	=	$_group;
		return $group;
	}

	/**
     +----------------------------------------------------------
     * 批量新增数据
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $dataList 数据列表
     * @param boolean $autoLink 自动关联操作
     +----------------------------------------------------------
     * @return boolen
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function addAll($dataList='',$autoLink=false)
	{
		if(empty($dataList)) {
			$dataList	=	$this->dataList;
		}elseif(!is_array($dataList)) {
			$this->error = L('_DATA_TYPE_INVALID_');
			return false;
		}
		return $this->_create($dataList,$autoLink,true);
	}

	/**
     +----------------------------------------------------------
     * 更新数据
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $data 要更新的数据
     * @param mixed $where 更新数据的条件
     * @param boolean $autoLink 自动关联操作
     * @param integer $limit 要更新的记录数
     * @param string $order  更新的顺序
     +----------------------------------------------------------
     * @return boolen
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function save($data=null,$where='',$autoLink=false,$limit=0,$order='')
	{
		if(empty($data)) {
			if(!empty($this->options['data'])) {
				$data	 =	 $this->options['data'];
			}elseif(!empty($this->data)) {
				// 保存当前数据对象
				$data	 =	 $this->data;
			}elseif(!empty($this->dataList)){
				// 保存当前数据集
				$data	 =	 $this->dataList;
				$this->startTrans();
				foreach ($data as $val){
					$result   =  $this->save($val,$where,$autoLink);
				}
				$this->commit();
				return $result;
			}
		}
		$data	=	$this->_facade($data);
		if(!$data) {
			$this->error = L('_DATA_TYPE_INVALID_');
			return false;
		}
		if(empty($where) && isset($data[$this->getPk()])) {
			$where  = $this->getPk()."=".$data[$this->getPk()];
			unset($data[$this->getPk()]);
		}
		// 检查乐观锁
		if(!$this->checkLockVersion($data,$where)) {
			$this->error = L('_RECORD_HAS_UPDATE_');
			return false;
		}
		return $this->_update($data,$where,$limit,$order,$autoLink);
	}

	/**
     +----------------------------------------------------------
     * 检查乐观锁
     +----------------------------------------------------------
     * @access protected 
     +----------------------------------------------------------
     * @param array $data  当前数据
     * @param mixed $where 查询条件
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	protected function checkLockVersion(&$data,&$where='') {
		$pk	=	$this->getPk();
		$id	=	$data[$pk];
		if(empty($where) && isset($id) ) {
			$where  = $pk."=".$id;
		}
		// 检查乐观锁
		$identify   = $this->name.'_'.$id.'_lock_version';
		if($this->optimLock && isset($_SESSION[$identify])) {
			$lock_version = $_SESSION[$identify];
			if(!empty($where)) {
				$vo = $this->find($where,$this->optimLock);
			}else {
				$vo = $this->find($data,$this->optimLock);
			}
			$_SESSION[$identify]	 =	 $lock_version;
			$curr_version = is_array($vo)?$vo[$this->optimLock]:$vo->{$this->optimLock};
			if(isset($curr_version)) {
				if($curr_version>0 && $lock_version != $curr_version) {
					// 记录已经更新
					return false;
				}else{
					// 更新乐观锁
					$save_version = $data[$this->optimLock];
					if($save_version != $lock_version+1) {
						$data[$this->optimLock]	 =	 $lock_version+1;
					}
					$_SESSION[$identify]	 =	 $lock_version+1;
				}
			}
		}
		//unset($data[$pk]);
		return true;
	}

	/**
     +----------------------------------------------------------
     * 获取返回数据的关联记录
	 * relation['name'] 关联名称 relation['type'] 关联类型
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $result  返回数据
     * @param array $relation  关联信息
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function getRelation(&$result,$relation=array())
	{
		if(!empty($this->_link)) {
			foreach($this->_link as $val) {
				if(empty($relation['type']) || $val['mapping_type']==$relation['type']) {
					$mappingName =  !empty($val['mapping_name'])?$val['mapping_name']:$val['class_name'];	// 映射名称
					if(empty($relation['name']) || $mappingName == $relation['name']) {
						$mappingType = $val['mapping_type'];	//  关联类型
						$mappingClass  = $val['class_name'];			//  关联类名
						$mappingFk   =  !empty($val['foreign_key'])?$val['foreign_key']:$this->name.'_id';		//  关联外键
						$mappingFields = !empty($val['mapping_fields'])?$val['mapping_fields']:'*';		// 映射字段
						$mappingCondition = !empty($val['condition'])?$val['condition']:'1=1';			// 关联条件
						if(strtoupper($mappingClass)==strtoupper($this->name)) {
							// 自引用关联 获取父键名
							$mappingParentKey = !empty($val['parent_key'])? $val['parent_key'] : 'parent_id';
						}
						// 获取关联模型对象
						$model = D($mappingClass);
						switch($mappingType) {
							case HAS_ONE:
								$pk   =  is_array($result)?$result[$this->getPk()]:$result->{$this->getPk()};
								$mappingCondition .= " AND {$mappingFk}={$pk}";
								$relationData   =  $model->find($mappingCondition,$mappingFields,false,false);
								break;
							case BELONGS_TO:
								$fk   =  is_array($result)?$result[$mappingFk]:$result->{$mappingFk};
								$mappingCondition .= " AND {$model->getPk()}={$fk}";
								$relationData   =  $model->find($mappingCondition,$mappingFields,false,false);
								if(isset($val['as_fields'])) {
									// 支持直接把关联的字段值映射成数据对象中的某个字段
									$fields	=	explode(',',$val['as_fields']);
									foreach ($fields as $field){
										$fieldAs = explode(':',$field);
										if(count($fieldAs)>1) {
											$fieldFrom = $fieldAs[0];
											$fieldTo		=	$fieldAs[1];
										}else{
											$fieldFrom	 =	 $field;
											$fieldTo		=	$field;
										}
										$fieldVal	 =	 is_array($relationData)?$relationData[$fieldFrom]:$relationData->$fieldFrom;
										if(isset($fieldVal)) {
											if(is_array($result)) {
												$result[$fieldTo]	=	$fieldVal;
											}else{
												$result->$fieldTo	=	$fieldVal;
											}
										}
									}
								}
								break;
							case HAS_MANY:
								$pk   =  is_array($result)?$result[$this->getPk()]:$result->{$this->getPk()};
								$mappingCondition = "{$mappingFk}={$pk}";
								$mappingOrder =  !empty($val['mapping_order'])?$val['mapping_order']:'';
								$mappingLimit =  !empty($val['mapping_limit'])?$val['mapping_limit']:'';
								// 延时获取关联记录
								$relationData   =  $model->findAll($mappingCondition,$mappingFields,$mappingOrder,$mappingLimit);
								break;
							case MANY_TO_MANY:
								if(empty($mappingCondition)) {
									$pk   =  is_array($result)?$result[$this->getPk()]:$result->{$this->getPk()};
									$mappingCondition = "{$mappingFk}={$pk}";
								}
								$mappingOrder =  $val['mapping_order'];
								$mappingLimit =  $val['mapping_limit'];
								$mappingRelationFk = $val['relation_foreign_key']?$val['relation_foreign_key']:$model->name.'_id';
								$mappingRelationTable  =  $val['relation_table']?$val['relation_table']:$this->getRelationTableName($model);
								$sql = "SELECT b.{$mappingFields} FROM {$mappingRelationTable} AS a, ".$model->getTableName()." AS b WHERE a.{$mappingRelationFk} = b.{$model->getPk()} AND a.{$mappingCondition}";
								if(!empty($mappingOrder)) {
									$sql .= ' ORDER BY '.$mappingOrder;
								}
								if(!empty($mappingLimit)) {
									$sql .= ' LIMIT '.$mappingLimit;
								}
								$relationData	=	$this->_query($sql);
								break;
						}
						if(is_array($result)) {
							$result[$mappingName] = $relationData;
						}else{
							$result->$mappingName = $relationData;
						}
					}
				}
			}
		}
		return $result;
	}

	/**
     +----------------------------------------------------------
     * 获取返回数据集的关联记录
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $result  返回数据
     * @param array $relation  关联信息
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function getRelations(&$resultSet,$relation=array()) {
		// 获取记录集的主键列表
		/*
		$pk = array();
		foreach($resultSet as $key=>$val) {
			$val	=	(array)$val;
			$pk[$key]	=	$val[$this->getPk()];
		}
		$pks	=	implode(',',array_unique($pk));*/
		foreach($resultSet as $key=>$val) {
			$val  = $this->getRelation($val,$relation);
			$resultSet[$key]	=	$val;
		}
	}

	/**
     +----------------------------------------------------------
     * 操作关联数据
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $opType  操作方式 ADD SAVE DEL
     * @param mixed $data  数据对象
     * @param array $relation 关联信息
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function opRelation($opType,$data,$relation=array())
	{
		$result	=	false;
		// 把HashMap对象转换成数组
		if(is_instance_of($data,'HashMap')){
			$data = $data->toArray();
		}elseif(is_object($data)){
			$data	 =	 get_object_vars($data);
		}elseif(!is_array($data)){
			// 数据无效返回
			return false;
		}
		if(!empty($this->_link)) {
			// 遍历关联定义
			foreach($this->_link as $val) {
				if(empty($relation['type']) || $val['mapping_type']==$relation['type']) {
					// 操作制定关联类型
					$mappingName =  $val['mapping_name']?$val['mapping_name']:$val['class_name'];	// 映射名称
					if(empty($relation['name']) || $mappingName == $relation['name']) {
						// 操作制定的关联
						$mappingType = $val['mapping_type'];	//  关联类型
						$mappingClass  = $val['class_name'];			//  关联类名
						$mappingFk   =  $val['foreign_key']?$val['foreign_key']:$this->name.'_id';		//  关联外键
						$mappingFields = $val['mapping_fields'];		// 映射字段
						//$mappingCondition = $val['condition'];			// 关联条件
						// 当前数据对象主键值
						$pk	=	$data[$this->getPk()];
						$mappingCondition = "{$mappingFk}={$pk}";
						if(strtoupper($mappingClass)==strtoupper($this->name)) {
							// 自引用关联 获取父键名
							$mappingParentKey = !empty($val['parent_key'])? $val['parent_key'] : 'parent_id';
						}
						// 获取关联model对象
						$model = D($mappingClass);
						$mappingData	=	isset($relation['data'])?$relation['data']:$data[$mappingName];
						if(is_instance_of($mappingData,'HashMap') || is_instance_of($mappingData,'ResultSet')){
							$mappingData = $mappingData->toArray();
						}elseif(is_object($mappingData)){
							$mappingData =	 get_object_vars($mappingData);
						}
						if(!empty($mappingData)) {
							switch($mappingType) {
								case HAS_ONE:
									switch (strtoupper($opType)){
										case 'ADD':	// 增加关联数据
										$mappingData[$mappingFk]	=	$pk;
										$result   =  $model->add($mappingData,false);
										break;
										case 'SAVE':	// 更新关联数据
										$result   =  $model->save($mappingData,$mappingCondition,false);
										break;
										case 'DEL':	// 根据外键删除关联数据
										$result   =  $model->delete($mappingCondition,'','',false);
										break;
									}
									break;
								case BELONGS_TO:
									break;
								case HAS_MANY:
									switch (strtoupper($opType)){
										case 'ADD'	 :	// 增加关联数据
										$model->startTrans();
										foreach ($mappingData as $val){
											$val[$mappingFk]	=	$pk;
											$result   =  $model->add($val,false);
										}
										$model->commit();
										break;
										case 'SAVE' :	// 更新关联数据
										//$mappingOrder =  $val['mapping_order'];
										//$mappingLimit =  $val['mapping_limit'];
										$model->startTrans();
										foreach ($mappingData as $vo){
											//$result   =  $model->save($vo,$mappingCondition,false,$mappingLimit,$mapppingOrder);
											$result   =  $model->save($vo,$mappingCondition,false);
										}
										$model->commit();
										break;
										case 'DEL' :	// 删除关联数据
										$result   =  $model->delete($mappingCondition,'','',false);
										break;
									}
									break;
								case MANY_TO_MANY:
									$mappingRelationFk = $val['relation_foreign_key']?$val['relation_foreign_key']:$model->name.'_id';// 关联
									$mappingRelationTable  =  $val['relation_table']?$val['relation_table']:$this->getRelationTableName($model);
									foreach ($mappingData as $vo){
										$relationId[]	=	$vo[$model->getPk()];
									}
									$relationId	=	implode(',',$relationId);
									switch (strtoupper($opType)){
										case 'ADD':	// 增加关联数据
										case 'SAVE':	// 更新关联数据
										$this->startTrans();
										// 删除关联表数据
										$this->db->remove($mappingCondition,$mappingRelationTable);
										// 插入关联表数据
										$sql  = 'INSERT INTO '.$mappingRelationTable.' ('.$mappingFk.','.$mappingRelationFk.') SELECT a.'.$this->getPk().',b.'.$model->getPk().' FROM '.$this->getTableName().' AS a ,'.$model->getTableName()." AS b where a.".$this->getPk().' ='. $pk.' AND  b.'.$model->getPk().' IN ('.$relationData.") ";
										$result	=	$model->execute($sql);
										if($result) {
											// 提交事务
											$this->commit();
										}else {
											// 事务回滚
											$this->rollback();
										}
										break;
										case 'DEL':	// 根据外键删除中间表关联数据
										$result	=	$this->db->remove($mappingCondition,$mappingRelationTable);
										break;
									}
									break;
							}
						}
					}
				}
			}
		}
		return $result;
	}

	/**
     +----------------------------------------------------------
     * 根据主键删除数据
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param integer $id 主键值
     * @param boolean $autoLink  是否关联删除
     +----------------------------------------------------------
     * @return boolen
     +----------------------------------------------------------
     */
	public function deleteById($id,$autoLink=false)
	{
		$pk	=	$this->getPk();
		return $this->_delete(array($pk=>$id),$pk."='$id'",0,'',$autoLink);
	}

	/**
     +----------------------------------------------------------
     * 根据多个主键删除数据
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param integer $ids 多个主键值
     * @param integer $limit 要删除的记录数
     * @param string $order  删除的顺序
     * @param boolean $autoLink  是否关联删除
     +----------------------------------------------------------
     * @return boolen
     +----------------------------------------------------------
     */
	public function deleteByIds($ids,$limit='',$order='',$autoLink=false)
	{
		return $this->_delete(false,$this->getPk()." IN ($ids)",$limit,$order,$autoLink);
	}

	/**
     +----------------------------------------------------------
     * 根据某个字段删除数据
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $field 字段名称
     * @param mixed $value 字段值
     * @param integer $limit 要删除的记录数
     * @param string $order  删除的顺序
     * @param boolean $autoLink  是否关联删除
     +----------------------------------------------------------
     * @return boolen
     +----------------------------------------------------------
     */
	// 根据某个字段的值删除记录
	public function deleteBy($field,$value,$limit='',$order='',$autoLink=false) {
		return $this->_delete(false,$field."='$value'",$limit,$order,$autoLink);
	}

	/**
     +----------------------------------------------------------
     * 根据条件删除表数据
     * 如果成功返回删除记录个数
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $data 删除条件
     * @param integer $limit 要删除的记录数
     * @param string $order  删除的顺序
     * @param boolean $autoLink  是否关联删除
     +----------------------------------------------------------
     * @return boolen
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function delete($data=null,$limit='',$order='',$autoLink=false)
	{
		if(preg_match('/^\d+(\,\d+)*$/',$data)) {
			// 如果是数字 直接使用deleteByIds
			return $this->deleteByIds($data,$limit,$order,$autoLink);
		}
		if(empty($data)) {
			$data	 =	 $this->data;
		}
		if(is_array($data) && isset($data[$this->getPk()])) {
			$data	=	$this->_facade($data);
			$where  = $this->getPk()."=".$data[$this->getPk()];
		}else {
			$where  =   $data;
		}
		return $this->_delete($data,$where,$limit,$order,$autoLink);
	}

	/**
     +----------------------------------------------------------
     * 根据条件删除数据
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $condition 删除条件
     * @param boolean $autoLink  是否关联删除
     +----------------------------------------------------------
     * @return boolen
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function deleteAll($condition='',$autoLink=false)
	{
		if(is_instance_of($condition,'HashMap')) {
			$condition    = $condition->toArray();
		}elseif(empty($condition) && !empty($this->dataList)){
			$id = array();
			foreach ($this->dataList as $data){
				$data = (array)$data;
				$id[]	 =	 $data[$this->getPk()];
			}
			$ids = implode(',',$id);
			$condition = $this->getPk().' IN ('.$ids.')';
		}
		return $this->_delete(false,$condition,0,'',$autoLink);
	}

	/**
     +----------------------------------------------------------
     * 清空表数据
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return boolen
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function clear()
	{
		if(false === $this->db->clear($this->getTableName())){
			$this->error =  L('_OPERATION_WRONG_');
			return false;
		}else {
			return true;
		}
	}

	/**
     +----------------------------------------------------------
     * 根据主键得到一条记录
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param int $id 主键的值
     * @param string $fields 字段名，默认为*
     * @param boolean $cache 是否缓存
     * @param mixed $relation 是否关联读取
     * @param boolean $lazy 是否惰性查询
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function getById($id,$fields='*',$cache=false,$relation=false,$lazy=false)
	{
		return $this->_read($this->getPk()."='{$id}'",$fields,false,null,null,null,null,null,$cache,$relation,$lazy);
	}

	/**
     +----------------------------------------------------------
     * 根据主键范围得到多个记录
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $ids 主键的范围 如 1,3,4,7 array(1,2,3)
     * @param string $fields 字段名，默认为*
     * @param boolean $cache 是否缓存
     * @param mixed $relation 是否关联读取
     * @param boolean $lazy 是否惰性查询
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function getByIds($ids,$fields='*',$order='',$limit='',$cache=false,$relation=false,$lazy=false)
	{
		if(is_array($ids)) {
			$ids	=	implode(',',$ids);
		}
		return $this->_read($this->getPk()." IN ({$ids})",$fields,true,$order,$limit,null,null,$cache,$relation,$lazy);
	}

	/**
     +----------------------------------------------------------
     * 根据某个字段得到一条记录
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $field 字段名称
     * @param mixed $value 字段的值
     * @param string $fields 字段名，默认为*
     * @param boolean $cache 是否缓存查询
     * @param mixed $relation 是否关联查询
     * @param boolean $lazy 是否惰性查询
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function getBy($field,$value,$fields='*',$cache=false,$relation=false,$lazy=false)
	{
		return $this->_read($field."='{$value}'",$fields,false,null,null,null,null,null,$cache,$relation,$lazy);
	}

	/**
     +----------------------------------------------------------
     * 根据某个字段获取全部记录
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $field 字段名称
     * @param mixed $value 字段的值
     * @param string $fields 字段名，默认为*
     * @param boolean $cache 是否缓存查询
     * @param mixed $relation 是否关联查询
     * @param boolean $lazy 是否惰性查询
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function getByAll($field,$value,$fields='*',$cache=false,$relation=false,$lazy=true)
	{
		return $this->_read($field."='{$value}'",$fields,true,null,null,null,null,null,$cache,$relation,$lazy);
	}

	/**
     +----------------------------------------------------------
     * 根据条件得到一条记录
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $condition 条件
     * @param string $fields 字段名，默认为*
     * @param boolean $cache 是否读取缓存
     * @param mixed $relation 是否关联查询
     * @param boolean $lazy 是否惰性查询
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function find($condition='',$fields='*',$cache=false,$relation=false,$lazy=false)
	{
		if(is_numeric($condition)) {
			// 如果是数字 直接使用getById
			return $this->getById($condition,$fields,$cache,$relation,$lazy);
		}
		return $this->_read($condition,$fields,false,null,1,null,null,null,$cache,$relation,$lazy);
	}

	/**
     +----------------------------------------------------------
     * 根据条件得到一条记录
     * 并且返回关联记录
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $condition 条件
     * @param string $fields 字段名，默认为*
     * @param boolean $cache 是否读取缓存
     * @param boolean $lazy 是否惰性查询
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function xFind($condition='',$fields='*',$cache=false,$lazy=false)
	{
		return $this->find($condition,$fields,$cache,true,$lazy);
	}

	/**
     +----------------------------------------------------------
     * 查找记录
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $condition  条件
     * @param string $fields  查询字段
     * @param string $order  排序
     * @param string $limit  
     * @param string $group  
     * @param string $having 
     * @param string $join
     * @param boolean $cache 是否读取缓存
     * @param mixed $relation 是否关联查询
     * @param boolean $lazy 是否惰性查询
     +----------------------------------------------------------
     * @return ArrayObject|ResultIterator
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function findAll($condition='',$fields='*',$order='',$limit='',$group='',$having='',$join='',$cache=false,$relation=false,$lazy=false)
	{
		if($this->staticModel) {
			return $this->dataList;
		}
		if(is_string($condition) && preg_match('/^\d+(\,\d+)+$/',$condition)) {
			return $this->getByIds($condition,$fields,$order,$limit,$cache,$relation,$lazy);
		}
		return $this->_read($condition,$fields,true,$order,$limit,$group,$having,$join,$cache,$relation,$lazy);
	}

	/**
     +----------------------------------------------------------
     * 查询记录并返回相应的关联记录
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $condition  条件
     * @param string $fields  查询字段
     * @param string $order  排序
     * @param string $limit  
     * @param string $group  
     * @param string $having 
     * @param string $join
     * @param boolean $cache 是否读取缓存
     * @param boolean $lazy 是否惰性查询
     +----------------------------------------------------------
     * @return ArrayObject|ResultIterator
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function xFindAll($condition='',$fields='*',$order='',$limit='',$group='',$having='',$join='',$cache=false)
	{
		return $this->findAll($condition,$fields,$order,$limit,$group,$having,$join,$cache,true,false);
	}

	/**
     +----------------------------------------------------------
     * 查找前N个记录
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param integer $count 记录个数 
     * @param mixed $condition  条件
     * @param string $fields  查询字段
     * @param string $order  排序
     * @param string $group  
     * @param string $having 
     * @param string $join
     * @param boolean $cache 是否读取缓存
     * @param mixed $relation 是否关联查询
     * @param boolean $lazy 是否惰性查询
     +----------------------------------------------------------
     * @return ArrayObject|ResultIterator
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function topN($count,$condition='',$fields='*',$order='',$group='',$having='',$join='',$cache=false,$relation=false,$lazy=false) {
		return $this->findAll($condition,$fields,$order,$count,$group,$having,$join,$cache,$relation,$lazy);
	}

	/**
     +----------------------------------------------------------
     * SQL查询
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $sql  SQL指令
     * @param boolean $cache  是否缓存
     * @param boolean $lazy  是否惰性查询
     +----------------------------------------------------------
     * @return ArrayObject|ResultIterator
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function query($sql,$cache=false,$lazy=false)
	{
		if(empty($sql) && !empty($this->options['sql'])) {
			$sql	=	$this->options['sql'];
		}
		if(!empty($sql)) {
			if(strpos($sql,'__TABLE__')) {
				$sql	=	str_replace('__TABLE__',$this->getTableName(),$sql);
			}
			return $this->_query($sql,$cache,$lazy);
		}else{
			return false;
		}
	}

	/**
     +----------------------------------------------------------
     * 执行SQL语句
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $sql  SQL指令
     +----------------------------------------------------------
     * @return false | integer
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function execute($sql='')
	{
		if(empty($sql) && !empty($this->options['sql'])) {
			$sql	=	$this->options['sql'];
		}
		if(!empty($sql)) {
			if(strpos($sql,'__TABLE__')) {
				$sql	=	str_replace('__TABLE__',$this->getTableName(),$sql);
			}
			$result =   $this->db->execute($sql);
			return $result;
		}else {
			return false;
		}
	}

	/**
     +----------------------------------------------------------
     * 获取一条记录的某个字段值
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $field  字段名
     * @param mixed $condition  查询条件
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function getField($field,$condition='')
	{
		if($this->viewModel) {
			$condition	=	$this->checkCondition($condition);
			$field	=	$this->checkFields($field);
		}
		$rs = $this->db->find($condition,$this->getTableName(),$field);
		return $this->getCol($rs,$field);
	}

	/**
     +----------------------------------------------------------
     * 获取数据集的个别字段值
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $field 字段名称
     * @param mixed $condition  条件
     * @param string $spea  多字段分割符号
     +----------------------------------------------------------
     * @return array
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function getFields($field,$condition='',$sepa=' ')
	{
		if($this->viewModel) {
			$condition	=	$this->checkCondition($condition);
			$field	=	$this->checkFields($field);
		}
		$rs = $this->db->find($condition,$this->getTableName(),$field);
		return $this->getCols($rs,$field,$sepa);
	}

	/**
     +----------------------------------------------------------
     * 设置记录的某个字段值
	 * 支持使用数据库字段和方法
	 * 例如 setField('score','(score+1)','id=5');
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $field  字段名
     * @param string $value  字段值
     * @param mixed $condition  条件
     +----------------------------------------------------------
     * @return boolean
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function setField($field,$value,$condition='') {
		if($this->viewModel) {
			$condition	=	$this->checkCondition($condition);
			$field	=	$this->checkFields($field);
		}
		return $this->db->setField($field,$value,$this->getTableName(),$condition);
	}

	/**
     +----------------------------------------------------------
     * 字段值增长
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $field  字段名
     * @param mixed $condition  条件
     * @param integer $step  增长值
     +----------------------------------------------------------
     * @return boolean
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function setInc($field,$condition='',$step=1) {
		if($this->viewModel) {
			$condition	=	$this->checkCondition($condition);
			$field	=	$this->checkFields($field);
		}
		return $this->db->setInc($field,$this->getTableName(),$condition,$step);
	}

	/**
     +----------------------------------------------------------
     * 字段值减少
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $field  字段名
     * @param mixed $condition  条件
     * @param integer $step  减少值
     +----------------------------------------------------------
     * @return boolean
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function setDec($field,$condition='',$step=1) {
		if($this->viewModel) {
			$condition	=	$this->checkCondition($condition);
			$field	=	$this->checkFields($field);
		}
		return $this->db->setDec($field,$this->getTableName(),$condition,$step);
	}

	/**
     +----------------------------------------------------------
     * 获取查询结果中的某个字段值
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param ArrayObject $rs  查询结果
     * @param string $field  字段名
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function getCol($rs,$field)
	{
		if(!empty($rs) && count($rs)>0) {
			$result =   $rs[0];
			$field  =   is_array($result)?$result[$field]:$result->$field;
			return $field;
		}else {
			return null;
		}
	}

	/**
     +----------------------------------------------------------
     * 获取查询结果中的多个字段值
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param ArrayObject $rs  查询结果
     * @param string $field  字段名用逗号分割多个
     * @param string $spea  多字段分割符号
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function getCols($rs,$field,$sepa=' ') {
		if(!empty($rs)) {
			$field	=	explode(',',$field);
			$cols	 =	 array();
			$length	 = count($field);
			foreach ($rs as $result){
				if(is_object($result)) $result	=	get_object_vars($result);
				if($length>1) {
					$cols[$result[$field[0]]]	=	'';
					for($i=1; $i<$length; $i++) {
						$cols[$result[$field[0]]] .= $result[$field[$i]].$sepa;
					}
				}else{
					$cols[]	 =	 $result[$field];
				}
			}
			return $cols;
		}
		return null;
	}

	/**
     +----------------------------------------------------------
     * 统计满足条件的记录个数
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $condition  条件
     * @param string $field  要统计的字段 默认为*
     +----------------------------------------------------------
     * @return integer
     +----------------------------------------------------------
     */
	public function count($condition='',$field='*')
	{
		$fields = 'count('.$field.') as count';
		if($this->viewModel) {
			$condition	=	$this->checkCondition($condition);
		}
		$rs = $this->db->find($condition,$this->getTableName(),$fields);
		return $this->getCol($rs,'count')|0;
	}

	/**
     +----------------------------------------------------------
     * 取得某个字段的最大值
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $field  字段名
     * @param mixed $condition  条件
     +----------------------------------------------------------
     * @return float
     +----------------------------------------------------------
     */
	public function max($field,$condition='')
	{
		$fields = 'MAX('.$field.') as max';
		if($this->viewModel) {
			$condition	=	$this->checkCondition($condition);
		}
		$rs = $this->db->find($condition,$this->getTableName(),$fields);
		return floatval($this->getCol($rs,'max'));
	}

	/**
     +----------------------------------------------------------
     * 取得某个字段的最小值
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $field  字段名
     * @param mixed $condition  条件
     +----------------------------------------------------------
     * @return float
     +----------------------------------------------------------
     */
	public function min($field,$condition='')
	{
		$fields = 'MIN('.$field.') as min';
		if($this->viewModel) {
			$condition	=	$this->checkCondition($condition);
		}
		$rs = $this->db->find($condition,$this->getTableName(),$fields);
		return floatval($this->getCol($rs,'min'));
	}

	/**
     +----------------------------------------------------------
     * 统计某个字段的总和
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $field  字段名
     * @param mixed $condition  条件
     +----------------------------------------------------------
     * @return float
     +----------------------------------------------------------
     */
	public function sum($field,$condition='')
	{
		$fields = 'SUM('.$field.') as sum';
		if($this->viewModel) {
			$condition	=	$this->checkCondition($condition);
		}
		$rs = $this->db->find($condition,$this->getTableName(),$fields);
		return floatval($this->getCol($rs,'sum'));
	}

	/**
     +----------------------------------------------------------
     * 统计某个字段的平均值
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $field  字段名
     * @param mixed $condition  条件
     +----------------------------------------------------------
     * @return float
     +----------------------------------------------------------
     */
	public function avg($field,$condition='')
	{
		$fields = 'AVG('.$field.') as avg';
		if($this->viewModel) {
			$condition	=	$this->checkCondition($condition);
		}
		$rs = $this->db->find($condition,$this->getTableName(),$fields);
		return floatval($this->getCol($rs,'avg'));
	}

	/**
     +----------------------------------------------------------
     * 查询符合条件的第N条记录
     * 0 表示第一条记录 -1 表示最后一条记录
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param integer $position 记录位置
     * @param mixed $condition 条件
     * @param string $order 排序
     * @param string $fields 字段名，默认为*
     * @param boolean $relation 是否读取关联
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     */
	public function getN($position=0,$condition='',$order='',$fields='*',$relation=false)
	{
		$table		=	$this->getTableName();
		if(!empty($this->options)) {
			// 已经有定义的查询表达式
			$condition	=	$this->options['where']?			$this->options['where']:	$condition;
			$table			=	$this->options['table']?			$this->options['table']:	$this->getTableName();
			$fields		=	$this->options['filed']?			$this->options['field']:	$fields;
			$limit			=	$this->options['limit']?			$this->options['limit']:		$limit;
			$order		=	$this->options['order']?			$this->options['order']:	$order;
			$relation		=	isset($this->options['link'])?		$this->options['link']:		$relation;
			$this->options	=	array();
		}
		if($this->viewModel) {
			$condition	=	$this->checkCondition($condition);
			$field	=	$this->checkFields($field);
		}
		if($position>=0) {
			$rs = $this->db->find($condition,$table,$fields,$order,$position.',1');
			return $this->rsToVo($rs,false,0,$relation);
		}else{
			$rs = $this->db->find($condition,$this->getTableName(),$fields,$order);
			return $this->rsToVo($rs,false,$position,$relation);
		}
	}

	/**
     +----------------------------------------------------------
     * 获取满足条件的第一条记录
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $condition 条件
     * @param string $fields 字段名，默认为*
     * @param string $order 排序
     * @param boolean $relation 是否读取关联
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     */
	public function first($condition='',$order='',$fields='*',$relation=false) {
		return $this->getN(0,$condition,$order,$fields,$relation);
	}

	/**
     +----------------------------------------------------------
     * 获取满足条件的第后一条记录
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $condition 条件
     * @param string $fields 字段名，默认为*
     * @param string $order 排序
     * @param boolean $relation 是否读取关联
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     */
	public function last($condition='',$order='',$fields='*',$relation=false) {
		return $this->getN(-1,$condition,$order,$fields,$relation);
	}

	/**
     +----------------------------------------------------------
     * 记录乐观锁
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $data 数据对象
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	protected function cacheLockVersion($data) {
		if($this->optimLock) {
			if(is_object($data))	$data	=	get_object_vars($data);
			if(isset($data[$this->optimLock]) && isset($data[$this->getPk()])) {
				// 只有当存在乐观锁字段和主键有值的时候才记录乐观锁
				$_SESSION[$this->name.'_'.$data[$this->getPk()].'_lock_version']	=	$data[$this->optimLock];
			}
		}
	}

	/**
     +----------------------------------------------------------
     * 把查询结果转换为数据（集）对象
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $resultSet 查询结果记录集
     * @param Boolean $returnList 是否返回记录集
     * @param Integer $position 定位的记录集位置
     * @param boolean $relation 是否获取关联
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function rsToVo($resultSet,$returnList=false,$position=0,$relation='')
	{
		if($resultSet ) {
			if(!$returnList) {
				if(is_instance_of($resultSet,'ResultIterator')) {
					// 如果是延时查询返回的是ResultIterator对象
					$resultSet	=	$resultSet->getIterator();
				}
				// 返回数据对象
				if($position<0) {
					// 逆序查找
					$position = count($resultSet)-abs($position);
				}
				if(count($resultSet)<= $position) {
					// 记录集位置不存在
					$this->error = L('_SELECT_NOT_EXIST_');
					return false;
				}
				$result  =  $resultSet[$position];
				// 取出数据对象的时候记录乐观锁
				$this->cacheLockVersion($result);
				// 获取Blob数据
				$this->getBlobFields($result);
				// 获取关联记录
				if( $this->autoReadRelations || $relation ) {
					$result  =  $this->getRelation($result,$relation);
				}
				// 对数据对象自动编码转换
				$result	 =	 auto_charset($result,C('DB_CHARSET'),C('TEMPLATE_CHARSET'));
				// 记录当前数据对象
				$this->data	 =	 (array)$result;
				return $result;
			}else{
				if(is_instance_of($resultSet,'ResultIterator')) {
					// 如果是延时查询返回的是ResultIterator对象
					return $resultSet;
				}
				// 获取Blob数据
				$this->getListBlobFields($resultSet);

				// 返回数据集对象
				if( $this->autoReadRelations || $relation ) {
					// 获取数据集的关联记录
					$this->getRelations($resultSet,$relation);
				}
				// 对数据集对象自动编码转换
				$resultSet	=	auto_charset($resultSet,C('DB_CHARSET'),C('TEMPLATE_CHARSET'));
				// 记录数据列表
				$this->dataList	=	$resultSet;
				return $resultSet;
			}
		}else {
			return false;
		}
	}

	/**
     +----------------------------------------------------------
     * 创建数据对象 但不保存到数据库
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $data 创建数据
     * @param string $type 创建类型
     * @param boolean $batch 批量创建
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function create($data='',$batch=false)
	{
		if(true === $batch) {
			// 批量创建
			return $this->createAll($data);
		}
		// 如果没有传值默认取POST数据
		if(empty($data)) {
			$data	 =	 $_POST;
		}
		elseif(is_instance_of($data,'HashMap')){
			$data = $data->toArray();
		}
		elseif(is_instance_of($data,'Model')){
			$data = $data->getIterator();
		}
		elseif(is_object($data)){
			$data	=	get_object_vars($data);
		}
		elseif(!is_array($data)){
			$this->error = L('_DATA_TYPE_INVALID_');
			return false;
		}
		$vo	=	$this->_createData($data);
		return $vo;
	}

	/**
     +----------------------------------------------------------
     * 创建数据列表对象 但不保存到数据库
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $dataList 数据列表
     * @param string $type 创建类型
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function createAll($dataList='')
	{
		// 如果没有传值默认取POST数据
		if(empty($dataList)) {
			$dataList	 =	 $_POST;
		}
		elseif(!is_array($dataList)){
			$this->error = L('_DATA_TYPE_INVALID_');
			return false;
		}
		foreach ($dataList as $data){
			$vo	=	$this->_createData($data);
			if(false === $vo) {
				return false;
			}else{
				$this->dataList[] = $vo;
			}
		}
		return $this->dataList;
	}

	/**
     +----------------------------------------------------------
     * 创建数据对象 但不保存到数据库
     +----------------------------------------------------------
     * @access private 
     +----------------------------------------------------------
     * @param mixed $data 创建数据
     * @param string $type 创建类型
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	private function _createData($data) {
		// 2008-2-11 自动判断新增和编辑数据
		$vo = array();
		$type	 =	 'add';
		if(!$this->composite && isset($data[$this->getPk()])) {
			// 获取数据库的对象
			$value   = $data[$this->getPk()];
			$rs		= $this->db->find($this->getPk()."='{$value}'",$this->getTableName());
			if($rs && count($rs)>0) {
				$type	 =	 'edit';
				$vo = $rs[0];
				if(DATA_TYPE_OBJ == C('DATA_RESULT_TYPE')) {
					// 对象模式
					$vo	=	get_object_vars($vo);
				}
			}
		}
		// 对提交数据执行自动验证
		if(!$this->_before_validation($data,$type)) {
			return false;
		}
		if(!$this->autoValidation($data,$type)) {
			return false;
		}
		if(!$this->_after_validation($data,$type)) {
			return false;
		}

		if($this->composite) {
			// 复合对象直接赋值
			foreach ($data as $key=>$val){
				$vo[$key]	=	MAGIC_QUOTES_GPC?	 stripslashes($val)	 :	$val;
			}
		}else{
			// 检查字段映射
			if(isset($this->_map)) {
				foreach ($this->_map as $key=>$val){
					if(isset($data[$key])) {
						$data[$val]	=	$data[$key];
						unset($data[$key]);
					}
				}
			}
			// 验证完成生成数据对象
			foreach ( $this->fields as $key=>$name){
				if(substr($key,0,1)=='_') continue;
				$val = isset($data[$name])?$data[$name]:null;
				//保证赋值有效
				if(!is_null($val) ){
					// 首先保证表单赋值
					$vo[$name] = MAGIC_QUOTES_GPC?	 stripslashes($val)	 :	$val;
				}elseif(	(strtolower($type) == "add" && in_array($name,$this->autoCreateTimestamps,true)) ||
				(strtolower($type) == "edit" && in_array($name,$this->autoUpdateTimestamps,true)) ){
					// 自动保存时间戳
					if(!empty($this->autoTimeFormat)) {
						// 用指定日期格式记录时间戳
						$vo[$name] =	date($this->autoTimeFormat);
					}else{
						// 默认记录时间戳
						$vo[$name] = time();
					}
				}
			}
		}

		// 执行自动处理
		$this->_before_operation($vo);
		$this->autoOperation($vo,$type);
		$this->_after_operation($vo);

		// 赋值当前数据对象
		$this->data	=	$vo;

		if(DATA_TYPE_OBJ == C('DATA_RESULT_TYPE')) {
			// 对象模式 强制转换为stdClass对象实例
			$vo	=	(object) $vo;
		}
		return $vo;
	}

	/**
     +----------------------------------------------------------
     * 自动表单处理
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param array $data 创建数据
     * @param string $type 创建类型
     +----------------------------------------------------------
     * @return mixed
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	private function autoOperation(&$data,$type) {
		// 自动填充
		if(!empty($this->_auto)) {
			foreach ($this->_auto as $auto){
				// 填充因子定义格式
				// array('field','填充内容','填充条件','附加规则')
				if($this->composite || in_array($auto[0],$this->fields,true)) {
					if(empty($auto[2])) $auto[2] = 'ADD';// 默认为新增的时候自动填充
					else $auto[2]	=	strtoupper($auto[2]);
					if( (strtolower($type) == "add"  && $auto[2] == 'ADD') || 	(strtolower($type) == "edit"  && $auto[2] == 'UPDATE') || $auto[2] == 'ALL')
					{
						switch($auto[3]) {
							case 'function':	//	使用函数进行填充 字段的值作为参数
							if(function_exists($auto[1])) {
								// 如果定义为函数则调用
								$data[$auto[0]] = $auto[1]($data[$auto[0]]);
							}
							break;
							case 'field':	 // 用其它字段的值进行填充
							$data[$auto[0]] = $data[$auto[1]];
							break;
							case 'callback': // 使用回调方法
							$data[$auto[0]]	 =	 $this->{$auto[1]}($data[$auto[0]]);
							break;
							case 'string':
							default: // 默认作为字符串填充
							$data[$auto[0]] = $auto[1];
						}
						if(false === $data[$auto[0]] ) {
							unset($data[$auto[0]]);
						}
					}
				}
			}
		}
		return $data;
	}

	/**
     +----------------------------------------------------------
     * 自动表单验证
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param array $data 创建数据
     * @param string $type 创建类型
     +----------------------------------------------------------
     * @return boolean
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	private function autoValidation($data,$type) {
		// 属性验证
		if(!empty($this->_validate)) {
			// 如果设置了Vo验证
			// 则进行数据验证
			import("ORG.Text.Validation");
			foreach($this->_validate as $key=>$val) {
				// 验证因子定义格式
				// array(field,rule,message,condition,append,when)
				// field rule message 必须
				// condition 验证条件：0 存在字段就验证 1 必须验证 2 值不为空的时候验证 默认为0
				// append 附加规则 :function confirm regex equal in unique 默认为regex
				// when 验证时间: all add edit 默认为all
				// 判断是否需要执行验证
				if(empty($val[5]) || $val[5]=='all' || strtolower($val[5])==strtolower($type) ) {
					// 判断验证条件
					switch($val[3]) {
						case MUST_TO_VALIDATE:	 // 必须验证 不管表单是否有设置该字段
							if(!$this->_validationField($data,$val)){
								$this->error	=	$val[2];
								return false;
							}
							break;
						case VALUE_TO_VAILIDATE:	// 值不为空的时候才验证
							if('' != trim($data[$val[0]])){
								if(!$this->_validationField($data,$val)){
									$this->error	=	$val[2];
									return false;
								}
							}
							break;
						default:	// 默认表单存在该字段就验证
							if(isset($data[$val[0]])){
								if(!$this->_validationField($data,$val)){
									$this->error	=	$val[2];
									return false;
								}
							}
					}
				}
			}
		}
		// TODO 数据类型验证
		//  判断数据类型是否符合
		return true;
	}

	/**
     +----------------------------------------------------------
     * 根据验证因子验证字段
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param array $data 创建数据
     * @param string $val 验证规则
     +----------------------------------------------------------
     * @return boolean
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	private function _validationField($data,$val) {
		// 检查附加规则
		switch($val[4]) {
			case 'function':// 使用函数进行验证
				if(function_exists($val[1]) && !$val[1]($data[$val[0]])) {
					return false;
				}
				break;
			case 'callback':// 调用方法进行验证
				if(!$this->{$val[1]}($data[$val[0]])) {
					return false;
				}
				break;
			case 'confirm': // 验证两个字段是否相同
				if($data[$val[0]] != $data[$val[1]] ) {
					return false;
				}
				break;
			case 'in': // 验证是否在某个数组范围之内
				if(!in_array($data[$val[0]] ,$data[$val[1]]) ) {
					return false;
				}
				break;
			case 'equal': // 验证是否等于某个值
				if($data[$val[0]] != $val[1]) {
					return false;
				}
				break;
			case 'unique': // 验证某个值是否唯一
				if($this->getBy($val[0],$data[$val[0]])) {
					return false;
				}
				break;
			case 'regex':
				default:	// 默认使用正则验证 可以使用验证类中定义的验证名称
				if( !Validation::check($data[$val[0]],$val[1])) {
					return false;
				}
		}
		return true;
	}

	// 表单验证回调方法
	protected function _before_validation(&$data,$type) {return true;}
	protected function _after_validation(&$data,$type) {return true;}

	// 表单处理回调方法
	protected function _before_operation(&$data) {}
	protected function _after_operation(&$data) {}

	/**
     +----------------------------------------------------------
     * 得到当前的数据对象名称
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     */
	public function getModelName()
	{
		if(empty($this->name)) {
			$prefix	=	C('MODEL_CLASS_PREFIX');
			$suffix	=	C('MODEL_CLASS_SUFFIX');
			if(strlen($suffix)>0) {
				$this->name	=	substr(substr(get_class($this),strlen($prefix)),0,-strlen($suffix));
			}else{
				$this->name	=	substr(get_class($this),strlen($prefix));
			}
		}
		return $this->name;
	}

	/**
     +----------------------------------------------------------
     * 得到完整的数据表名
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     */
	public function getTableName()
	{
		if(empty($this->trueTableName)) {
			if($this->viewModel) {
				$tableName = '';
				foreach ($this->viewFields as $key=>$view){
					$Model	=	D($key);
					if($Model) {
						$tableName .= $Model->getTableName().' '.$key;
					}else{
						$viewTable  = !empty($this->tablePrefix) ? $this->tablePrefix : '';
						$viewTable .= $key;
						$viewTable .= !empty($this->tableSuffix) ? $this->tableSuffix : '';
						$tableName .= strtolower($viewTable).' '.$key;
					}
					$tableName	 = '('.$tableName.') JOIN ';
				}
				$tableName = substr($tableName,0,-6);
				$this->trueTableName    =   $tableName;
			}else{
				$tableName  = !empty($this->tablePrefix) ? $this->tablePrefix : '';
				$tableName .= $this->tableName?$this->tableName:$this->name;
				$tableName .= !empty($this->tableSuffix) ? $this->tableSuffix : '';
				$this->trueTableName    =   strtolower($tableName);
			}
		}
		return $this->trueTableName;
	}

	/**
     +----------------------------------------------------------
     * 得到关联的数据表名
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $relation 关联对象
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     */
	public function getRelationTableName($relation)
	{
		$relationTable  = !empty($this->tablePrefix) ? $this->tablePrefix : '';
		$relationTable .= $this->tableName?$this->tableName:$this->name;
		$relationTable .= '_'.$relation->getModelName();
		$relationTable .= !empty($this->tableSuffix) ? $this->tableSuffix : '';
		return strtolower($relationTable);
	}

	/**
     +----------------------------------------------------------
     * 开启惰性查询
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function startLazy()
	{
		$this->lazyQuery = true;
		return ;
	}

	/**
     +----------------------------------------------------------
     * 关闭惰性查询
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function stopLazy()
	{
		$this->lazyQuery = false;
		return ;
	}

	/**
     +----------------------------------------------------------
     * 开启锁机制
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function startLock()
	{
		$this->pessimisticLock = true;
		return ;
	}

	/**
     +----------------------------------------------------------
     * 关闭锁机制
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function stopLock()
	{
		$this->pessimisticLock = false;
		return ;
	}

	/**
     +----------------------------------------------------------
     * 启动事务
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function startTrans()
	{
		$this->commit();
		$this->db->startTrans();
		return ;
	}

	/**
     +----------------------------------------------------------
     * 提交事务
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return boolean
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function commit()
	{
		return $this->db->commit();
	}

	/**
     +----------------------------------------------------------
     * 事务回滚
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return boolean
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	public function rollback()
	{
		return $this->db->rollback();
	}

	/**
     +----------------------------------------------------------
     * 得到主键名称
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     */
	public function getPk() {
		return $this->fields['_pk']?$this->fields['_pk']:'id';
	}

	/**
     +----------------------------------------------------------
     * 返回当前错误信息
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     */
	public function getError(){
		return $this->error;
	}

	/**
     +----------------------------------------------------------
     * 返回数据库字段信息
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     */
	public function getDbFields(){
		return $this->fields;
	}

	/**
     +----------------------------------------------------------
     * 返回最后插入的ID
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     */
	public function getLastInsID() {
		return $this->db->lastInsID;
	}

	/**
     +----------------------------------------------------------
     * 返回最后执行的sql语句
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return string
     +----------------------------------------------------------
     */
	public function getLastSql() {
		return $this->db->getLastSql();
	}

	/**
     +----------------------------------------------------------
     * 增加数据库连接
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $config 数据库连接信息
	 * @param mixed $linkNum  创建的连接序号
     +----------------------------------------------------------
     * @return boolean
     +----------------------------------------------------------
     */
	public function addConnect($config,$linkNum) {
		if(isset($this->_db[$linkNum])) {
			return false;
		}
		// 连接创建一个新的实例
		$this->_db[$linkNum]			=	 Db::getInstance($config);
		return true;
	}

	/**
     +----------------------------------------------------------
     * 删除数据库连接
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
	 * @param integer $linkNum  创建的连接序号
     +----------------------------------------------------------
     * @return boolean
     +----------------------------------------------------------
     */
	public function delConnect($linkNum) {
		if(isset($this->_db[$linkNum])) {
			unset($this->_db[$linkNum]);
			return true;
		}
		return false;
	}

    /**
     +----------------------------------------------------------
     * 切换数据库连接
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
	 * @param integer $linkNum  创建的连接序号
     +----------------------------------------------------------
     * @return boolean
     +----------------------------------------------------------
     */
	public function switchConnect($linkNum) {
		if(isset($this->_db[$linkNum])) {
			// 在不同实例直接切换
			$this->db	=	$this->_db[$linkNum];
			return true;
		}else{
			return false;
		}
	}

	/**
     +----------------------------------------------------------
     * 查询SQL组装 where
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $where 
     +----------------------------------------------------------
     * @return Model
     +----------------------------------------------------------
     */
	public function where($where) {
		$this->options['where']	=	$where;
		return $this;
	}

	/**
     +----------------------------------------------------------
     * 查询SQL组装 order
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $order 
     +----------------------------------------------------------
     * @return Model
     +----------------------------------------------------------
     */
	public function order($order) {
		$this->options['order']	=	$order;
		return $this;
	}

	/**
     +----------------------------------------------------------
     * 查询SQL组装 table
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $table 
     +----------------------------------------------------------
     * @return Model
     +----------------------------------------------------------
     */
	public function table($table) {
		$this->options['table']	=	$table;
		return $this;
	}

	/**
     +----------------------------------------------------------
     * 查询SQL组装 group
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $group 
     +----------------------------------------------------------
     * @return Model
     +----------------------------------------------------------
     */
	public function group($group) {
		$this->options['group']	=	$group;
		return $this;
	}

	/**
     +----------------------------------------------------------
     * 查询SQL组装 field
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $field 
     +----------------------------------------------------------
     * @return Model
     +----------------------------------------------------------
     */
	public function field($field) {
		$this->options['field']	=	$field;
		return $this;
	}

	/**
     +----------------------------------------------------------
     * 查询SQL组装 limit
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param array $limit 
     +----------------------------------------------------------
     * @return Model
     +----------------------------------------------------------
     */
	public function limit($limit) {
		$this->options['limit']	=	$limit;
		return $this;
	}

	/**
     +----------------------------------------------------------
     * 查询SQL组装 join
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param array $join 
     +----------------------------------------------------------
     * @return Model
     +----------------------------------------------------------
     */
	public function join($join) {
		$this->options['join']	=	$join;
		return $this;
	}

	/**
     +----------------------------------------------------------
     * 查询SQL组装 having
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $having 
     +----------------------------------------------------------
     * @return Model
     +----------------------------------------------------------
     */
	public function having($having) {
		$this->options['having']	=	$having;
		return $this;
	}

	/**
     +----------------------------------------------------------
     * 查询SQL组装 惰性
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param boolean $lazy 惰性查询
     +----------------------------------------------------------
     * @return Model
     +----------------------------------------------------------
     */
	public function lazy($lazy) {
		$this->options['lazy']	=	$lazy;
		return $this;
	}

	/**
     +----------------------------------------------------------
     * 查询SQL组装lock
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param boolean $lock 是否锁定
     +----------------------------------------------------------
     * @return Model
     +----------------------------------------------------------
     */
	public function lock($lock) {
		$this->options['lock']	=	$lock;
		return $this;
	}

	/**
     +----------------------------------------------------------
     * 查询SQL组装lock
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param boolean $lock 是否锁定
     +----------------------------------------------------------
     * @return Model
     +----------------------------------------------------------
     */
	public function cache($cache) {
		$this->options['cache']	=	$cache;
		return $this;
	}

	/**
     +----------------------------------------------------------
     * 查询SQL组装
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $sql sql语句
     +----------------------------------------------------------
     * @return Model
     +----------------------------------------------------------
     */
	public function sql($sql) {
		$this->options['sql']	=	$sql;
		return $this;
	}
	
	/**
     +----------------------------------------------------------
     * 数据SQL组装
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $data 要插入或者保存的数据
     +----------------------------------------------------------
     * @return Model
     +----------------------------------------------------------
     */
	public function data($data) {
		$this->options['data']	=	$data;
		return $this;
	}
};
?><?php 
// +----------------------------------------------------------------------
// | ThinkPHP                                                             
// +----------------------------------------------------------------------
// | Copyright (c) 2008 http://thinkphp.cn All rights reserved.      
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>                                  
// +----------------------------------------------------------------------
// $Id$

/**
 +------------------------------------------------------------------------------
 * ThinkPHP 视图输出
 * 支持缓存和页面压缩
 +------------------------------------------------------------------------------
 * @category   Think
 * @package  Think
 * @subpackage  Core
 * @author liu21st <liu21st@gmail.com>
 * @version  $Id$
 +------------------------------------------------------------------------------
 */
class View extends Base
{
    /**
     +----------------------------------------------------------
     * 模板页面显示变量，未经定义的变量不会显示在页面中
     +----------------------------------------------------------
     * @var array
     * @access protected
     +----------------------------------------------------------
     */
    protected $tVar        =  array();

	protected $trace		  = array();

	// 使用的模板引擎类型
	protected $type	=	'';

   /**
     +----------------------------------------------------------
     * 取得模板对象实例
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @return Template
     +----------------------------------------------------------
     */
    static function getInstance() {
        return get_instance_of(__CLASS__);
    }

	// 构造函数
	public function __construct($type='') {
		if(!empty($type)) {
			$this->type	=	$type;
		}else{
			$this->type	=	strtoupper(C('TMPL_ENGINE_TYPE'));
		}
	}

    /**
     +----------------------------------------------------------
     * 模板变量赋值
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $name 
     * @param mixed $value  
     +----------------------------------------------------------
     */
    public function assign($name,$value=''){
        if(is_array($name)) {
        	$this->tVar   =  array_merge($this->tVar,$name);
        }else {
   	        $this->tVar[$name] = $value;
        }
    }

    /**
     +----------------------------------------------------------
     * Trace变量赋值
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param mixed $name 
     * @param mixed $value  
     +----------------------------------------------------------
     */
	public function trace($title,$value='') {
        if(is_array($title)) {
        	$this->trace   =  array_merge($this->trace,$title);
        }else {
   	        $this->trace[$title] = $value;
        }
	}

    /**
     +----------------------------------------------------------
     * 取得模板变量的值
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $name 
     +----------------------------------------------------------
     * @return mixed 
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
    public function get($name){
        if(isset($this->tVar[$name])) {
            return $this->tVar[$name];
        }else {
        	return false;
        }
    }

	private function __set($name,$value) {
		$this->assign($name,$value);
	}

	private function __get($name) {
		return $this->get($name);
	}

    /**
     +----------------------------------------------------------
     * 加载模板和页面输出 可以返回输出内容
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $templateFile 模板文件名 留空为自动获取
     * @param string $charset 模板输出字符集
     * @param string $contentType 输出类型
     * @param string $varPrefix 模板变量前缀  
     +----------------------------------------------------------
     * @return mixed 
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
    public function display($templateFile='',$charset='',$contentType='text/html',$varPrefix='')
    {
        $this->fetch($templateFile,$charset,$contentType,$varPrefix,true);
    }

    /**
     +----------------------------------------------------------
     * 显示运行时间、数据库操作、缓存次数、内存使用信息
     +----------------------------------------------------------
     * @access protected 
     +----------------------------------------------------------
     * @param string $startTime 开始时间
     +----------------------------------------------------------
     * @return string 
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
	protected function showTime($startTime) {
		if(C('SHOW_RUN_TIME')) {
			// 显示运行时间
			$endTime = microtime(TRUE);
			$total_run_time	=	number_format(($endTime - $GLOBALS['_beginTime']), 3);
			$showTime	=	'Process: '.$total_run_time.'s ';
			if(C('SHOW_ADV_TIME')) {
				// 显示详细运行时间
				$_load_time	=	number_format(($GLOBALS['_loadTime'] -$GLOBALS['_beginTime'] ), 3);
				$_init_time	=	number_format(($GLOBALS['_initTime'] -$GLOBALS['_loadTime'] ), 3);
				$_exec_time	=	number_format(($startTime  -$GLOBALS['_initTime'] ), 3);
				$_parse_time	=	number_format(($endTime - $startTime), 3);
				$showTime .= '( Load:'.$_load_time.'s Init:'.$_init_time.'s Exec:'.$_exec_time.'s Template:'.$_parse_time.'s )';
			}
			if(C('SHOW_DB_TIMES') && class_exists('Db',false) ) {
				// 显示数据库操作次数
				$db	=	Db::getInstance();
				$showTime .= ' | DB :'.$db->Q().' queries '.$db->W().' writes ';
			}
			if(C('SHOW_CACHE_TIMES') && class_exists('Cache',false)) {
				// 显示数据库操作次数
				$cache	=	Cache::getInstance();
				$showTime .= ' | Cache :'.$cache->Q().' gets '.$cache->W().' writes ';
			}
			if(MEMORY_LIMIT_ON && C('SHOW_USE_MEM')) {
				// 显示内存开销
				$startMem    =  array_sum(explode(' ', $GLOBALS['_startUseMems']));
				$endMem     =  array_sum(explode(' ', memory_get_usage()));
				$showTime .= ' | UseMem:'. number_format(($endMem - $startMem)/1024).' kb';
			}
			return $showTime;
		}
	}

    /**
     +----------------------------------------------------------
     * 输出布局模板
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $layout 指定要输出的布局模板
     * @param string $charset 输出编码
     * @param string $contentType 输出类型
     * @param string $varPrefix 模板变量前缀
     * @param string $display 是否直接显示
     +----------------------------------------------------------
     * @return void
     +----------------------------------------------------------
     */
	public function layout($layoutFile,$charset='',$contentType='text/html',$varPrefix='',$display=true) 
	{
		$startTime = microtime(TRUE);
		// 获取布局模板文件
		$content	=	$this->fetch('layout:'.$layoutFile,$charset,$contentType,$varPrefix,true);
		// 查找布局包含的页面
		$find = preg_match_all('/<!-- layout::(.+?)::(.+?) -->/is',$content,$matches);
		if($find) {
			for ($i=0; $i< $find; $i++) {
				// 读取相关的页面模板替换布局单元
				$content	=	str_replace($matches[0][$i],$this->fetch($matches[1][$i],$charset,$contentType,$varPrefix),$content);
			}
		}
		if($display) {
			$showTime	=	$this->showTime($startTime);
			echo $content;
			if(C('SHOW_RUN_TIME')) {
				echo '<div  id="think_run_time" class="think_run_time">'.$showTime.'</div>';
			}
		}else{
			return $content;
		}
		return ;
	}

    /**
     +----------------------------------------------------------
     * 检查缓存文件是否有效
     * 如果无效则需要重新编译
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $tmplTemplateFile  模板文件名
     +----------------------------------------------------------
     * @return boolen
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
    protected function checkCache($tmplTemplateFile)
    {
        $tmplCacheFile = CACHE_PATH.md5($tmplTemplateFile).C('CACHFILE_SUFFIX');
        if(!file_exists($tmplCacheFile)){
            return false;
        }
        elseif (!C('TMPL_CACHE_ON')){
            return false;
        }elseif (filemtime($tmplTemplateFile) > filemtime($tmplCacheFile)) { 
            // 模板文件如果有更新则缓存需要更新
            return false; 
        } elseif (C('TMPL_CACHE_TIME') != -1 && time() > filemtime($tmplCacheFile)+C('TMPL_CACHE_TIME')) { 
            // 缓存是否在有效期
            return false; 
        }
        //缓存有效
        return true;
    }

    /**
     +----------------------------------------------------------
     * 加载模板和页面输出
     +----------------------------------------------------------
     * @access public 
     +----------------------------------------------------------
     * @param string $templateFile 模板文件名 留空为自动获取
     * @param string $charset 模板输出字符集
     * @param string $contentType 输出类型
     * @param string $varPrefix 模板变量前缀      
     * @param integer $mode 0 返回 1 输出 2 下载 
     +----------------------------------------------------------
     * @throws ThinkExecption
     +----------------------------------------------------------
     */
    public function fetch($templateFile='',$charset='',$contentType='text/html',$varPrefix='',$display=false) 
    {
		$startTime = microtime(TRUE);
        if(null===$templateFile) {
            // 使用null参数作为模版名直接返回不做任何输出
        	return ;
        }
		if('layout::'==substr($templateFile,0,8)) {
			$this->layout(substr($templateFile,8));
			return ;
		}
		if(empty($charset)) {
			$charset = C('OUTPUT_CHARSET');
		}
        // 网页字符编码
        header("Content-Type:".$contentType."; charset=".$charset);
        header("Cache-control: private");  //支持页面回跳

        // 设置输出缓存
        ini_set('output_buffering',4096);
		$zlibCompress   =  ini_get('zlib.output_compression');
		if(empty($zlibCompress) && function_exists('ini_set')) {
			ini_set( 'zlib.output_compression', 1 );
		} 
        // 缓存初始化过滤
        apply_filter('ob_init');
        //页面缓存
       	ob_start(); 
        ob_implicit_flush(0); 
        // 缓存开启后执行的过滤
        apply_filter('ob_start');

        // 模版文件名过滤
        $templateFile = apply_filter('template_file',$templateFile);

        if(''==$templateFile) {
			// 如果模板文件名为空 按照默认规则定位
            $templateFile = C('TMPL_FILE_NAME');
        }elseif(strpos($templateFile,'@')){
			// 引入其它主题的操作模板 必须带上模块名称 例如 blue@User:add
			$templateFile	=	TMPL_PATH.'/'.str_replace(array('@',':'),'/',$templateFile).C('TEMPLATE_SUFFIX');
		}elseif(strpos($templateFile,':')){
			// 引入其它模块的操作模板
			$templateFile	=	TEMPLATE_PATH.'/'.str_replace(':','/',$templateFile).C('TEMPLATE_SUFFIX');
		}elseif(!file_exists($templateFile))	{
			// 引入当前模块的其它操作模板
			$templateFile =  dirname(C('TMPL_FILE_NAME')).'/'.$templateFile.C('TEMPLATE_SUFFIX');
		}

        if(!file_exists($templateFile)){
            throw_exception(L('_TEMPLATE_NOT_EXIST_'));        
        }
        // 模版变量过滤
        $this->tVar = apply_filter('template_var',$this->tVar);

        //根据不同模版引擎进行处理
        if('PHP'==$this->type || empty($this->type)) {
        	// 默认使用PHP模版
            include $templateFile;
        }elseif('THINK'==$this->type){
			// 使用内置的ThinkTemplate模板引擎
			if(!$this->checkCache($templateFile)) {
				// 缓存无效 重新编译
				$compiler	=	true;
				import('Think.Template.ThinkTemplate');
				$tpl = ThinkTemplate::getInstance();
				// 编译并加载模板文件
				$tpl->load($templateFile,$charset,$this->tVar,$varPrefix); 
			}else{
				// 缓存有效 直接载入模板缓存
				// 模板阵列变量分解成为独立变量
				extract($this->tVar, empty($varPrefix)? EXTR_OVERWRITE : EXTR_PREFIX_ALL,$varPrefix); 
				//载入模版缓存文件
				include CACHE_PATH.md5($templateFile).C('CACHFILE_SUFFIX');
			}
		}else {
            // 通过插件的方式扩展第三方模板引擎
            use_compiler(C('TMPL_ENGINE_TYPE'),$templateFile,$this->tVar,$charset,$varPrefix);
        }
        // 获取并清空缓存
        $content = ob_get_clean();
        // 输出编码转换
        $content = auto_charset($content,C('TEMPLATE_CHARSET'),$charset);
        // 输出过滤
        $content = apply_filter('ob_content',$content);

		if(C('HTML_CACHE_ON')) {
			// 写入静态文件
			HtmlCache::writeHTMLCache($content);
		}

        if($display) {
			$showTime	=	$this->showTime($startTime);
			echo $content; 
			if(C('SHOW_RUN_TIME')) {
				echo '<div  id="think_run_time" class="think_run_time">'.$showTime.'</div>';
			}
			if(C('SHOW_PAGE_TRACE')) {
				// 显示页面Trace信息 读取Trace定义文件
				// 定义格式 return array('当前页面'=>$_SERVER['PHP_SELF'],'通信协议'=>$_SERVER['SERVER_PROTOCOL'],...);
				$traceFile	=	CONFIG_PATH.'trace.php';
				 if(file_exists($traceFile)) {
					$_trace	=	include $traceFile;
				 }else{
					$_trace	=	array();
				 }
				 // 系统默认显示信息
				$this->trace('当前页面',	$_SERVER['PHP_SELF']);
				$this->trace('请求方法',	$_SERVER['REQUEST_METHOD']);
				$this->trace('通信协议',	$_SERVER['SERVER_PROTOCOL']);
				$this->trace('请求时间',	date('Y-m-d H:i:s',$_SERVER['REQUEST_TIME']));
				$this->trace('用户代理',	$_SERVER['HTTP_USER_AGENT']);
				$this->trace('会话ID'	,	session_id());
				$this->trace('运行数据',	$showTime);
				$this->trace('输出编码',	$charset);
				$this->trace('加载类库',	$GLOBALS['include_file']);
				$this->trace('模板编译',	!empty($compiler)?'重新编译':'读取缓存');
				if(isset(Log::$log[SQL_LOG_DEBUG])) {
					$log	=	Log::$log[SQL_LOG_DEBUG];
					$this->trace('SQL记录',is_array($log)?count($log).'条SQL<br/>'.implode('<br/>',$log):'无SQL记录');
				}else{
					$this->trace('SQL记录','无SQL记录');
				}
				if(isset(Log::$log[WEB_LOG_ERROR])) {
					$log	=	Log::$log[WEB_LOG_ERROR];
					$this->trace('错误记录',is_array($log)?count($log).'条错误<br/>'.implode('<br/>',$log):'无错误记录');
				}else{
					$this->trace('错误记录','无错误记录');
				}
				$_trace	=	array_merge($_trace,$this->trace);
				$_trace = auto_charset($_trace,'utf-8');
				$_title	=	auto_charset('页面Trace信息','utf-8');
				// 调用Trace页面模板
				include THINK_PATH.'/Tpl/PageTrace.tpl.php';
			}
            return null;
        }else {
			return $content;
        }
    }
}//
?>