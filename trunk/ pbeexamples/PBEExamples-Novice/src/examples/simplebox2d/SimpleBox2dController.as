package examples.simplebox2d
{
	import com.pblabs.box2D.Box2DManagerComponent;
	import com.pblabs.box2D.Box2DSpatialComponent;
	import com.pblabs.box2D.CircleCollisionShape;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.engine.entity.allocateEntity;
	import com.pblabs.rendering2D.DisplayObjectScene;
	import com.pblabs.rendering2D.IScene2D;
	import com.pblabs.rendering2D.ISpatialManager2D;
	import com.pblabs.rendering2D.SimpleShapeRenderer;
	import com.pblabs.rendering2D.ui.SceneView;
	
	import examples.scene.SceneController;
	
	import flash.geom.Point;
	
	public class SimpleBox2dController
	{
		public function SimpleBox2dController()
		{
		}
		
		private static var sceneView:SceneView;
		
		public static function createSceneView():void{
			sceneView = new SceneView;
		}
		public static function createScene():void{
			PBE.initializeScene(sceneView,"SceneView",DisplayObjectScene,Box2DManagerComponent);
		}
		
		
		/**
		 * 
		 * 
		 * 
		 **/
		
		public static function createBox2DHero():void{
			var hero:IEntity = allocateEntity();
			hero.addComponent(createSimpleShapeRenderer(PBE.scene),"Render");
			hero.addComponent(createSpatialComponent(PBE.spatialManager),"SpatialHero");
			hero.initialize("Hero");
		}
		
		public static function createSimpleShapeRenderer(scene:IScene2D=null):SimpleShapeRenderer{
			var simple:SimpleShapeRenderer = new SimpleShapeRenderer;
			simple.fillColor = 0x0000FF0;
			simple.isCircle = true;
			simple.lineSize = 2;
			simple.radius = 25;
			simple.lineColor = 0x000000;
			//assigning scene to the PBE scene
			simple.scene = scene;
			simple.positionProperty = new PropertyReference("@SpatialHero.position");
			simple.rotationProperty = new PropertyReference("@SpatialHero.rotation");
			
			return simple;
		}
		
		
		public static function createSpatialComponent(spatialManager:ISpatialManager2D=null):Box2DSpatialComponent{
			var simple:Box2DSpatialComponent = new Box2DSpatialComponent;
			//
			//simple.spatialManager = PBE.lookupEntity("SceneView").lookupComponentByName("Spatial") as Box2DManagerComponent;
			
			if(spatialManager){
				simple.spatialManager = spatialManager as Box2DManagerComponent;
			}else{
				simple.spatialManager = PBE.spatialManager as Box2DManagerComponent;
			}
			
			simple.canMove = true;
			simple.canRotate = true;
			simple.canSleep = false;
			simple.position = new Point(0, -100);
			simple.size = new Point(60, 60);
			
			var shape:CircleCollisionShape = new CircleCollisionShape();
			shape.radius = 1.0;
			shape.density = 1;
			
			simple.collisionShapes = new Array();
			simple.collisionShapes.push(shape);
			return simple;
		}
		
	}
}