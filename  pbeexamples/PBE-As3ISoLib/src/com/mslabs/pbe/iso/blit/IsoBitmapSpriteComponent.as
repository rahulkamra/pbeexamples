package com.mslabs.pbe.iso.blit
{
    import com.mslabs.pbe.iso.components.IsoBoxSprite;
    import com.pblabs.engine.debug.*;
    import com.pblabs.engine.resource.*;
    
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;

    public class IsoBitmapSpriteComponent extends IsoBitmapBaseComponent
    {
        protected var _spriteObj:DisplayObject;
        protected var _spriteOffset:Point;
        public static const COMPONENT_NAME:String = getQualifiedClassName(IsoBitmapSpriteComponent).replace("::", ".");

        public function IsoBitmapSpriteComponent(param1:Boolean = false)
        {
            this._spriteOffset = new Point();
            super(param1);
            _isoObject = new IsoBoxSprite();
            return;
        }// end function

        public function addSprite(param1:Object, param2:Point = null) : void
        {
            this.sprite = param1;
            if (param2)
            {
                this.spriteOffset = param2;
            }
            return;
        }// end function

        override protected function attachLoadedResource() : void
        {
            var _loc_1:Resource = null;
            super.attachLoadedResource();
            if (owner)
            {
                if (!this._spriteObj)
                {
                    if (!resourcePropertyReference)
                    {
                        return;
                    }
                    _loc_1 = owner.getProperty(resourcePropertyReference) as Resource;
                    if (!_loc_1)
                    {
                        return;
                    }
                    if (!_loc_1.isLoaded)
                    {
                        return;
                    }
                    if (_loc_1 is SWFResource)
                    {
                        if (!className)
                        {
                            return;
                        }
                        if ((_loc_1 as SWFResource).appDomain)
                        {
                            this.sprite = (_loc_1 as SWFResource).getAssetClass(className);
                        }
                        else
                        {
                            Logger.error(this, "attachLoadedResource", "The SWF resource is missing domain information, so it can not be extracted.");
                        }
                    }
                    else if (_loc_1 is ImageResource)
                    {
                        if (!(_loc_1 as ImageResource).bitmapData)
                        {
                            Logger.error(this, "attachLoadedResource", "The Image resource is missing information, so it can not be used.");
                        }
                        else
                        {
                            this.sprite = (_loc_1 as ImageResource).bitmapData;
                        }
                    }
                    else
                    {
                        return;
                    }
                }
            }
            return;
        }// end function

        override protected function removeResourceData() : void
        {
            super.removeResourceData();
            if (resourcePropertyReference)
            {
                if (this._spriteObj)
                {
                    _isoObject.container.removeChild(this._spriteObj);
                    this._spriteObj = null;
                }
            }
            return;
        }// end function

        public function set geometryVisible(param1:Boolean) : void
        {
            IsoBoxSprite(_isoObject).geometryVisible = param1;
            return;
        }// end function

        public function set sprite(param1:Object) : void
        {
            var _loc_3:Bitmap = null;
            var _loc_4:* = undefined;
            var _loc_2:Boolean = false;
            if (this._spriteObj)
            {
                if (param1 is BitmapData)
                {
                    _loc_2 = true;
                }
                else
                {
                    _isoObject.container.removeChild(this._spriteObj);
                }
            }
            if (param1 is BitmapData)
            {
                if (this._spriteObj)
                {
                    if (param1 === Bitmap(this._spriteObj).bitmapData)
                    {
                        return;
                    }
                }
                if (_loc_2)
                {
                    Bitmap(this._spriteObj).bitmapData = param1 as BitmapData;
                }
                else
                {
                    _loc_3 = new Bitmap(BitmapData(param1));
                    _loc_3.cacheAsBitmap = true;
                    this._spriteObj = _loc_3;
                }
            }
            else if (param1 is DisplayObject)
            {
                this._spriteObj = DisplayObject(param1);
            }
            else if (param1 is Class)
            {
                _loc_4 = new param1;
                if (_loc_4 is BitmapData)
                {
                    this._spriteObj = new Bitmap(BitmapData(_loc_4));
                }
                else
                {
                    this._spriteObj = DisplayObject(_loc_4);
                }
            }
            else
            {
                this._spriteObj = null;
                Logger.error(this, "addSprite", "skin asset is not of the following types: BitmapData, DisplayObject, ISpriteAsset, IFactory or Class cast as DisplayOject.");
                return;
            }
            if (!_loc_2)
            {
                _isoObject.container.addChild(this._spriteObj);
            }
            if (this._spriteObj)
            {
                if (this.spriteOffset.x == 0)
                {
                }
                if (this.spriteOffset.y != 0)
                {
                    this._spriteObj.x = this.spriteOffset.x;
                    this._spriteObj.y = this.spriteOffset.y;
                }
            }
            return;
        }// end function
		
		override public function drawPixels(objectToScreen:Matrix, renderTarget:BitmapData):void{
			trace("Drawing!!")
		}

        public function get spriteOffset() : Point
        {
            return this._spriteOffset;
        }// end function

        public function set spriteOffset(param1:Point) : void
        {
            this._spriteOffset = param1;
            if (this._spriteObj)
            {
                this._spriteObj.x = this.spriteOffset.x;
                this._spriteObj.y = this.spriteOffset.y;
            }
            return;
        }// end function

    }
}
