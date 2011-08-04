package examples.xmlwithas
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.core.ProcessManager;
	
	public class TickComponent extends TickedComponent
	{
		public function TickComponent()
		{
			super();
		}
		
		override public function onTick(deltaTime:Number):void
		{
		}
		
		override protected function onAdd():void
		{
			// This causes the component to be registerd if it isn't already.
			PBEExamples.log("Component Added");
		}
	}
}