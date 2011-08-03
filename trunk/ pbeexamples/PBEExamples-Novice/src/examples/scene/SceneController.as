package examples.scene
{
	import com.adobe.serialization.json.JSON;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.allocateEntity;
	import com.pblabs.rendering2D.BasicSpatialManager2D;
	import com.pblabs.rendering2D.DisplayObjectScene;
	import com.pblabs.rendering2D.SimpleShapeRenderer;
	import com.pblabs.rendering2D.ui.SceneView;
	
	import flash.geom.Point;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;

	public class SceneController
	{
		public function SceneController()
		{
		}
		
		public static var wrapper:UIComponent = new UIComponent;

		private static var sceneView:SceneView;

		private static var scene:IEntity;

		private static var doScene:DisplayObjectScene;
		public static function init():void{
			//wrapper for flex
			wrapper.width = FlexGlobals.topLevelApplication.width;
			wrapper.height = FlexGlobals.topLevelApplication.height;
			FlexGlobals.topLevelApplication.addElement(wrapper);
			//starting PBE
			PBE.startup(wrapper);
		}
		
		/**
		 * 
		 * FirstWay to create a Scene
		 * 
		 **/
		public static function createScene_1():void{
			sceneView = new SceneView;
			sceneView.name = "SceneView";
			//scene view is just like view port  , from which the entire application can be seen
			wrapper.addChild(sceneView);
			
			doScene = new DisplayObjectScene;
			doScene.sceneView = sceneView;
			//no use entity
			scene = allocateEntity();
			scene.initialize("Scene11");
			//adding a place holder entity , this entity has no use except that it will add the Display Object scene and this the onAdd function of the 
			//DisplayObjectScene will be called
			scene.addComponent(doScene,"doScene");
		}
		
		public static function createScene_2():void{
			sceneView = new SceneView;
			sceneView.name = "SceneView";
			//scene view is just like view port  , from which the entire application can be seen
			wrapper.addChild(sceneView);
			
			doScene = new DisplayObjectScene;
			doScene.sceneView = sceneView;
			doScene.callOnAdd();
		}
		
		/**
		 * this function will stil display the object but the position will be different , because the onAdd function of the DisplayObjectScene
		 * is not called
		 **/
		public static function createScene_buggy():void{
			sceneView = new SceneView;
			sceneView.name = "SceneView";
			//scene view is just like view port  , from which the entire application can be seen
			wrapper.addChild(sceneView);
			
			doScene = new DisplayObjectScene;
			doScene.sceneView = sceneView;
		}
		
		/**
		 * 
		 * 
		 **/
		
		
		public static function createHero():void{ 
			var hero:IEntity = allocateEntity();
			hero.addComponent(createSimpleShapeRenderer(),"Render");
			
			//var spatialManager:BasicSpatialManager2D = new BasicSpatialManager2D;
			//hero.addComponent(spatialManager,"Spatial");
			//hero.addComponent(doScene,"doScene");
			hero.initialize("Hero");
		}
		
		//this will create a circle
		private static function createSimpleShapeRenderer():SimpleShapeRenderer{
			var simple:SimpleShapeRenderer = new SimpleShapeRenderer;
			simple.fillColor = 0x0000FF0;
			simple.isCircle = true;
			simple.lineSize = 2;
			simple.radius = 25;
			simple.lineColor = 0x000000;
			//assigning scene to the PBE scene
			simple.scene = doScene;
			return simple;
		}
		
		
	}
}