package com.mslabs.pbe.iso.components
{
    import com.pblabs.engine.core.*;
    import com.pblabs.engine.entity.*;
    import com.pblabs.rendering2D.ICopyPixelsRenderer;
    import com.pblabs.rendering2D.spritesheet.*;
    
    import flash.display.*;
    import flash.geom.*;

    public class IsoSpriteSheetComponent extends IsoSpriteComponent implements ICopyPixelsRenderer
    {
        protected var _smoothing:Boolean = false;
        private var _setRegistration:Boolean = false;
        public var spriteSheetReference:PropertyReference;
		//changed public var spriteSheet:ISpriteSheet;
        public var spriteSheet:Object;
        public var spriteIndex:int = 0;
        public var directionReference:PropertyReference;
        public var direction:Number = 0;
        static const zeroPoint:Point = new Point();

        public function IsoSpriteSheetComponent(param1:Boolean = false)
        {
            super(param1);
            this._smoothing = true;
            optimize = false;
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

        override protected function onRemove() : void
        {
            if (this.spriteSheet)
            {
                this.spriteSheet.destroy();
                this.spriteSheet = null;
            }
            this.spriteSheetReference = null;
            this.directionReference = null;
            super.onRemove();
            return;
        }// end function

        override public function isPixelPathActive(param1:Matrix) : Boolean
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

        override public function drawPixels(param1:Matrix, param2:BitmapData) : void
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

        override protected function attachLoadedResource() : void
        {
            var _loc_1:BitmapData = null;
            if (owner)
            {
                if (_spriteObj)
                {
                    removeResourceData();
                }
                if (this.spriteSheet)
                {
                }
                if (this.spriteSheet is BasicSpriteSheetComponent)
                {
                    if (!resourcePropertyReference)
                    {
                        return;
                    }
                    _loc_1 = owner.getProperty(resourcePropertyReference) as BitmapData;
                    if (!_loc_1)
                    {
                        return;
                    }
                    (this.spriteSheet as BasicSpriteSheetComponent).imageData = _loc_1;
                }
            }
            return;
        }// end function

        protected function getCurrentFrame() : BitmapData
        {
            if (!this.spriteSheet)
            {
            }
            if (this.spriteSheetReference)
            {
                this.spriteSheet = owner.getProperty(this.spriteSheetReference) as ISpriteSheet;
            }
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
            if (this.spriteSheet.centered)
            {
                if (spriteOffset.x == 0)
                {
                }
            }
            if (spriteOffset.y == 0)
            {
                registrationPoint = this.spriteSheet.center.clone();
                registrationPoint.x = registrationPoint.x * -1;
                registrationPoint.y = registrationPoint.y * -1;
                spriteOffset = new Point(-this.spriteSheet.center.x, -this.spriteSheet.center.y);
            }
            this._setRegistration = true;
            if (this.directionReference)
            {
            }
            if (owner.doesPropertyExist(this.directionReference))
            {
                this.direction = owner.getProperty(this.directionReference) as Number;
            }
            return this.spriteSheet.getFrame(this.spriteIndex, this.direction);
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
