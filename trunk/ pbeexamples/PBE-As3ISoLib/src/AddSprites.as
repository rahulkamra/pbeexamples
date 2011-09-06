package
{
	import as3isolib.geom.Pt;
	
	import com.pblabs.animation.Animator;
	import com.pblabs.animation.AnimatorComponent;
	import com.pblabs.animation.AnimatorType;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.spritesheet.BasicSpriteSheetComponent;
	import com.pblabs.rendering2D.spritesheet.CellCountDivider;
	
	import flash.utils.Dictionary;
	
	import mx.core.FlexGlobals;
	
	import mycmp.MouseComponent;
	
	import port.iso.components.MyIsoSpatialComponent;
	import port.iso.spritesheet.IsoSpriteSheetComponent;
	import port.iso.spritesheet.ResourceLoaderComponent;

	public class AddSprites
	{
		public function AddSprites()
		{
		}
		
		public static  function addSpriteSheet():void{
			for(var row:int = 0 ; row < 8; row++){
				for(var col:int = 0 ; col < 8; col++){
					addSprite(row,col);
				}
			}
		}
		
		
		private static  function addSprite(row:int , col:int):void
		{
			// TODO Auto Generated method stub
			var row1:int = 0; 
			var col2:int = 0;
			var character:IEntity = PBE.allocateEntity();
			character.initialize("Police"+row+col);
			
			var spatial:MyIsoSpatialComponent = new MyIsoSpatialComponent();
			spatial.position = new Pt(20*row,20*col,0);
			character.addComponent(spatial,"Spatial");
			
			var resource:ResourceLoaderComponent = new ResourceLoaderComponent();
			resource.fileUrl = "policeleft.png"
			resource.resourceType = "com.pblabs.engine.resource::ImageResource";
			character.addComponent(resource,"Resource");
			
			var police:IsoSpriteSheetComponent = new IsoSpriteSheetComponent(true);
			police.resourcePropertyReference = new PropertyReference("@Resource.resourceContent");
			police.scene = FlexGlobals.topLevelApplication.firstisoScene;
			
			var sheet:BasicSpriteSheetComponent = new BasicSpriteSheetComponent();
			sheet.directionsPerFrame = 1;
			var divider:CellCountDivider = new CellCountDivider();
			divider.xCount = 6;
			divider.yCount = 5;
			
			sheet.divider = divider;
			police.spriteSheet = sheet;
			character.addComponent(police,"Renderer");
			
			var animator:AnimatorComponent = new AnimatorComponent();
			animator.defaultAnimation = "Walk" 
			animator.animations = new Dictionary();
			animator.reference = new PropertyReference("@Renderer.spriteIndex");
			
			var walk:Animator = new Animator();
			walk.duration = 1;
			walk.repeatCount = -1;
			walk.animationType = AnimatorType.LOOP_ANIMATION;
			walk.startValue = 0;
			walk.targetValue = 29;
			animator.animations["Walk"] = walk;
			
			
			
			var mousecomponent:MouseComponent = new MouseComponent;
			character.addComponent(mousecomponent,"Mouse")
				
			character.addComponent(animator,"Animator");
			
		}
		
	}
}