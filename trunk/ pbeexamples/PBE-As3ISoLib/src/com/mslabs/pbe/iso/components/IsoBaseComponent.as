package com.mslabs.pbe.iso.components
{
    import as3isolib.core.*;
    import as3isolib.geom.*;
    import com.mslabs.pbe.iso.components.*;
    import com.pblabs.engine.debug.*;
    import com.pblabs.engine.entity.*;
    import com.pblabs.rendering2D.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class IsoBaseComponent extends DisplayObjectRenderer implements IIsoComponent
    {
        public var resourcePropertyReference:PropertyReference;
        public var isometricVolumeProperty:PropertyReference;
        public var positionOffsetProperty:PropertyReference;
        public var className:String;
        private var autoAssignRefs:Boolean = false;
        protected var _isoObject:IIsoDisplayObject;
        protected var _isometricVolume:Pt;
        protected var _debug:Boolean;
        protected var _spatialComponentName:String;
        public static const COMPONENT_NAME:String = getQualifiedClassName(IsoBaseComponent).replace("::", ".");

        public function IsoBaseComponent(param1:Boolean = false)
        {
            this._isometricVolume = new Pt();
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
            if (!_displayObject)
            {
                return;
            }
            if (param1)
            {
                this.updateProperties();
            }
            if (_scale.x == 1)
            {
            }
            if (_scale.y != 1)
            {
                this.isoComponent.container.scaleX = _scale.x;
                this.isoComponent.container.scaleY = _scale.y;
            }
            this.isoComponent.x = _position.x + _positionOffset.x;
            this.isoComponent.y = _position.y + _positionOffset.y;
            this.isoComponent.z = Pt(_position).z + Pt(_positionOffset).z;
            _displayObject.rotation = _rotation + _rotationOffset;
            _displayObject.alpha = _alpha;
            _displayObject.blendMode = _blendMode;
            _displayObject.visible = alpha > 0;
            this.isoComponent.invalidatePosition();
            this.isoComponent.invalidateSize();
            this.isoComponent.render();
            _transformDirty = false;
            return;
        }// end function

        public function getBounds(param1:DisplayObject) : Rectangle
        {
            return this._isoObject.getBounds(param1);
        }// end function

        override protected function onAdd() : void
        {
            super.onAdd();
            if (_displayObject == null)
            {
                _displayObject = this.isoComponent.container;
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
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_6:String = null;
            if (!owner)
            {
                return;
            }
            if (zIndexProperty)
            {
                this.zIndex = owner.getProperty(zIndexProperty, this.zIndex);
            }
            var _loc_1:* = owner.getProperty(positionProperty) as Pt;
            if (_loc_1)
            {
                this.position = _loc_1;
            }
            if (this.positionOffsetProperty != null)
            {
                this.positionOffset = owner.getProperty(this.positionOffsetProperty) as Pt;
            }
            var _loc_2:* = owner.getProperty(scaleProperty) as Point;
            if (_loc_2)
            {
                this.scale = _loc_2;
            }
            if (this.isometricVolumeProperty != null)
            {
                this.isometricVolume = owner.getProperty(this.isometricVolumeProperty) as Pt;
            }
            if (rotationProperty)
            {
                _loc_4 = owner.getProperty(rotationProperty) as Number;
                this.rotation = _loc_4;
            }
            if (alphaProperty)
            {
                _loc_5 = owner.getProperty(alphaProperty) as Number;
                this.alpha = _loc_5;
            }
            if (blendModeProperty)
            {
                _loc_6 = owner.getProperty(blendModeProperty) as String;
                this.blendMode = _loc_6;
            }
            var _loc_3:* = owner.getProperty(registrationPointProperty) as Point;
            if (_loc_3)
            {
                registrationPoint = _loc_3;
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
            if (this.resourcePropertyReference)
            {
                this.resourcePropertyReference = null;
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
                if (!owner.doesPropertyExist(this.resourcePropertyReference))
                {
                    this.removeResourceData();
                }
            }
            return;
        }// end function

        protected function removeResourceData() : void
        {
            return;
        }// end function

        override public function set displayObject(param1:DisplayObject) : void
        {
            Logger.error(this, "set displayObject", "Cannot set displayObject on an IsoComponent; it is always a Sprite containing the underlying AS3Iso Object\'s container");
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
            this.isoComponent.setSize(this._isometricVolume.x, this._isometricVolume.length, this._isometricVolume.y);
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
            this.isoComponent.x = _position.x;
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
            this.isoComponent.y = _position.y;
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
            this.isoComponent.z = Pt(_position).z;
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
            if (this._spatialComponentName != param1)
            {
                this._spatialComponentName = param1;
            }
            this.autoAssignRefs = true;
            this.wireUpPropertyReferences();
            return;
        }// end function

        public static function getFrom(param1:IEntity) : IIsoComponent
        {
            return param1.lookupComponentByType(IsoBaseComponent) as IIsoComponent;
        }// end function

    }
}
