package examples.collision
{
	import Box2D.Collision.Shapes.b2ShapeDef;
	
	import com.pblabs.box2D.Box2DSpatialComponent;
	import com.pblabs.box2D.CollisionShape;
	import com.pblabs.box2D.PolygonCollisionShape;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.InputMap;
	import com.pblabs.engine.core.LevelEvent;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.allocateEntity;
	import com.pblabs.rendering2D.DisplayObjectScene;
	import com.pblabs.rendering2D.SimpleShapeRenderer;
	import com.pblabs.rendering2D.ui.SceneView;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.FlexGlobals;

	public class CollisionController
	{
		public function CollisionController()
		{
		}
		
		/**
		 * Some things to note 
		 * Box2DSpatialComponent -> has two very important object refrences 
		 * a. bodyDef -> defination of the body
		 * b. body , => Actual body produced
		 * c. shape def -> all the collosion bodies specified is the shape def ,this is the most important as it tells how the body has to behave
		 * A body can have many shapes with different properties ,
		 **/
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
			var scene:MyScene =  PBE.lookupComponentByName("Scene","Scene") as MyScene;
			FlexGlobals.topLevelApplication.addEventListener(MouseEvent.CLICK,click)
		}
		
		protected static function click(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var iEntity:IEntity = PBE.templateManager.instantiateEntity("Box");
			var simpleShape:SimpleShapeRenderer = iEntity.lookupComponentByName("Render") as SimpleShapeRenderer;
			var spatial:Box2DSpatialComponent = iEntity.lookupComponentByName("Spatial") as Box2DSpatialComponent;
			spatial.position = new Point(FlexGlobals.topLevelApplication.mouseX-FlexGlobals.topLevelApplication.width/2,FlexGlobals.topLevelApplication.mouseY-FlexGlobals.topLevelApplication.height/2);
		}
	}
}