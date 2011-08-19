package com.mslabs.pbe.iso.components
{
    import com.pblabs.engine.core.*;
    import com.pblabs.engine.debug.*;
    import com.pblabs.engine.entity.*;
    import com.pblabs.rendering2D.ICopyPixelsRenderer;
    import com.pblabs.rendering2D.spritesheet.*;
    
    import flash.display.*;
    import flash.geom.*;

    public class IsoSpriteSheetComponent extends IsoSpriteComponent implements ICopyPixelsRenderer
    {
        protected var _smoothing:Boolean = false;
        private var _setRegistration:Boolean = false;
        public var spriteSheet:SpriteContainerComponent;
        public var spriteIndex:int = 0;
        public var directionReference:PropertyReference;
		public static const zeroPoint:Point = new Point();

        public function IsoSpriteSheetComponent(param1:Boolean = false)
        {
            super(param1);
            this._smoothing = true;
            return;
        }// end function

        override public function onFrame(param1:Number) : void
        {
            super.onFrame(param1);
            var _loc_2:* = this.getCurrentFrame();
            if (this.bitmapData !== _loc_2)
            {
                this.bitmapData = _loc_2;
            }
            return;
        }// end function

        public function isPixelPathActive(param1:Matrix) : Boolean
        {
            if (param1.a == 1)
            {
            }
            if (param1.b == 0)
            {
            }
            if (param1.c == 0)
            {
            }
            if (param1.d == 1)
            {
            }
            if (alpha == 1)
            {
            }
            if (blendMode == BlendMode.NORMAL)
            {
            }
            return displayObject.filters.length == 0;
        }// end function

        public function drawPixels(param1:Matrix, param2:BitmapData) : void
        {
            param2.copyPixels(Bitmap(_spriteObj).bitmapData, Bitmap(_spriteObj).bitmapData.rect, param1.transformPoint(zeroPoint), null, null, true);
            return;
        }// end function

        override public function pointOccupied(param1:Point, param2:ObjectType) : Boolean
        {
            if (Bitmap(_spriteObj))
            {
            }
            if (!Bitmap(_spriteObj).bitmapData)
            {
                return false;
            }
            var _loc_3:* = transformWorldToObject(param1);
            return Bitmap(_spriteObj).bitmapData.hitTest(zeroPoint, 1, _loc_3);
        }// end function

        protected function getCurrentFrame() : BitmapData
        {
            if (this.spriteSheet)
            {
            }
            if (!this.spriteSheet.isLoaded)
            {
                return null;
            }
            if (this.spriteSheet)
            {
            }
            if (this.spriteSheet.isLoaded)
            {
            }
            if (this.spriteSheet.center)
            {
                registrationPoint = this.spriteSheet.center.clone();
                registrationPoint.x = registrationPoint.x * -1;
                registrationPoint.y = registrationPoint.y * -1;
            }
            this._setRegistration = true;
            if (this.directionReference)
            {
                return this.spriteSheet.getFrame(this.spriteIndex, owner.getProperty(this.directionReference) as Number);
            }
            return this.spriteSheet.getFrame(this.spriteIndex);
        }// end function

        public function get bitmapData() : BitmapData
        {
            if (_spriteObj)
            {
                return Bitmap(_spriteObj).bitmapData;
            }
            return null;
        }// end function

        public function set bitmapData(param1:BitmapData) : void
        {
            if (param1 == null)
            {
                Logger.error(this, " set bitmapData", "BitmapData can not be null");
                return;
            }
            sprite = param1;
            Bitmap(_spriteObj).pixelSnapping = PixelSnapping.AUTO;
            this.smoothing = this._smoothing;
            _transformDirty = true;
            return;
        }// end function

        public function get smoothing() : Boolean
        {
            return this._smoothing;
        }// end function

        public function set smoothing(param1:Boolean) : void
        {
            this._smoothing = param1;
            if (_spriteObj)
            {
                Bitmap(_spriteObj).smoothing = param1;
            }
            return;
        }// end function

    }
}
