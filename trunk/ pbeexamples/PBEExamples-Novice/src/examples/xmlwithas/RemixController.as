package examples.xmlwithas
{
	import com.pblabs.box2D.Box2DDebugComponent;
	import com.pblabs.box2D.Box2DManagerComponent;
	import com.pblabs.box2D.Box2DSpatialComponent;
	import com.pblabs.box2D.CircleCollisionShape;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.LevelEvent;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.IScene2D;
	import com.pblabs.rendering2D.ISpatialManager2D;
	import com.pblabs.rendering2D.SimpleShapeRenderer;
	import com.pblabs.rendering2D.ui.SceneView;
	
	import flash.geom.Point;

	public class RemixController
	{
		public function RemixController()
		{
		}
		
		
		private static var sceneView:SceneView;
		
		public static function createScene_using_xml():void{
			sceneView = new SceneView;
			sceneView.name = "SceneView"
			loadLevel();
		}
		
		private static function loadLevel():void{
			LevelManager.instance.addEventListener(LevelEvent.LEVEL_LOADED_EVENT,levelLoaded);
			LevelManager.instance.load("../level/levelDescriptions.xml",3);
		}
		protected static function levelLoaded(event:LevelEvent):void
		{
			//adding physics now
			var scene:IScene2D = PBE.lookupComponentByName("Scene","Scene") as IScene2D;
			var manager:ISpatialManager2D = PBE.lookupComponentByName("Box2dSpatial","Manager") as ISpatialManager2D;
			var hero:IEntity = PBE.lookupEntity("NonPhysicsHero") as IEntity;
			var shape:SimpleShapeRenderer = hero.lookupComponentByName("Render") as SimpleShapeRenderer;
			//important step , the position of the renderer must be changed with respect to the Spacial component
			shape.positionProperty = new PropertyReference("@SpatialHero.position");
			
			hero.addComponent(createSpatialComponent(manager),"SpatialHero");
			var debug:Box2DDebugComponent = createBox2dDebugComponent(manager);
			debug.scene = scene;
			hero.addComponent(debug,"DebugHero");
			hero.initialize();
			
		}
		
		public static function createSpatialComponent(spatialManager:ISpatialManager2D=null):Box2DSpatialComponent{
			var simple:Box2DSpatialComponent = new Box2DSpatialComponent;
			//
			
			if(spatialManager){
				simple.spatialManager = spatialManager as Box2DManagerComponent;
			}else{
				simple.spatialManager = PBE.spatialManager as Box2DManagerComponent;
			}
			
			simple.canMove = true;
			simple.canRotate = true;
			simple.canSleep = false;
			simple.position = new Point(200,0);
			simple.size = new Point(60, 60);
			
			var shape:CircleCollisionShape = new CircleCollisionShape();
			shape.radius = 1.0;
			shape.density = 1;
			
			simple.collisionShapes = new Array();
			simple.collisionShapes.push(shape);
			return simple;
		}
		
		public static function createBox2dDebugComponent(spatialManager:ISpatialManager2D=null):Box2DDebugComponent{
			var simple:Box2DDebugComponent = new Box2DDebugComponent();
			if(spatialManager){
				simple.spatialManager = spatialManager as Box2DManagerComponent;
			}else{
				simple.spatialManager = PBE.spatialManager as Box2DManagerComponent;
			}
			
			simple.scene = PBE.scene;
			// Allocate new entity and add components.
			return simple;
		}
		
		
		
		
	}
}