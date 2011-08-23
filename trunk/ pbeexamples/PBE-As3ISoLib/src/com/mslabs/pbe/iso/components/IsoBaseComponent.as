package com.mslabs.pbe.iso.components
{
    import as3isolib.core.*;
    import as3isolib.geom.*;
    import com.mslabs.pbe.iso.components.*;
    import com.pblabs.engine.*;
    import com.pblabs.engine.core.*;
    import com.pblabs.engine.debug.*;
    import com.pblabs.engine.entity.*;
    import com.pblabs.rendering2D.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class IsoBaseComponent extends DisplayObjectRenderer implements IIsoComponent, ICopyPixelsRenderer
    {
        public var resourcePropertyReference:PropertyReference;
        public var isometricVolumeProperty:PropertyReference;
        public var positionOffsetProperty:PropertyReference;
        private var autoAssignRefs:Boolean = false;
        protected var _isoObject:IIsoDisplayObject;
        protected var _isometricVolume:Pt;
        protected var _debug:Boolean;
        protected var _spatialComponentName:String;
        private var _bitmapHolder:Bitmap;
        private var _optimize:Boolean = true;
        public static const COMPONENT_NAME:String = getQualifiedClassName(IsoBaseComponent).replace("::", ".");
		public static const zeroPoint:Point = new Point();

        public function IsoBaseComponent(param1:Boolean = false)
        {
            this._isometricVolume = new Pt();
            this._bitmapHolder = new Bitmap();
            this.autoAssignRefs = param1;
            if (this.autoAssignRefs)
            {
                this._spatialComponentName = "Spatial";
            }
            _position = new Pt();
            _positionOffset = new Pt();
            return;
        }// end function

        override public function updateTransform(param1:Boolean = false) : void
        {
            var _loc_4:Rectangle = null;
            if (!_displayObject)
            {
                return;
            }
            if (param1)
            {
                this.updateProperties();
            }
            var _loc_2:* = _scale.x;
            var _loc_3:* = _scale.y;
            if (_size)
            {
                _loc_4 = this.displayObject.getBounds(this.displayObject);
                _loc_2 = _scale.x * (_size.x / _loc_4.width);
                _loc_3 = _scale.y * (_size.y / _loc_4.height);
            }
            _transformMatrix.identity();
            _transformMatrix.scale(_loc_2, _loc_3);
            _transformMatrix.translate((-_registrationPoint.x) * _loc_2, (-_registrationPoint.y) * _loc_3);
            _transformMatrix.rotate(PBUtil.getRadiansFromDegrees(_rotation) + _rotationOffset);
            _transformMatrix.translate(_position.x + _positionOffset.x, _position.y + _positionOffset.y);
            this.isoComponent.container.scaleX = _transformMatrix.a;
            this.isoComponent.container.scaleY = _transformMatrix.d;
            this.isoComponent.container.rotation = _rotation + _rotationOffset;
            this.isoComponent.moveTo(_transformMatrix.tx, _transformMatrix.ty, Pt(_position).z + Pt(_positionOffset).z);
            this.isoComponent.render();
            _displayObject.alpha = _alpha;
            _displayObject.blendMode = _blendMode;
            _displayObject.visible = alpha > 0;
            _transformDirty = false;
            return;
        }// end function

        override public function pointOccupied(param1:Point, param2:ObjectType) : Boolean
        {
            if (this.displayObject)
            {
            }
            if (!this.scene)
            {
                return false;
            }
            if (this.displayObject.stage == null)
            {
                Logger.warn(this, "pointOccupied", "DisplayObject is not on stage, so hitTestPoint will probably not work right.");
            }
            param1 = this.scene.transformSceneToScreen(param1);
            return this.displayObject.hitTestPoint(param1.x, param1.y, true);
        }// end function

        public function getBounds(param1:DisplayObject) : Rectangle
        {
            return this._isoObject.getBounds(param1);
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
            return this.displayObject.filters.length == 0;
        }// end function

        public function drawPixels(param1:Matrix, param2:BitmapData) : void
        {
            this._bitmapHolder.bitmapData = this.isoComponent.getRenderData().bitmapData;
            if (this._bitmapHolder.bitmapData != null)
            {
                param2.copyPixels(this._bitmapHolder.bitmapData, this._bitmapHolder.bitmapData.rect, param1.transformPoint(zeroPoint), null, null, true);
            }
            return;
        }// end function

        override protected function onAdd() : void
        {
            super.onAdd();
            if (_displayObject == null)
            {
                _displayObject = this._isoObject.container;
                addToScene();
            }
            if (this.autoAssignRefs)
            {
                this.wireUpPropertyReferences();
            }
            this.attachLoadedResource();
            owner.eventDispatcher.addEventListener("resourceLoaded", this.resourceLoaded);
            return;
        }// end function

        override protected function onRemove() : void
        {
            super.onRemove();
            this.removeResourceData();
            this._debug = false;
            this._isoObject.removeAllChildren();
            this._isoObject = null;
            this.cleanUpPropertyReferences();
            if (this.resourcePropertyReference)
            {
                this.resourcePropertyReference = null;
            }
            owner.eventDispatcher.removeEventListener("resourceLoaded", this.resourceLoaded);
            return;
        }// end function

        override protected function onReset() : void
        {
            if (this.autoAssignRefs)
            {
                this.wireUpPropertyReferences();
            }
            this.checkResourceExistence();
            return;
        }// end function

        override protected function updateProperties() : void
        {
            var _loc_1:Point = null;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:String = null;
            var _loc_5:Point = null;
            if (!owner)
            {
                return;
            }
            if (zIndexProperty)
            {
            }
            if (owner.doesPropertyExist(zIndexProperty))
            {
                this.zIndex = owner.getProperty(zIndexProperty, this.zIndex);
            }
            if (positionProperty != null)
            {
            }
            if (owner.doesPropertyExist(positionProperty))
            {
                this.position = owner.getProperty(positionProperty) as Pt;
            }
            if (this.positionOffsetProperty != null)
            {
            }
            if (owner.doesPropertyExist(this.positionOffsetProperty))
            {
                this.positionOffset = owner.getProperty(this.positionOffsetProperty) as Pt;
            }
            if (scaleProperty)
            {
            }
            if (owner.doesPropertyExist(scaleProperty))
            {
                _loc_1 = owner.getProperty(scaleProperty) as Point;
                if (_loc_1)
                {
                    this.scale = _loc_1;
                }
            }
            if (this.isometricVolumeProperty != null)
            {
            }
            if (owner.doesPropertyExist(this.isometricVolumeProperty))
            {
                this.isometricVolume = owner.getProperty(this.isometricVolumeProperty) as Pt;
            }
            if (rotationProperty)
            {
            }
            if (owner.doesPropertyExist(rotationProperty))
            {
                _loc_2 = owner.getProperty(rotationProperty) as Number;
                this.rotation = _loc_2;
            }
            if (alphaProperty)
            {
            }
            if (owner.doesPropertyExist(alphaProperty))
            {
                _loc_3 = owner.getProperty(alphaProperty) as Number;
                this.alpha = _loc_3;
            }
            if (blendModeProperty)
            {
            }
            if (owner.doesPropertyExist(blendModeProperty))
            {
                _loc_4 = owner.getProperty(blendModeProperty) as String;
                this.blendMode = _loc_4;
            }
            if (registrationPointProperty)
            {
            }
            if (owner.doesPropertyExist(registrationPointProperty))
            {
                _loc_5 = owner.getProperty(registrationPointProperty) as Point;
                if (_loc_5)
                {
                    registrationPoint = _loc_5;
                }
            }
            return;
        }// end function

        protected function cleanUpPropertyReferences() : void
        {
            if (zIndexProperty)
            {
                zIndexProperty = null;
            }
            if (layerIndexProperty)
            {
                layerIndexProperty = null;
            }
            if (positionProperty)
            {
                positionProperty = null;
            }
            if (this.positionOffsetProperty)
            {
                this.positionOffsetProperty = null;
            }
            if (scaleProperty)
            {
                scaleProperty = null;
            }
            if (this.isometricVolumeProperty)
            {
                this.isometricVolumeProperty = null;
            }
            if (rotationProperty)
            {
                rotationProperty = null;
            }
            if (alphaProperty)
            {
                alphaProperty = null;
            }
            if (blendModeProperty)
            {
                blendModeProperty = null;
            }
            if (registrationPointProperty)
            {
                registrationPoint = null;
            }
            return;
        }// end function

        protected function wireUpPropertyReferences() : void
        {
            if (owner == null)
            {
                return;
            }
            if (!this._spatialComponentName)
            {
                return;
            }
            if (owner.lookupComponentByName(this.spatialComponentName))
            {
                this.isometricVolumeProperty = new PropertyReference("@" + this.spatialComponentName + ".isometricVolume");
                positionProperty = new PropertyReference("@" + this.spatialComponentName + ".position");
                this.positionOffsetProperty = new PropertyReference("@" + this.spatialComponentName + ".positionOffset");
                rotationProperty = new PropertyReference("@" + this.spatialComponentName + ".rotation");
            }
            else
            {
                if (this.isometricVolumeProperty != null)
                {
                    this.isometricVolumeProperty = null;
                }
                if (positionProperty != null)
                {
                    positionProperty = null;
                }
                if (this.positionOffsetProperty != null)
                {
                    this.positionOffsetProperty = null;
                }
                if (rotationProperty != null)
                {
                    rotationProperty = null;
                }
            }
            this.updateTransform(true);
            return;
        }// end function

        protected function resourceLoaded(event:Event) : void
        {
            this.attachLoadedResource();
            return;
        }// end function

        protected function attachLoadedResource() : void
        {
            return;
        }// end function

        protected function checkResourceExistence() : void
        {
            if (this.resourcePropertyReference)
            {
            }
            if (!owner.doesPropertyExist(this.resourcePropertyReference))
            {
                this.removeResourceData();
            }
            return;
        }// end function

        protected function removeResourceData() : void
        {
            return;
        }// end function

        public function get isoComponent() : IIsoDisplayObject
        {
            return this._isoObject;
        }// end function

        public function get debug() : Boolean
        {
            return this._debug;
        }// end function

        public function set debug(param1:Boolean) : void
        {
            this._debug = param1;
            return;
        }// end function

        public function get isometricVolume() : Pt
        {
            return this._isometricVolume;
        }// end function

        public function set isometricVolume(param1:Pt) : void
        {
            this._isometricVolume = param1.clone() as Pt;
            this.isoComponent.setSize(this._isometricVolume.x, this._isometricVolume.z, this._isometricVolume.y);
            return;
        }// end function

        override public function get positionOffset() : Point
        {
            return _positionOffset.clone() as Pt;
        }// end function

        override public function set positionOffset(param1:Point) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (!param1 is Pt)
            {
                Logger.error(this, "set positionOffset", "The positionOffset must ne set using the AS3IsoLib Pt class. It needs the third Z dimension");
                return;
            }
            if (snapToNearestPixels)
            {
                _loc_2 = int(Pt(param1).x);
                _loc_3 = int(Pt(param1).y);
                _loc_4 = int(Pt(param1).z);
            }
            else
            {
                _loc_2 = Pt(param1).x;
                _loc_3 = Pt(param1).y;
                _loc_4 = Pt(param1).z;
            }
            if (_loc_2 == _positionOffset.x)
            {
            }
            if (_loc_3 == _positionOffset.y)
            {
            }
            if (_loc_4 == Pt(_positionOffset).z)
            {
                return;
            }
            _positionOffset.x = _loc_2;
            _positionOffset.y = _loc_3;
            Pt(_positionOffset).z = _loc_4;
            _transformDirty = true;
            return;
        }// end function

        override public function get position() : Point
        {
            return _position.clone() as Pt;
        }// end function

        override public function set position(param1:Point) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (!param1 is Pt)
            {
                Logger.error(this, "set position", "The position must be set using the AS3IsoLib Pt class. It needs the third Z dimension");
                return;
            }
            if (snapToNearestPixels)
            {
                _loc_2 = int(param1.x);
                _loc_3 = int(param1.y);
                _loc_4 = int(Pt(param1).z);
            }
            else
            {
                _loc_2 = param1.x;
                _loc_3 = param1.y;
                _loc_4 = Pt(param1).z;
            }
            if (_loc_2 == _position.x)
            {
            }
            if (_loc_3 == _position.y)
            {
            }
            if (_loc_4 == Pt(_position).z)
            {
                return;
            }
            _position.x = _loc_2;
            _position.y = _loc_3;
            Pt(_position).z = _loc_4;
            _transformDirty = true;
            return;
        }// end function

        override public function get x() : Number
        {
            return _position.x;
        }// end function

        override public function set x(param1:Number) : void
        {
            var _loc_2:Number = NaN;
            if (snapToNearestPixels)
            {
                _loc_2 = int(param1);
            }
            else
            {
                _loc_2 = param1;
            }
            if (_loc_2 == _position.x)
            {
                return;
            }
            _position.x = _loc_2;
            _transformDirty = true;
            return;
        }// end function

        override public function get y() : Number
        {
            return _position.y;
        }// end function

        override public function set y(param1:Number) : void
        {
            var _loc_2:Number = NaN;
            if (snapToNearestPixels)
            {
                _loc_2 = int(param1);
            }
            else
            {
                _loc_2 = param1;
            }
            if (_loc_2 == _position.y)
            {
                return;
            }
            _position.y = _loc_2;
            _transformDirty = true;
            return;
        }// end function

        public function get z() : Number
        {
            return Pt(_position).z;
        }// end function

        public function set z(param1:Number) : void
        {
            var _loc_2:Number = NaN;
            if (snapToNearestPixels)
            {
                _loc_2 = int(param1);
            }
            else
            {
                _loc_2 = param1;
            }
            if (_loc_2 == Pt(_position).z)
            {
                return;
            }
            Pt(_position).z = _loc_2;
            _transformDirty = true;
            return;
        }// end function

        override public function get zIndex() : int
        {
            return this.isoComponent.distance;
        }// end function

        override public function set zIndex(param1:int) : void
        {
            _zIndex = param1;
            this.isoComponent.distance = param1;
            return;
        }// end function

        public function get spatialComponentName() : String
        {
            return this._spatialComponentName;
        }// end function

        public function set spatialComponentName(param1:String) : void
        {
            if (param1)
            {
            }
            if (param1.length == 0)
            {
                this.autoAssignRefs = false;
                this.cleanUpPropertyReferences();
            }
            if (this._spatialComponentName != param1)
            {
                this._spatialComponentName = param1;
            }
            this.autoAssignRefs = true;
            this.wireUpPropertyReferences();
            return;
        }// end function

        override public function get displayObject() : DisplayObject
        {
            return _displayObject;
        }// end function

        override public function set displayObject(param1:DisplayObject) : void
        {
            Logger.error(this, "set displayObject", "Cannot set displayObject on an IsoComponent; it is always a Sprite containing the underlying AS3Iso Object\'s container");
            return;
        }// end function

        public function get optimize() : Boolean
        {
            return this._optimize;
        }// end function

        public function set optimize(param1:Boolean) : void
        {
            this._optimize = param1;
            if (this._optimize)
            {
                this._isoObject.isAnimated = false;
            }
            else
            {
                this._isoObject.isAnimated = true;
            }
            return;
        }// end function

        override public function get scene() : IScene2D
        {
            return super.scene;
        }// end function

        override public function set scene(param1:IScene2D) : void
        {
            super.scene = param1;
            return;
        }// end function

        public static function getFrom(param1:IEntity) : IIsoComponent
        {
            return param1.lookupComponentByType(IsoBaseComponent) as IIsoComponent;
        }// end function

    }
}
