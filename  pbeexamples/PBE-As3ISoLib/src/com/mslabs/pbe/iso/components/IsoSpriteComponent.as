package com.mslabs.pbe.iso.components
{
    import com.mslabs.utils.*;
    import com.pblabs.engine.debug.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;

    public class IsoSpriteComponent extends IsoBaseComponent
    {
        protected var _spriteObj:DisplayObject;
        public var spriteOffset:Point;
        public static const COMPONENT_NAME:String = getQualifiedClassName(IsoSpriteComponent).replace("::", ".");

        public function IsoSpriteComponent(param1:Boolean = false)
        {
            this.spriteOffset = new Point();
            super(param1);
            _isoObject = new IsoBoxSprite();
            optimize = true;
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
            var _loc_1:* = undefined;
            super.attachLoadedResource();
            if (owner)
            {
                if (this._spriteObj)
                {
                    this.removeResourceData();
                }
                if (!resourcePropertyReference)
                {
                    return;
                }
                _loc_1 = owner.getProperty(resourcePropertyReference);
                if (!_loc_1)
                {
                    return;
                }
                this.sprite = _loc_1;
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

        override protected function updateProperties() : void
        {
            super.updateProperties();
            if (this._spriteObj)
            {
                this._spriteObj.x = this.spriteOffset.x;
                this._spriteObj.y = this.spriteOffset.y;
            }
            return;
        }// end function

        public function get geometryVisible() : Boolean
        {
            return IsoBoxSprite(_isoObject).geometryVisible;
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
            if (this._spriteObj)
            {
            }
            if (param1 === Bitmap(this._spriteObj).bitmapData)
            {
                return;
            }
            if (param1 is BitmapData)
            {
            }
            var _loc_2:* = this._spriteObj ? (true) : (false);
            if (_loc_2)
            {
                Bitmap(this._spriteObj).bitmapData = param1 as BitmapData;
                return;
            }
            if (this._spriteObj)
            {
            }
            if (!(param1 is BitmapData))
            {
                _isoObject.container.removeChild(this._spriteObj);
            }
            if (param1 is BitmapData)
            {
                _loc_3 = new Bitmap(BitmapData(param1));
                _loc_3.cacheAsBitmap = true;
                this._spriteObj = _loc_3;
            }
            else if (param1 is DisplayObject)
            {
                if (param1 is MovieClip)
                {
                    IsoUtils.stopMovieClips(param1 as MovieClip);
                }
                this._spriteObj = DisplayObject(param1);
            }
            else if (param1 is Class)
            {
                _loc_4 = new param1;
                if (_loc_4 is MovieClip)
                {
                    IsoUtils.stopMovieClips(_loc_4);
                }
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
            _isoObject.container.addChild(this._spriteObj);
            return;
        }// end function

    }
}
