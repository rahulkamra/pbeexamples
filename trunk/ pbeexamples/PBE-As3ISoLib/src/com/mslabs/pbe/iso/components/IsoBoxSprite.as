package com.mslabs.pbe.iso.components
{
    import as3isolib.display.primitive.*;
    import flash.display.*;

    public class IsoBoxSprite extends IsoBox
    {
        public var geometryVisible:Boolean = false;

        public function IsoBoxSprite(param1:Object = null)
        {
            super(param1);
            return;
        }// end function

        override protected function drawGeometry() : void
        {
            if (this.geometryVisible)
            {
                super.drawGeometry();
            }
            return;
        }// end function

        override protected function createChildren() : void
        {
            mainContainer = new MovieClip();
            return;
        }// end function

    }
}
