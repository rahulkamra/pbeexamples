package com.mslabs.pbe.iso.components
{
    import as3isolib.display.primitive.*;
    
    import com.pblabs.engine.entity.*;
    
    import flash.utils.*;

    public class IsoBoxComponent extends IsoBaseComponent
    {
        public static const COMPONENT_NAME:String = getQualifiedClassName(IsoBoxComponent).replace("::", ".");

        public function IsoBoxComponent(param1:Boolean = false)
        {
            super(param1);
            _isoObject = new IsoBox();
            return;
        }// end function

        public static function getFrom(param1:IEntity) : IsoBoxComponent
        {
            return param1.lookupComponentByType(IsoBoxComponent) as IsoBoxComponent
        }// end function

    }
}
