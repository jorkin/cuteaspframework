<?php 
// 本类由系统自动生成，仅供测试用途
class IndexAction extends Action{
	public function index(){
		$Blog = new BlogModel();
		$list = $Blog->findAll();
		$this->assign('title','DEMO');
		$this->assign('list',$list);
		$this->display();
	}
} 

?>