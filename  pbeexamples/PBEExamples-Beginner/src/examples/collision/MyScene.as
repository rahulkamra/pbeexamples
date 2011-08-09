package examples.collision
{
	import com.pblabs.rendering2D.DisplayObjectScene;
	
	import flash.display.Sprite;
	
	public class MyScene extends DisplayObjectScene
	{
		public function MyScene()
		{
			super();
		}
		
		public function get rootSprite():Sprite{
			return _rootSprite;
		}
	}
}