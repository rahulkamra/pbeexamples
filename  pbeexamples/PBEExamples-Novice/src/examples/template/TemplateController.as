package examples.template
{
	import com.pblabs.engine.core.LevelEvent;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.rendering2D.ui.SceneView;
	
	import flash.events.Event;

	public class TemplateController
	{
		public function TemplateController()
		{
		}
		
		private static var sceneView:SceneView;
		public static function createScene_using_xml(levelNumber:int):void{
			sceneView = new SceneView;
			sceneView.name = "SceneView"
			loadLevel(levelNumber);
		}
		
		private static function loadLevel(levelNumber:int):void{
			LevelManager.instance.addEventListener(LevelEvent.LEVEL_LOADED_EVENT,levelLoaded);
			LevelManager.instance.load("../level/levelDescriptions.xml",levelNumber);
		}
		
		protected static function levelLoaded(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}		
		
	}
}